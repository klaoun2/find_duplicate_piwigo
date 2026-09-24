<?php
defined('PHPWG_ROOT_PATH') or die('Hacking attempt!');

global $template, $page;

include_once(PHPWG_ROOT_PATH . 'admin/include/functions.php');
include_once(FIND_DUPLICATES_PATH . 'main.inc.php');

// Handle AJAX scan request
if (isset($_GET['action']) && $_GET['action'] == 'scan')
{
  check_pwg_token();
  
  // Find images without a hash
  $query = '
    SELECT id, path 
    FROM ' . IMAGES_TABLE . ' i
    LEFT JOIN ' . FIND_DUPLICATES_TABLE . ' h ON i.id = h.image_id
    WHERE h.phash IS NULL
    LIMIT 50'; // Process in chunks of 50
    
  $result = pwg_query($query);
  $processed = 0;
  
  while ($row = pwg_db_fetch_assoc($result))
  {
    $filepath = PHPWG_ROOT_PATH . $row['path'];
    $hash = 'failed';
    if (file_exists($filepath))
    {
      $computed = find_duplicates_compute_dhash($filepath);
      if ($computed !== null)
      {
        $hash = $computed;
      }
    }
    
    // Always insert a record so we don't process it again
    pwg_query("REPLACE INTO " . FIND_DUPLICATES_TABLE . " (image_id, phash) VALUES (" . (int)$row['id'] . ", '" . $hash . "')");
    $processed++;
  }
  
  // Get counts to return progress
  $total_query = 'SELECT COUNT(id) AS c FROM ' . IMAGES_TABLE;
  $total_row = pwg_db_fetch_assoc(pwg_query($total_query));
  $total_images = (int)$total_row['c'];
  
  $hashed_query = '
    SELECT COUNT(h.image_id) AS c
    FROM ' . FIND_DUPLICATES_TABLE . ' h
    INNER JOIN ' . IMAGES_TABLE . ' i ON h.image_id = i.id';
  $hashed_row = pwg_db_fetch_assoc(pwg_query($hashed_query));
  $hashed_images = (int)$hashed_row['c'];
  
  echo json_encode(array(
    'processed_in_chunk' => $processed,
    'hashed' => $hashed_images,
    'total' => $total_images,
    'done' => ($processed == 0 || $hashed_images >= $total_images)
  ));
  die();
}

// Helper to calculate Hamming distance for 64-bit string
function find_duplicates_hamming_distance($hash1, $hash2) {
  $dist = 0;
  for ($i = 0; $i < 64; $i++) {
    if ($hash1[$i] !== $hash2[$i]) {
      $dist++;
    }
  }
  return $dist;
}

// User Settings
$similarity_limit = isset($_GET['similarity']) ? (int)$_GET['similarity'] : 100;
if ($similarity_limit < 80) $similarity_limit = 80;
if ($similarity_limit > 100) $similarity_limit = 100;

$same_album = isset($_GET['same_album']) ? (int)$_GET['same_album'] : (!isset($_GET['similarity']) ? 1 : 0);

// Default Page View Data
$total_query = 'SELECT COUNT(id) AS c FROM ' . IMAGES_TABLE;
$total_row = pwg_db_fetch_assoc(pwg_query($total_query));
$total_images = (int)$total_row['c'];

$hashed_query = '
  SELECT COUNT(h.image_id) AS c
  FROM ' . FIND_DUPLICATES_TABLE . ' h
  INNER JOIN ' . IMAGES_TABLE . ' i ON h.image_id = i.id';
$hashed_row = pwg_db_fetch_assoc(pwg_query($hashed_query));
$hashed_images = (int)$hashed_row['c'];

