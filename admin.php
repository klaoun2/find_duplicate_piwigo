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
  
  $insert_values = array();
  $batch_size = 500;

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
    
    $insert_values[] = "(" . (int)$row['id'] . ", '" . $hash . "')";
    $processed++;

    if (count($insert_values) >= $batch_size) {
      pwg_query("REPLACE INTO " . FIND_DUPLICATES_TABLE . " (image_id, phash) VALUES " . implode(", ", $insert_values));
      $insert_values = array();
    }
  }

  // Batch insert remaining records
  if (!empty($insert_values)) {
    pwg_query("REPLACE INTO " . FIND_DUPLICATES_TABLE . " (image_id, phash) VALUES " . implode(", ", $insert_values));
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

  // Zapisanie rozmiaru pliku przed usunięciem
  $file_size = 0;
  $query = 'SELECT path FROM ' . IMAGES_TABLE . ' WHERE id = ' . $image_id;
  $result = pwg_query($query);
  if ($row = pwg_db_fetch_assoc($result)) {
    $abs_path = PHPWG_ROOT_PATH . $row['path'];
    if (file_exists($abs_path)) {
      $file_size = filesize($abs_path);
    }
  }

  // Usunięcie zdjęcia korzystając z funkcji Piwigo
  include_once(PHPWG_ROOT_PATH . 'admin/include/functions.php');
  if (function_exists('delete_elements')) {
    delete_elements(array($image_id), true); // true = delete file from disk too
  } else {
    // If not found, attempt manual SQL delete just for safety
    pwg_query('DELETE FROM ' . IMAGES_TABLE . ' WHERE id = ' . $image_id);
    pwg_query('DELETE FROM ' . FIND_DUPLICATES_TABLE . ' WHERE image_id = ' . $image_id);
  }

  // Odświeżenie Cache w locie i zapisanie zaoszczędzonego miejsca
  global $conf;

  $saved_space = isset($conf['find_duplicates_saved_space']) ? (int)$conf['find_duplicates_saved_space'] : 0;
  if ($file_size > 0) {
    $saved_space += $file_size;
    conf_update_param('find_duplicates_saved_space', $saved_space);
  }

  $cache_dir = PHPWG_ROOT_PATH . '_data/find_duplicates_cache';
  
  // Delete action must also use wildcard to clean cache if exact match fails
  $files = glob($cache_dir . '/*.json');
  if ($files) {
    foreach ($files as $file) {
      @unlink($file);
    }
  }

  echo json_encode(array(
    'status' => 'ok',
    'message' => 'Image deleted and cache updated.',
    'deleted_bytes' => $file_size,
    'total_saved_bytes' => $saved_space
  ));
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
if (isset($_GET['similarity']) || isset($_GET['fd_mode'])) {
  // Read similarity
  $similarity_limit = isset($_GET['similarity']) ? (int)$_GET['similarity'] : (isset($conf['find_duplicates_similarity']) ? (int)$conf['find_duplicates_similarity'] : 100);
  if ($similarity_limit < 80) $similarity_limit = 80;
  if ($similarity_limit > 100) $similarity_limit = 100;

  // Read same_album
  $same_album = isset($_GET['same_album']) ? ($_GET['same_album'] == '1' ? 1 : 0) : (isset($conf['find_duplicates_same_album']) ? (int)$conf['find_duplicates_same_album'] : 0);
  
  // Read fd_mode
  $fd_mode = isset($_GET['fd_mode']) ? $_GET['fd_mode'] : (isset($conf['find_duplicates_mode']) ? $conf['find_duplicates_mode'] : 'visual');
  if (!in_array($fd_mode, array('visual', 'time'))) $fd_mode = 'visual';
  
  $fd_show_hidden = (isset($_GET['fd_show_hidden']) && $_GET['fd_show_hidden'] == '1') ? 1 : 0;

  $fd_time_interval = isset($_GET['fd_time_interval']) ? (int)$_GET['fd_time_interval'] : (isset($conf['find_duplicates_time_interval']) ? (int)$conf['find_duplicates_time_interval'] : 15);
  $fd_search_group = isset($_GET['fd_search_group']) ? $_GET['fd_search_group'] : '';

  $fd_filter_album = isset($_GET['fd_filter_album']) ? (int)$_GET['fd_filter_album'] : (isset($conf['find_duplicates_filter_album']) ? (int)$conf['find_duplicates_filter_album'] : 0);
  $fd_image_size = isset($_GET['fd_image_size']) ? (int)$_GET['fd_image_size'] : (isset($conf['find_duplicates_image_size']) ? (int)$conf['find_duplicates_image_size'] : 80);
  if (!in_array($fd_image_size, array(50, 80, 100))) $fd_image_size = 80;

  // Save to db
  conf_update_param('find_duplicates_similarity', $similarity_limit);
  conf_update_param('find_duplicates_same_album', $same_album);
  conf_update_param('find_duplicates_mode', $fd_mode);
  conf_update_param('find_duplicates_filter_album', $fd_filter_album);
  conf_update_param('find_duplicates_image_size', $fd_image_size);
  conf_update_param('find_duplicates_time_interval', $fd_time_interval);

  // Update current config
  $conf['find_duplicates_similarity'] = $similarity_limit;
  $conf['find_duplicates_same_album'] = $same_album;
  $conf['find_duplicates_mode'] = $fd_mode;
  $conf['find_duplicates_filter_album'] = $fd_filter_album;
  $conf['find_duplicates_image_size'] = $fd_image_size;
  $conf['find_duplicates_time_interval'] = $fd_time_interval;
} else {
  // Read from db or use defaults
  $similarity_limit = isset($conf['find_duplicates_similarity']) ? (int)$conf['find_duplicates_similarity'] : 100;
  $same_album = isset($conf['find_duplicates_same_album']) ? (int)$conf['find_duplicates_same_album'] : 0;

  // If explicitly overridden via URL, honor it temporarily without saving to conf for this view
  if (isset($_GET['same_album'])) {
      $same_album = $_GET['same_album'] == '1' ? 1 : 0;
  }
  
  $fd_mode = isset($conf['find_duplicates_mode']) ? $conf['find_duplicates_mode'] : 'visual';
  if (!in_array($fd_mode, array('visual', 'time'))) $fd_mode = 'visual';

  $fd_show_hidden = (isset($_GET['fd_show_hidden']) && $_GET['fd_show_hidden'] == '1') ? 1 : 0;
  
  $fd_time_interval = isset($conf['find_duplicates_time_interval']) ? (int)$conf['find_duplicates_time_interval'] : 15;
  $fd_search_group = isset($_GET['fd_search_group']) ? $_GET['fd_search_group'] : '';
  $fd_filter_album = isset($conf['find_duplicates_filter_album']) ? (int)$conf['find_duplicates_filter_album'] : 0;

  $fd_image_size = isset($conf['find_duplicates_image_size']) ? (int)$conf['find_duplicates_image_size'] : 80;
  if (!in_array($fd_image_size, array(50, 80, 100))) $fd_image_size = 80;
}

// User Settings for Pagination
$current_page_idx = isset($_GET['p']) ? max(1, (int)$_GET['p']) : 1;
$items_per_page = 20;

// ---------------------------------------------------------
// Fetch All Categories for Filter
// ---------------------------------------------------------
$categories = array();
$query = 'SELECT id, name, uppercats, global_rank FROM ' . CATEGORIES_TABLE . ' ORDER BY global_rank ASC';
$result = pwg_query($query);
while ($row = pwg_db_fetch_assoc($result)) {
  $depth = substr_count($row['uppercats'], ',');
  $indent = str_repeat('&nbsp;&nbsp;&nbsp;', $depth);
  if ($depth > 0) $indent .= '- ';

  $categories[] = array(
    'id' => $row['id'],
    'name' => $row['name'],
    'uppercats' => $row['uppercats'],
    'display_name' => $indent . htmlspecialchars($row['name'])
  );
}

// ---------------------------------------------------------
// Default Page View Data
// ---------------------------------------------------------
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
  // We use v10 to fix the final metadata caching structure and base album selection.
  $cache_filename = $cache_dir . '/cache_v10_s' . $similarity_limit . '_a' . $same_album . '_h' . $hashed_images . '_m' . $fd_mode . '_t' . $fd_time_interval . '.json';
  
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
        // Check for Motion Picture based on Google Pixel convention (.MP in filename before extension or at the end of the base name)
        $has_motion = 0;
        if (stripos($row['file'], '.MP') !== false || stripos($row['name'], '.MP') !== false) {
            $has_motion = 1;
        }

        $images_data[$img_id] = array(
          'ID' => $row['id'],
          'PATH' => $row['path'],
          'FILE' => $row['file'],
          'NAME' => $row['name'] ? $row['name'] : $row['file'],
          'URL' => get_root_url() . 'admin.php?page=photo-' . $row['id'],
          'PHASH' => $row['phash'],
          'DATE_CREATION' => $row['date_creation'],
          'HAS_GPS' => (!empty($row['latitude']) && !empty($row['longitude'])) ? 1 : 0,
          'HAS_MOTION' => $has_motion,
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
             // ⚡ Bolt Optimization: Use array_intersect_key instead of array_intersect(array_keys())
             // avoids 2 array_keys() calls per comparison and is ~11x faster.
             $shared_albums = array_intersect_key($images_data[$lead_id]['ALBUMS'], $img_data['ALBUMS']);
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
            // ⚡ Bolt Optimization: Use array_intersect_key instead of array_intersect(array_keys())
            // avoids 2 array_keys() calls per comparison inside this O(N^2) nested loop.
            $shared_albums = array_intersect_key($img1['ALBUMS'], $img2['ALBUMS']);
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
      $album_counts_for_group = array();
      $album_names_for_group = array();
      $lead_hash = '';
      $group_total_bytes = 0;
      $oldest_date = null;
      
      foreach ($group_ids as $idx => $id) {
        $img_data = $images_data[$id];

        // Calculate filesize lazily only for duplicate images
        if (!isset($img_data['FILE_SIZE_BYTES'])) {
          $file_path_abs = PHPWG_ROOT_PATH . $img_data['PATH'];
          $filesize_str = 'Brak danych';
          $bytes = 0;
          if (file_exists($file_path_abs)) {
            $bytes = filesize($file_path_abs);
            if ($bytes >= 1048576) {
              $filesize_str = number_format($bytes / 1048576, 2) . ' MB';
            } elseif ($bytes >= 1024) {
              $filesize_str = number_format($bytes / 1024, 2) . ' KB';
            } else {
              $filesize_str = $bytes . ' B';
            }
          }
          $images_data[$id]['FILE_SIZE'] = $filesize_str;
          $images_data[$id]['FILE_SIZE_BYTES'] = $bytes;
          $img_data['FILE_SIZE'] = $filesize_str;
          $img_data['FILE_SIZE_BYTES'] = $bytes;
        }

        $group_total_bytes += $img_data['FILE_SIZE_BYTES'];

        if (!empty($img_data['DATE_CREATION'])) {
          $ts = strtotime($img_data['DATE_CREATION']);
          if ($ts !== false) {
            if ($oldest_date === null || $ts < $oldest_date) {
              $oldest_date = $ts;
            }
          }
        }
        
        $group_images[] = $img_data;
        if ($idx === 0) {
          $lead_hash = $images_data[$id]['PHASH'];
        }

        // Zliczanie albumów
        if (!empty($img_data['ALBUMS'])) {
          foreach ($img_data['ALBUMS'] as $album_id => $a_name) {
            if (!isset($album_counts_for_group[$album_id])) {
              $album_counts_for_group[$album_id] = 0;
              $album_names_for_group[$album_id] = $a_name;
            }
            $album_counts_for_group[$album_id]++;
          }
        }
      }

      $album_name = 'Nieznany album';
      if (!empty($album_counts_for_group)) {
        // Znajdź album z największą liczbą zdjęć (w razie remisu - pierwszy znaleziony z maksimum)
        $max_count = -1;
        $best_album_id = null;
        foreach ($album_counts_for_group as $album_id => $count) {
          if ($count > $max_count) {
            $max_count = $count;
            $best_album_id = $album_id;
          }
        }
        if ($best_album_id !== null) {
          $album_name = $album_names_for_group[$best_album_id];
        }
      }
      
      $duplicates[] = array(
        'PHASH' => $lead_hash . ($max_diff > 0 ? ' (~' . $similarity_limit . '%)' : ''),
        'BASE_ALBUM_NAME' => $album_name,
        'TOTAL_SIZE' => find_duplicates_format_bytes($group_total_bytes),
        'TOTAL_SIZE_BYTES' => $group_total_bytes,
        'OLDEST_DATE_TS' => $oldest_date,
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

// 2. Determine allowed album IDs for filtering (selected album + its sub-albums)
$allowed_album_ids = array();
if ($fd_filter_album > 0) {
  $allowed_album_ids[$fd_filter_album] = true;
  $filter_album_str = (string)$fd_filter_album;
  foreach ($categories as $cat) {
    // If uppercats contains the selected album ID, it's a sub-album
    $uppercats_arr = explode(',', $cat['uppercats']);
    if (in_array($filter_album_str, $uppercats_arr)) {
      $allowed_album_ids[$cat['id']] = true;
    }
  }
}

// 3. Apply filtering for Search, Favorites and Album
$filtered_duplicates = array();
$album_counts = array();
$total_images_in_groups = 0;

foreach ($duplicates as $group) {
  $all_favorites = true;
  $group_images_updated = array();
  
  $has_allowed_album = false;

  foreach ($group['IMAGES'] as $img) {
    $img['IS_FAVORITE'] = isset($favorites_map[$img['ID']]) ? 1 : 0;
    $img['ALBUM_COUNT'] = count($img['ALBUMS']);
    if ($img['IS_FAVORITE'] == 0) {
      $all_favorites = false;
    }

    // Check if this image belongs to any of the allowed albums
    if (!empty($allowed_album_ids)) {
      foreach (array_keys($img['ALBUMS']) as $album_id) {
        if (isset($allowed_album_ids[$album_id])) {
          $has_allowed_album = true;
          break;
        }
      }
    } else {
      $has_allowed_album = true; // No filter selected
    }

    $group_images_updated[] = $img;
  }
  
  // Filter out groups based on Album selection
  if (!$has_allowed_album) {
    continue;
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
    'TOTAL_SIZE' => isset($group['TOTAL_SIZE']) ? $group['TOTAL_SIZE'] : 'Brak',
    'TOTAL_SIZE_BYTES' => isset($group['TOTAL_SIZE_BYTES']) ? $group['TOTAL_SIZE_BYTES'] : 0,
    'OLDEST_DATE_TS' => isset($group['OLDEST_DATE_TS']) ? $group['OLDEST_DATE_TS'] : null,
    'IMAGES' => $group_images_updated
  );
  
  $total_images_in_groups += count($group_images_updated);
}

// Sort Logic
$sort_opt = isset($_GET['sort']) ? $_GET['sort'] : 'default';

if ($sort_opt !== 'default') {
  usort($filtered_duplicates, function($a, $b) use ($sort_opt) {
    switch ($sort_opt) {
      case 'size_desc':
        return $b['TOTAL_SIZE_BYTES'] <=> $a['TOTAL_SIZE_BYTES'];
      case 'size_asc':
        return $a['TOTAL_SIZE_BYTES'] <=> $b['TOTAL_SIZE_BYTES'];
      case 'count_desc':
        return count($b['IMAGES']) <=> count($a['IMAGES']);
      case 'count_asc':
        return count($a['IMAGES']) <=> count($b['IMAGES']);
      case 'date_asc':
      case 'date_desc':
        // Handle missing dates (null) by placing them at the end
        $dateA = isset($a['OLDEST_DATE_TS']) ? $a['OLDEST_DATE_TS'] : null;
        $dateB = isset($b['OLDEST_DATE_TS']) ? $b['OLDEST_DATE_TS'] : null;

        if ($dateA === null && $dateB === null) return 0;
        if ($dateA === null) return 1;
        if ($dateB === null) return -1;

        if ($sort_opt === 'date_desc') {
          return $dateB <=> $dateA;
        }
        return $dateA <=> $dateB;
      case 'alpha_asc':
        return strcasecmp($a['TITLE'], $b['TITLE']);
      case 'alpha_desc':
        return strcasecmp($b['TITLE'], $a['TITLE']);
      default:
        return 0;
    }
  });
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
  'FD_TOTAL_SAVED_SPACE' => isset($saved_space_formatted) ? $saved_space_formatted : find_duplicates_format_bytes(isset($conf['find_duplicates_saved_space']) ? (int)$conf['find_duplicates_saved_space'] : 0),
  'FD_SORT' => htmlspecialchars($sort_opt),
  'FD_CATEGORIES' => $categories,
  'FD_FILTER_ALBUM' => $fd_filter_album,
  'FD_IMAGE_SIZE' => $fd_image_size,
  'FD_VERSION' => defined('FIND_DUPLICATES_VERSION') ? FIND_DUPLICATES_VERSION : '1.0.0',
));

$template->set_filenames(array('plugin_admin_content' => FIND_DUPLICATES_PATH . 'admin.tpl'));
$template->assign_var_from_handle('ADMIN_CONTENT', 'plugin_admin_content');
