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
  
  $hashed_query = 'SELECT COUNT(image_id) AS c FROM ' . FIND_DUPLICATES_TABLE;
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

// Default Page View Data
$total_query = 'SELECT COUNT(id) AS c FROM ' . IMAGES_TABLE;
$total_row = pwg_db_fetch_assoc(pwg_query($total_query));
$total_images = (int)$total_row['c'];

$hashed_query = 'SELECT COUNT(image_id) AS c FROM ' . FIND_DUPLICATES_TABLE;
$hashed_row = pwg_db_fetch_assoc(pwg_query($hashed_query));
$hashed_images = (int)$hashed_row['c'];

// Find Duplicates
$duplicates = array();
if ($hashed_images > 0 && $hashed_images >= $total_images)
{
  $query = '
    SELECT h.phash, COUNT(*) as c
    FROM ' . FIND_DUPLICATES_TABLE . ' h
    WHERE h.phash != \'failed\'
    GROUP BY h.phash
    HAVING c > 1
    ORDER BY c DESC';
  $result = pwg_query($query);
  
  while ($row = pwg_db_fetch_assoc($result))
  {
    $phash = $row['phash'];
    
    // Fetch images with this hash
    $img_query = '
      SELECT i.id, i.path, i.name, i.file
      FROM ' . IMAGES_TABLE . ' i
      INNER JOIN ' . FIND_DUPLICATES_TABLE . ' h ON i.id = h.image_id
      WHERE h.phash = \'' . $phash . '\'';
    $img_result = pwg_query($img_query);
    
    $group = array(
      'PHASH' => $phash,
      'IMAGES' => array()
    );
    
    while ($img_row = pwg_db_fetch_assoc($img_result))
    {
      $group['IMAGES'][] = array(
        'ID' => $img_row['id'],
        'PATH' => $img_row['path'],
        'FILE' => $img_row['file'],
        'NAME' => $img_row['name'] ? $img_row['name'] : $img_row['file'],
        'URL' => get_root_url() . 'admin.php?page=photo-' . $img_row['id']
      );
    }
    
    $duplicates[] = $group;
  }
}

$template->assign(array(
  'FD_DUPLICATES' => $duplicates,
  'FD_TOTAL_IMAGES' => $total_images,
  'FD_HASHED_IMAGES' => $hashed_images,
  'FD_ACTION_URL' => FIND_DUPLICATES_ADMIN,
  'PWG_TOKEN' => get_pwg_token(),
));

$template->set_filenames(array('plugin_admin_content' => FIND_DUPLICATES_PATH . 'admin.tpl'));
$template->assign_var_from_handle('ADMIN_CONTENT', 'plugin_admin_content');
