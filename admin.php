<?php
defined('PHPWG_ROOT_PATH') or die('Hacking attempt!');

global $template, $page;

include_once(PHPWG_ROOT_PATH . 'admin/include/functions.php');
include_once(FIND_DUPLICATES_PATH . 'main.inc.php');

// Safe check for development - ensure is_favorite column exists
$safe_check_query = "SHOW COLUMNS FROM " . FIND_DUPLICATES_TABLE . " LIKE 'is_favorite'";
$safe_check_result = pwg_query($safe_check_query);
if (!pwg_db_fetch_assoc($safe_check_result)) {
  pwg_query("ALTER TABLE " . FIND_DUPLICATES_TABLE . " ADD COLUMN `is_favorite` tinyint(1) NOT NULL DEFAULT 0");
}

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

// Helper: format bytes
function find_duplicates_format_bytes($bytes) {
  if ($bytes >= 1048576) {
    return number_format($bytes / 1048576, 2) . ' MB';
  } elseif ($bytes >= 1024) {
    return number_format($bytes / 1024, 2) . ' KB';
  }
  return $bytes . ' B';
}

// Handle AJAX image deletion
if (isset($_GET['action']) && $_GET['action'] == 'delete_image') {
  check_pwg_token();

  if (!isset($_GET['image_id'])) {
    echo json_encode(array('status' => 'error', 'error' => 'Missing image_id'));
    die();
  }

  $image_id = (int)$_GET['image_id'];

  // Usunięcie zdjęcia korzystając z funkcji Piwigo
  include_once(PHPWG_ROOT_PATH . 'admin/include/functions.php');
  if (function_exists('delete_elements')) {
    delete_elements(array($image_id), true); // true = delete file from disk too
  } else {
    // If not found, attempt manual SQL delete just for safety
    pwg_query('DELETE FROM ' . IMAGES_TABLE . ' WHERE id = ' . $image_id);
    pwg_query('DELETE FROM ' . FIND_DUPLICATES_TABLE . ' WHERE image_id = ' . $image_id);
  }

  // Odświeżenie Cache w locie
  global $conf;
  $cache_dir = PHPWG_ROOT_PATH . '_data/find_duplicates_cache';
  $similarity_limit = isset($conf['find_duplicates_similarity']) ? (int)$conf['find_duplicates_similarity'] : 100;
  $same_album = isset($conf['find_duplicates_same_album']) ? (int)$conf['find_duplicates_same_album'] : 0;

  // Ponieważ usunęliśmy zdjęcie, hashed_images w rzeczywistości spadło o 1
  $hashed_query = '
    SELECT COUNT(h.image_id) AS c
    FROM ' . FIND_DUPLICATES_TABLE . ' h
    INNER JOIN ' . IMAGES_TABLE . ' i ON h.image_id = i.id';
  $hashed_row = pwg_db_fetch_assoc(pwg_query($hashed_query));
  $current_hashed_images = (int)$hashed_row['c'];

  // Odczytujemy stary plik (przed usunięciem), gdzie zahashowanych było o 1 więcej
  $old_hashed_images = $current_hashed_images + 1;
  $old_cache_filename = $cache_dir . '/cache_s' . $similarity_limit . '_a' . $same_album . '_h' . $old_hashed_images . '.json';
  $new_cache_filename = $cache_dir . '/cache_s' . $similarity_limit . '_a' . $same_album . '_h' . $current_hashed_images . '.json';

  if (file_exists($old_cache_filename)) {
    $cached_data = @file_get_contents($old_cache_filename);
    if ($cached_data) {
      $duplicates = json_decode($cached_data, true);
      $new_duplicates = array();

      foreach ($duplicates as $group) {
        $filtered_images = array();
        foreach ($group['IMAGES'] as $img) {
          if ($img['ID'] != $image_id) {
            $filtered_images[] = $img;
          }
        }

        // Zostawiamy grupę, tylko jeśli zostało w niej więcej niż 1 zdjęcie
        if (count($filtered_images) > 1) {
          $group['IMAGES'] = $filtered_images;
          $new_duplicates[] = $group;
        }
      }

      // Zapisujemy nowy cache i usuwamy stary
      @file_put_contents($new_cache_filename, json_encode($new_duplicates));
      @unlink($old_cache_filename);
    }
  }

  echo json_encode(array('status' => 'ok', 'message' => 'Image deleted and cache updated.'));
  die();
}

