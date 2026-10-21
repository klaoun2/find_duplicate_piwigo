<?php
/*
Plugin Name: Find Duplicates
Version: 1.1.1
Description: Tool for finding duplicate and similar images (pHash/dHash/time).
Plugin URI: https://github.com/user/find-duplicates-piwigo
Author: Oban
Has Settings: true
*/

defined('PHPWG_ROOT_PATH') or die('Hacking attempt!');

define('FIND_DUPLICATES_ID', basename(dirname(__FILE__)));
define('FIND_DUPLICATES_PATH', PHPWG_PLUGINS_PATH . FIND_DUPLICATES_ID . '/');
define('FIND_DUPLICATES_ADMIN', get_root_url() . 'admin.php?page=plugin-' . FIND_DUPLICATES_ID);
define('FIND_DUPLICATES_VERSION', '1.1.1');

global $prefixeTable;
define('FIND_DUPLICATES_TABLE', $prefixeTable . 'find_duplicates_hashes');


// -----------------------------------------------------------------
// Difference Hash (dHash) generator
// -----------------------------------------------------------------
function find_duplicates_compute_dhash($filepath)
{
  if (!function_exists('imagecreatefromstring'))
  {
    return null;
  }

  $img_content = @file_get_contents($filepath);
  if (!$img_content) return null;

  $img = @imagecreatefromstring($img_content);
  if (!$img) return null;

  $width = 9;
  $height = 8;
  
  $thumb = imagecreatetruecolor($width, $height);
  if (!$thumb) return null;

  // Convert to grayscale and resize to 9x8
  imagefilter($img, IMG_FILTER_GRAYSCALE);
  imagecopyresampled($thumb, $img, 0, 0, 0, 0, $width, $height, imagesx($img), imagesy($img));

  $hash = '';
  for ($y = 0; $y < $height; $y++) {
    for ($x = 0; $x < $width - 1; $x++) {
      $color1 = imagecolorat($thumb, $x, $y);
      $color2 = imagecolorat($thumb, $x + 1, $y);

      // We only care about luminosity since it's grayscale
      $lum1 = $color1 & 0xFF;
      $lum2 = $color2 & 0xFF;

      $hash .= ($lum1 > $lum2) ? '1' : '0';
    }
  }

unset($thumb);
unset($img);

  return $hash; // 64-bit binary string
}

// -----------------------------------------------------------------
// Hooks
// -----------------------------------------------------------------
add_event_handler('init', 'find_duplicates_init');
function find_duplicates_init()
{
  load_language('plugin.lang', FIND_DUPLICATES_PATH);
}

add_event_handler('loc_end_add_uploaded_file', 'find_duplicates_on_upload');

function find_duplicates_on_upload($image_infos)
{
  if (!isset($image_infos['id']) || !isset($image_infos['path']))
  {
    return;
  }
  
  $filepath = PHPWG_ROOT_PATH . $image_infos['path'];
  if (!file_exists($filepath))
  {
    return;
  }

  $hash = find_duplicates_compute_dhash($filepath);
  
  if ($hash !== null)
  {
    pwg_query("REPLACE INTO " . FIND_DUPLICATES_TABLE . " (image_id, phash) VALUES (" . (int)$image_infos['id'] . ", '" . $hash . "')");
  }
}

// Clean up when an image is deleted
add_event_handler('delete_elements', 'find_duplicates_on_delete');

function find_duplicates_on_delete($ids)
{
  if (empty($ids)) return;

  $query = '
    DELETE FROM ' . FIND_DUPLICATES_TABLE . '
    WHERE image_id IN (' . implode(',', $ids) . ')';
  pwg_query($query);
}


// Add link to the main left menu in admin panel (under Photos)
add_event_handler('loc_begin_admin_page', 'find_duplicates_admin_main_menu');

function find_duplicates_admin_main_menu()
{
  global $template, $page;

  if (isset($page['page'])) {
    $template->assign('U_FIND_DUPLICATES', FIND_DUPLICATES_ADMIN);
    $template->set_prefilter('admin', 'find_duplicates_admin_menu_prefilter');
  }
}

function find_duplicates_admin_menu_prefilter($content)
{
  $search = '<li><a href="{$U_BATCH}"><i class="icon-th"></i>{\'Batch Manager\'|@translate}</a></li>';
  $replace = $search . "\n" . '				<li><a href="{$U_FIND_DUPLICATES}"><i class="icon-docs"></i>{\'Find Duplicates\'|@translate}</a></li>';

  return str_replace($search, $replace, $content);
}

// Admin menu link
add_event_handler('get_admin_plugin_menu_links', 'find_duplicates_admin_menu');
function find_duplicates_admin_menu($menu)
{
  $menu[] = array(
    'NAME' => l10n('Find Duplicates'),
    'URL'  => FIND_DUPLICATES_ADMIN,
  );
  return $menu;
}
