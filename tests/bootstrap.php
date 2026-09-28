<?php
// Mocking global environment for Piwigo
define('PHPWG_ROOT_PATH', __DIR__ . '/../');
define('PHPWG_PLUGINS_PATH', PHPWG_ROOT_PATH . 'plugins/');

// Dummy function to replace core function
function get_root_url() {
    return '/';
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
global $captured_queries;
$captured_queries = [];

if (!function_exists('pwg_query')) {
    function pwg_query($query) {
        global $captured_queries;
        $captured_queries[] = trim($query);
        return true;
    }
}

// Include the main plugin file to make functions available
require_once __DIR__ . '/../main.inc.php';

// Helper function to reset test state
function reset_captured_queries() {
    global $captured_queries;
    $captured_queries = [];
}

// Helper function to get captured queries
function get_captured_queries() {
    global $captured_queries;
    return $captured_queries;
}