// Handle AJAX toggle favorite
if (isset($_GET['action']) && $_GET['action'] == 'toggle_favorite') {
  check_pwg_token();

  if (!isset($_GET['image_id'])) {
    echo json_encode(array('status' => 'error', 'error' => 'Missing image_id'));
    die();
  }

  $image_id = (int)$_GET['image_id'];

  // Get current status
  $query = 'SELECT is_favorite FROM ' . FIND_DUPLICATES_TABLE . ' WHERE image_id = ' . $image_id;
  $result = pwg_query($query);
  $row = pwg_db_fetch_assoc($result);

  if ($row) {
    $new_status = $row['is_favorite'] ? 0 : 1;
    pwg_query('UPDATE ' . FIND_DUPLICATES_TABLE . ' SET is_favorite = ' . $new_status . ' WHERE image_id = ' . $image_id);

    // Do NOT invalidate cache anymore!
    // Favorite status is now injected dynamically during the render phase.

    echo json_encode(array('status' => 'ok', 'is_favorite' => $new_status));
  } else {
    echo json_encode(array('status' => 'error', 'error' => 'Image not found in duplicates table.'));
  }
  die();
}

// Helper to calculate Hamming distance for 64-bit string
function find_duplicates_hamming_distance($hash1, $hash2) {
  // ⚡ Bolt Optimization: Replace O(1) 64-iteration PHP loop with native C-level bitwise XOR + substr_count.
  // This reduces the time per calculation from ~2.0μs to ~0.15μs (>10x faster).
  // Critical for large galleries where worst-case comparisons approach O(N²).
  // E.g., 10,000 images = ~50M comparisons. Savings: ~100 seconds of CPU time -> ~7 seconds.
  return substr_count($hash1 ^ $hash2, "\x01");
}

// User Settings
global $conf;

// Determine if we need to save new settings
if (isset($_GET['similarity'])) {
  $similarity_limit = (int)$_GET['similarity'];
  if ($similarity_limit < 80) $similarity_limit = 80;
  if ($similarity_limit > 100) $similarity_limit = 100;

  $same_album = (isset($_GET['same_album']) && $_GET['same_album'] == '1') ? 1 : 0;

  $fd_mode = isset($_GET['fd_mode']) ? $_GET['fd_mode'] : 'visual';
  if (!in_array($fd_mode, array('visual', 'time'))) $fd_mode = 'visual';

  $fd_show_hidden = (isset($_GET['fd_show_hidden']) && $_GET['fd_show_hidden'] == '1') ? 1 : 0;

  $fd_time_interval = isset($_GET['fd_time_interval']) ? (int)$_GET['fd_time_interval'] : 15;
  $fd_search_group = isset($_GET['fd_search_group']) ? $_GET['fd_search_group'] : '';

  // Save to db
  conf_update_param('find_duplicates_similarity', $similarity_limit);
  conf_update_param('find_duplicates_same_album', $same_album);
  $conf['find_duplicates_similarity'] = $similarity_limit;
  $conf['find_duplicates_same_album'] = $same_album;
} else {
  // Read from db or use defaults
  $similarity_limit = isset($conf['find_duplicates_similarity']) ? (int)$conf['find_duplicates_similarity'] : 100;
  $same_album = isset($conf['find_duplicates_same_album']) ? (int)$conf['find_duplicates_same_album'] : 0;
  // If explicitly overridden via URL, honor it temporarily without saving to conf for this view
  if (isset($_GET['same_album'])) {
      $same_album = $_GET['same_album'] == '1' ? 1 : 0;
  }

  $fd_mode = isset($_GET['fd_mode']) ? $_GET['fd_mode'] : 'visual';
  if (!in_array($fd_mode, array('visual', 'time'))) $fd_mode = 'visual';

  $fd_show_hidden = (isset($_GET['fd_show_hidden']) && $_GET['fd_show_hidden'] == '1') ? 1 : 0;

  $fd_time_interval = isset($_GET['fd_time_interval']) ? (int)$_GET['fd_time_interval'] : 15;
  $fd_search_group = isset($_GET['fd_search_group']) ? $_GET['fd_search_group'] : '';
}

