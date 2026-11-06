<?php
defined('PHPWG_ROOT_PATH') or die('Hacking attempt!');

class find_duplicates_maintain extends PluginMaintain
{
  private $table;

  function __construct($plugin_id)
  {
    parent::__construct($plugin_id);
    global $prefixeTable;
    $this->table = $prefixeTable . 'find_duplicates_hashes';
  }

  private function create_table()
  {
    $query = '
CREATE TABLE IF NOT EXISTS `' . $this->table . '` (
  `image_id` mediumint(8) unsigned NOT NULL,
  `phash` varchar(64) DEFAULT NULL,
  `is_favorite` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`image_id`),
  KEY `phash_idx` (`phash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;';
    pwg_query($query);
  }

  private function upgrade_table()
  {
    if (function_exists('find_duplicates_ensure_favorite_column')) {
      find_duplicates_ensure_favorite_column($this->table);
      return;
    }

    $query = "SHOW COLUMNS FROM `" . $this->table . "` LIKE 'is_favorite'";
    $result = pwg_query($query);
    if (!pwg_db_fetch_assoc($result)) {
      pwg_query("ALTER TABLE `" . $this->table . "` ADD COLUMN `is_favorite` tinyint(1) NOT NULL DEFAULT 0");
    }
  }

  function install($plugin_version, &$errors = array())
  {
    $this->create_table();
  }

  function activate($plugin_version, &$errors = array())
  {
    $this->create_table();
    $this->upgrade_table();

    // Set default config if not exists
    global $conf;
    if (!isset($conf['find_duplicates_similarity'])) {
      conf_update_param('find_duplicates_similarity', 100);
    }
    if (!isset($conf['find_duplicates_same_album'])) {
      conf_update_param('find_duplicates_same_album', 0);
    }
  }

  function deactivate()
  {
    // Do not drop the table on deactivate
  }

  function update($old_version, $new_version, &$errors = array())
  {
    $this->create_table();
    $this->upgrade_table();
  }

  function uninstall()
  {
    pwg_query('DROP TABLE IF EXISTS `' . $this->table . '`;');
    conf_delete_param('find_duplicates_similarity');
    conf_delete_param('find_duplicates_same_album');
    conf_delete_param('find_duplicates_mode');
    conf_delete_param('find_duplicates_filter_album');
    conf_delete_param('find_duplicates_time_interval');
    // Note: find_duplicates_saved_space is intentionally preserved

    if (function_exists('find_duplicates_clear_cache')) {
      find_duplicates_clear_cache(true);
      return;
    }

    $cache_dir = PHPWG_ROOT_PATH . '_data/find_duplicates_cache';
    if (is_dir($cache_dir)) {
      $files = glob($cache_dir . '/*.json');
      if (is_array($files)) {
        foreach ($files as $file) {
          @unlink($file);
        }
      }
      @rmdir($cache_dir);
    }
  }
}
