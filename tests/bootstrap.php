<?php
// Mocking global environment for Piwigo
define('PHPWG_ROOT_PATH', __DIR__ . '/../');
define('PHPWG_PLUGINS_PATH', PHPWG_ROOT_PATH . 'plugins/');
if (!defined('ACCESS_ADMINISTRATOR')) {
    define('ACCESS_ADMINISTRATOR', 'admin');
}

// Dummy function to replace core function
if (!function_exists('l10n')) { function l10n($str) { return $str; } }
function get_root_url() {
    return '/';
}

if (!function_exists('check_status')) {
    function check_status($status) {
        return true;
    }
}

global $prefixeTable;
$prefixeTable = 'piwigo_';

// Mock add_event_handler so it doesn't fail when the plugin includes main.inc.php
if (!function_exists('add_event_handler')) {
    function add_event_handler($event, $function, $priority = 50) {
        // Do nothing for tests
    }
}

// Global variable to capture SQL queries for assertions
global $captured_queries, $mock_fetch_assoc_result;
$captured_queries = [];
$mock_fetch_assoc_result = false;

if (!function_exists('pwg_query')) {
    function pwg_query($query) {
        global $captured_queries;
        $captured_queries[] = trim($query);
        return true;
    }
}

if (!function_exists('pwg_db_fetch_assoc')) {
    function pwg_db_fetch_assoc($result) {
        global $mock_fetch_assoc_result;
        return $mock_fetch_assoc_result;
    }
}

// Include the main plugin file to make functions available
require_once __DIR__ . '/../main.inc.php';

// Helper function to reset test state
function reset_captured_queries() {
    global $captured_queries, $mock_fetch_assoc_result;
    $captured_queries = [];
    $mock_fetch_assoc_result = false;
}

// Helper function to get captured queries
function get_captured_queries() {
    global $captured_queries;
    return $captured_queries;
}
