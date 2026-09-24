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
  PRIMARY KEY (`image_id`),
  KEY `phash_idx` (`phash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;';
    pwg_query($query);
  }

  function install($plugin_version, &$errors = array())
  {
    $this->create_table();
  }

  function activate($plugin_version, &$errors = array())
  {
    $this->create_table();
  }

  function deactivate()
  {
    // Do not drop the table on deactivate
  }

  function update($old_version, $new_version, &$errors = array())
  {
    $this->create_table();
  }

  function uninstall()
  {
    pwg_query('DROP TABLE IF EXISTS `' . $this->table . '`;');
  }
}
