<?php

// Create dummy files for benchmark
$test_dir = sys_get_temp_dir() . '/piwigo_test_images';
if (!is_dir($test_dir)) {
    mkdir($test_dir);
}

echo "Generating dummy files...\n";
$paths = [];
for ($i = 0; $i < 10000; $i++) {
    $path = $test_dir . "/test_image_$i.jpg";
    if (!file_exists($path)) {
        file_put_contents($path, str_repeat('a', rand(1024, 1024 * 50))); // 1KB to 50KB
    }
    $paths[] = $path;
}
echo "Dummy files ready.\n";

$duplicates = array_slice($paths, 0, 500); // Only 5% are duplicates

// Approach 1: Synchronous I/O in the main loop (Current)
echo "\n--- Baseline: Synchronous I/O for all images ---\n";
$start_time = microtime(true);
$start_mem = memory_get_usage();
$images_data = [];

// Simulate main loop
foreach ($paths as $path) {
    $bytes = 0;
    if (file_exists($path)) {
        $bytes = filesize($path);
    }
    $images_data[$path] = [
        'PATH' => $path,
        'FILE_SIZE_BYTES' => $bytes
    ];
}

// Simulate group loop
$group_total_bytes = 0;
foreach ($duplicates as $dup_path) {
    $group_total_bytes += $images_data[$dup_path]['FILE_SIZE_BYTES'];
}

$end_time = microtime(true);
$end_mem = memory_get_usage();
$baseline_time = $end_time - $start_time;
echo "Time: " . number_format($baseline_time * 1000, 2) . " ms\n";
echo "Memory: " . number_format(($end_mem - $start_mem) / 1024, 2) . " KB\n";


// Approach 2: Lazy Evaluation (Proposed)
echo "\n--- Optimized: Lazy Evaluation ---\n";
clearstatcache();
$start_time = microtime(true);
$start_mem = memory_get_usage();
$images_data_lazy = [];

// Simulate main loop
foreach ($paths as $path) {
    $images_data_lazy[$path] = [
        'PATH' => $path,
        // No I/O here!
    ];
}

// Simulate group loop
$group_total_bytes_lazy = 0;
foreach ($duplicates as $dup_path) {
    $bytes = 0;
    if (file_exists($dup_path)) {
        $bytes = filesize($dup_path);
    }
    $images_data_lazy[$dup_path]['FILE_SIZE_BYTES'] = $bytes;
    $group_total_bytes_lazy += $bytes;
}

$end_time = microtime(true);
$end_mem = memory_get_usage();
$optimized_time = $end_time - $start_time;
echo "Time: " . number_format($optimized_time * 1000, 2) . " ms\n";
echo "Memory: " . number_format(($end_mem - $start_mem) / 1024, 2) . " KB\n";

echo "\n--- Results ---\n";
$improvement = (($baseline_time - $optimized_time) / $baseline_time) * 100;
echo "Speedup: " . number_format($improvement, 2) . "%\n";

// Cleanup dummy files
echo "\nCleaning up dummy files...\n";
foreach ($paths as $path) {
    if (file_exists($path)) {
        unlink($path);
    }
}
if (is_dir($test_dir)) {
    rmdir($test_dir);
}
echo "Cleanup done.\n";
