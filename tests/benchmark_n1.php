<?php

// Mocking required for benchmark
define('PHPWG_ROOT_PATH', __DIR__ . '/../');

// Generate mock data for the query
$num_records = 500;
$mock_data = [];
for ($i = 0; $i < $num_records; $i++) {
    $mock_data[] = [
        'id' => $i + 1,
        'path' => '/dummy/path/' . $i . '.jpg',
        'hash' => 'dummy_hash_' . $i
    ];
}

// Function to simulate database query execution time
function mock_pwg_query($query) {
    // Simulate query execution time (e.g., 0.1ms per query round trip)
    usleep(100);
    return true;
}

echo "Starting Benchmark: N+1 vs Batch INSERT/REPLACE\n";
echo "Number of records: $num_records\n\n";

// --- Baseline: N+1 (Current approach) ---
echo "--- Baseline: N+1 Queries ---\n";
$start_time = microtime(true);

foreach ($mock_data as $row) {
    // In actual code it calculates hash but we just want to measure query overhead
    $hash = $row['hash'];
    $id = $row['id'];
    mock_pwg_query("REPLACE INTO FIND_DUPLICATES_TABLE (image_id, phash) VALUES ($id, '$hash')");
}

$end_time = microtime(true);
$baseline_time = $end_time - $start_time;
echo "Time: " . number_format($baseline_time * 1000, 2) . " ms\n";

// --- Optimized: Batch Query ---
echo "\n--- Optimized: Batch Query ---\n";
$start_time = microtime(true);

$batch_size = 500;
$values = [];

foreach ($mock_data as $row) {
    $hash = $row['hash'];
    $id = $row['id'];

    $values[] = "($id, '$hash')";

    if (count($values) >= $batch_size) {
        $query = "REPLACE INTO FIND_DUPLICATES_TABLE (image_id, phash) VALUES " . implode(", ", $values);
        mock_pwg_query($query);
        $values = [];
    }
}

if (!empty($values)) {
    $query = "REPLACE INTO FIND_DUPLICATES_TABLE (image_id, phash) VALUES " . implode(", ", $values);
    mock_pwg_query($query);
}

$end_time = microtime(true);
$optimized_time = $end_time - $start_time;
echo "Time: " . number_format($optimized_time * 1000, 2) . " ms\n";

echo "\n--- Results ---\n";
$improvement = (($baseline_time - $optimized_time) / $baseline_time) * 100;
echo "Speedup: " . number_format($improvement, 2) . "%\n";