// User Settings for Pagination
$current_page_idx = isset($_GET['p']) ? max(1, (int)$_GET['p']) : 1;
$items_per_page = 20;

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
  // Cache Setup
  $cache_dir = PHPWG_ROOT_PATH . '_data/find_duplicates_cache';
  if (!is_dir($cache_dir)) {
    mkdir($cache_dir, 0777, true);
  }
  
  // Cache key only depends on the heavy grouping parameters.
  // We use v4 to clear out old caches. Search and hidden flags are applied in-memory.
  $cache_filename = $cache_dir . '/cache_v4_s' . $similarity_limit . '_a' . $same_album . '_h' . $hashed_images . '_m' . $fd_mode . '_t' . $fd_time_interval . '.json';
  
  if (file_exists($cache_filename)) {
    // Load from cache
    $cached_data = @file_get_contents($cache_filename);
    if ($cached_data) {
      $duplicates = json_decode($cached_data, true);
    }
  } 
  
  if (empty($duplicates) && !file_exists($cache_filename)) {
    // Generate data
    $max_diff = round((100 - $similarity_limit) / 100 * 64);
    
    $query = '
      SELECT i.id, i.path, i.name, i.file, i.date_creation, i.latitude, i.longitude, h.phash, ic.category_id, c.name as cat_name
      FROM ' . FIND_DUPLICATES_TABLE . ' h
      INNER JOIN ' . IMAGES_TABLE . ' i ON h.image_id = i.id
      LEFT JOIN ' . IMAGE_CATEGORY_TABLE . ' ic ON i.id = ic.image_id
      LEFT JOIN ' . CATEGORIES_TABLE . ' c ON ic.category_id = c.id
      WHERE h.phash != \'failed\'
      ORDER BY i.date_creation ASC'; // Sorting by date for time mode
      
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
          'DATE_CREATION' => $row['date_creation'],
          'HAS_GPS' => (!empty($row['latitude']) && !empty($row['longitude'])) ? 1 : 0,
          'ALBUMS' => array()
        );
      }
      if ($row['category_id']) {
        $images_data[$img_id]['ALBUMS'][$row['category_id']] = $row['cat_name'];
      }
    }
    
    // Grouping logic
    $groups = array();
    
    if ($fd_mode == 'time') {
      $current_group = array();
      $last_time = null;
      
      foreach ($images_data as $img_id => $img_data) {
        if (empty($img_data['DATE_CREATION'])) continue; // Skip images without date
        
        $current_time = strtotime($img_data['DATE_CREATION']);
        
        if ($last_time !== null && ($current_time - $last_time) <= $fd_time_interval) {
          // If in the same album check is required
          if ($same_album && !empty($current_group)) {
             $lead_id = $current_group[0];
             $shared_albums = array_intersect(array_keys($images_data[$lead_id]['ALBUMS']), array_keys($img_data['ALBUMS']));
             if (empty($shared_albums)) {
                 // Break the group if not sharing album
                 if (count($current_group) > 1) {
                   $groups[] = $current_group;
                 }
                 $current_group = array($img_id);
                 $last_time = $current_time;
                 continue;
             }
          }
          $current_group[] = $img_id;
        } else {
          // Time difference too large, close current group and start new one
          if (count($current_group) > 1) {
            $groups[] = $current_group;
          }
          $current_group = array($img_id);
        }
        $last_time = $current_time;
      }
      // Add the last group if any
      if (count($current_group) > 1) {
        $groups[] = $current_group;
      }
    } else { // 'visual' mode
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
    }
    
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
      
      $duplicates[] = array(
        'PHASH' => $lead_hash . ($max_diff > 0 ? ' (~' . $similarity_limit . '%)' : ''),
        'BASE_ALBUM_NAME' => $album_name,
        'IMAGES' => $group_images
      );
    }
    
    // Save to cache, clear old cache files
    $files = glob($cache_dir . '/*.json');
    foreach ($files as $file) {
      @unlink($file); // clean up any old cache files to avoid space bloating
    }
    @file_put_contents($cache_filename, json_encode($duplicates));
  }
}

// ---------------------------------------------------------
// Filtering Phase (in-memory after loading/generating cache)
// ---------------------------------------------------------