// Find Duplicates
$duplicates = array();
if ($hashed_images > 0 && $hashed_images >= $total_images)
{
  // Calculate max allowed bit difference
  // similarity = 100% -> 0 bits diff
  // similarity = 80%  -> 20% of 64 = ~12 bits diff
  $max_diff = round((100 - $similarity_limit) / 100 * 64);

  $query = '
    SELECT i.id, i.path, i.name, i.file, h.phash, ic.category_id, c.name as cat_name
    FROM ' . FIND_DUPLICATES_TABLE . ' h
    INNER JOIN ' . IMAGES_TABLE . ' i ON h.image_id = i.id
    LEFT JOIN ' . IMAGE_CATEGORY_TABLE . ' ic ON i.id = ic.image_id
    LEFT JOIN ' . CATEGORIES_TABLE . ' c ON ic.category_id = c.id
    WHERE h.phash != \'failed\'';

  $result = pwg_query($query);
  
  $images_data = array();
  while ($row = pwg_db_fetch_assoc($result))
  {
    $img_id = $row['id'];
    if (!isset($images_data[$img_id])) {
      $images_data[$img_id] = array(
        'ID' => $row['id'],
        'PATH' => $row['path'],
        'FILE' => $row['file'],
        'NAME' => $row['name'] ? $row['name'] : $row['file'],
        'URL' => get_root_url() . 'admin.php?page=photo-' . $row['id'],
        'PHASH' => $row['phash'],
        'ALBUMS' => array()
      );
    }
    if ($row['category_id']) {
      $images_data[$img_id]['ALBUMS'][$row['category_id']] = $row['cat_name'];
    }
  }

  // Grouping logic
  $groups = array();
  $processed_ids = array();

  foreach ($images_data as $id1 => $img1) {
    if (isset($processed_ids[$id1])) continue;
    
    $current_group = array($id1);
    
    foreach ($images_data as $id2 => $img2) {
      if ($id1 == $id2) continue;
      if (isset($processed_ids[$id2])) continue;

      // Check Album Condition
      if ($same_album) {
        $shared_albums = array_intersect(array_keys($img1['ALBUMS']), array_keys($img2['ALBUMS']));
        if (empty($shared_albums)) {
          continue; // Not in the same album
        }
      }

      // Check Similarity Condition
      $dist = find_duplicates_hamming_distance($img1['PHASH'], $img2['PHASH']);
      if ($dist <= $max_diff) {
        $current_group[] = $id2;
      }
    }
    
    if (count($current_group) > 1) {
      $groups[] = $current_group;
      foreach ($current_group as $gid) {
        $processed_ids[$gid] = true;
      }
    }
  }

  $album_counts = array();

  foreach ($groups as $group_ids) {
    $group_images = array();
    $album_name = 'Nieznany album';
    $lead_hash = '';

    foreach ($group_ids as $idx => $id) {
      $group_images[] = $images_data[$id];
      if ($idx === 0) {
        $lead_hash = $images_data[$id]['PHASH'];
        if (!empty($images_data[$id]['ALBUMS'])) {
          $album_name = reset($images_data[$id]['ALBUMS']);
        }
      }
    }

    if (!isset($album_counts[$album_name])) {
      $album_counts[$album_name] = 1;
    } else {
      $album_counts[$album_name]++;
    }

    $group_title = $album_name . ' ' . $album_counts[$album_name];

    $duplicates[] = array(
      'PHASH' => $lead_hash . ($max_diff > 0 ? ' (~' . $similarity_limit . '%)' : ''),
      'TITLE' => $group_title,
      'IMAGES' => $group_images
    );
  }
}

$template->assign(array(
  'FD_DUPLICATES' => $duplicates,
  'FD_TOTAL_IMAGES' => $total_images,
  'FD_HASHED_IMAGES' => $hashed_images,
  'FD_ACTION_URL' => FIND_DUPLICATES_ADMIN,
  'PWG_TOKEN' => get_pwg_token(),
  'FD_PAGE_NAME' => isset($_GET['page']) ? $_GET['page'] : 'plugin-' . FIND_DUPLICATES_ID,
  'FD_SIMILARITY' => $similarity_limit,
  'FD_SAME_ALBUM' => $same_album,
));

$template->set_filenames(array('plugin_admin_content' => FIND_DUPLICATES_PATH . 'admin.tpl'));
$template->assign_var_from_handle('ADMIN_CONTENT', 'plugin_admin_content');