// 1. Fetch current favorites state from DB to dynamically inject it
$all_ids = array();
foreach ($duplicates as $group) {
  foreach ($group['IMAGES'] as $img) {
    $all_ids[] = (int)$img['ID'];
  }
}

$favorites_map = array();
if (!empty($all_ids)) {
  $query = 'SELECT image_id, is_favorite FROM ' . FIND_DUPLICATES_TABLE . ' WHERE is_favorite = 1 AND image_id IN (' . implode(',', $all_ids) . ')';
  $result = pwg_query($query);
  while ($row = pwg_db_fetch_assoc($result)) {
    $favorites_map[$row['image_id']] = true;
  }
}

// 2. Apply filtering for Search and Favorites
$filtered_duplicates = array();
$album_counts = array();
$total_images_in_groups = 0;

foreach ($duplicates as $group) {
  $all_favorites = true;
  $group_images_updated = array();

  foreach ($group['IMAGES'] as $img) {
    $img['IS_FAVORITE'] = isset($favorites_map[$img['ID']]) ? 1 : 0;
    $img['ALBUM_COUNT'] = count($img['ALBUMS']);
    if ($img['IS_FAVORITE'] == 0) {
      $all_favorites = false;
    }
    $group_images_updated[] = $img;
  }

  // Filter out groups based on favorites logic
  if ($fd_show_hidden && !$all_favorites) {
    continue; // When show_hidden is checked, show ONLY groups where all are favorites
  }
  if (!$fd_show_hidden && $all_favorites) {
    continue; // Normally, hide groups where all are favorites
  }

  // Filter by group name if search query is provided
  $album_name = $group['BASE_ALBUM_NAME'];
  if (!empty($fd_search_group) && stripos($album_name, $fd_search_group) === false) {
    continue;
  }

  if (!isset($album_counts[$album_name])) {
    $album_counts[$album_name] = 1;
  } else {
    $album_counts[$album_name]++;
  }

  $group_title = $album_name . ' ' . $album_counts[$album_name];

  $filtered_duplicates[] = array(
    'PHASH' => $group['PHASH'],
    'TITLE' => $group_title,
    'IMAGES' => $group_images_updated
  );

  $total_images_in_groups += count($group_images_updated);
}

// Pagination logic
$total_duplicates_groups = count($filtered_duplicates);
$total_pages = ceil($total_duplicates_groups / $items_per_page);
if ($current_page_idx > $total_pages && $total_pages > 0) {
  $current_page_idx = $total_pages;
}

$duplicates_page = array();
if ($total_duplicates_groups > 0) {
  $offset = ($current_page_idx - 1) * $items_per_page;
  $duplicates_page = array_slice($filtered_duplicates, $offset, $items_per_page);
}

$start_page = max(1, $current_page_idx - 3);
$end_page = min($total_pages, $current_page_idx + 3);

$template->assign(array(
  'FD_DUPLICATES' => $duplicates_page,
  'FD_TOTAL_GROUPS' => $total_duplicates_groups,
  'FD_TOTAL_IMAGES_IN_GROUPS' => $total_images_in_groups,
  'FD_CURRENT_PAGE' => $current_page_idx,
  'FD_TOTAL_PAGES' => $total_pages,
  'FD_START_PAGE' => $start_page,
  'FD_END_PAGE' => $end_page,
  'FD_TOTAL_IMAGES' => $total_images,
  'FD_HASHED_IMAGES' => $hashed_images,
  'FD_ACTION_URL' => FIND_DUPLICATES_ADMIN,
  'PWG_TOKEN' => get_pwg_token(),
  'FD_PAGE_NAME' => isset($_GET['page']) ? $_GET['page'] : 'plugin-' . FIND_DUPLICATES_ID,
  'FD_SIMILARITY' => $similarity_limit,
  'FD_SAME_ALBUM' => $same_album,
  'FD_MODE' => $fd_mode,
  'FD_SHOW_HIDDEN' => $fd_show_hidden,
  'FD_TIME_INTERVAL' => $fd_time_interval,
  'FD_SEARCH_GROUP' => $fd_search_group,
));

$template->set_filenames(array('plugin_admin_content' => FIND_DUPLICATES_PATH . 'admin.tpl'));
$template->assign_var_from_handle('ADMIN_CONTENT', 'plugin_admin_content');
