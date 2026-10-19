<?php

// Mocking the function used in the loop
function find_duplicates_hamming_distance($hash1, $hash2) {
  return substr_count($hash1 ^ $hash2, "\x01");
}

function run_benchmark($images_data, $same_album, $max_diff) {
    $groups = array();
    $processed_ids = array();
    $comparisons = 0;

    $start_time = microtime(true);
    $start_memory = memory_get_usage();

    // The optimized logic
    $image_ids = array_keys($images_data);
    $num_images_total = count($image_ids);

    for ($i = 0; $i < $num_images_total; $i++) {
        $id1 = $image_ids[$i];
        if (isset($processed_ids[$id1])) continue;

        $img1 = $images_data[$id1];
        $current_group = array($id1);

        // Start from $i + 1
        for ($j = $i + 1; $j < $num_images_total; $j++) {
            $id2 = $image_ids[$j];
            if (isset($processed_ids[$id2])) continue;

            $img2 = $images_data[$id2];

            // Check Album Condition
            if ($same_album) {
                $shared_albums = array_intersect_key($img1['ALBUMS'], $img2['ALBUMS']);
                if (empty($shared_albums)) {
                    continue; // Not in the same album
                }
            }

            $comparisons++;
            // Check Similarity Condition
            $dist = find_duplicates_hamming_distance($img1['PHASH'], $img2['PHASH']);
            if ($dist <= $max_diff) {
                $current_group[] = $id2;
                $processed_ids[$id2] = true;
            }
        }

        if (count($current_group) > 1) {
            $groups[] = $current_group;
            $processed_ids[$id1] = true; // explicitly mark the lead item
        }
    }

    $end_time = microtime(true);
    $end_memory = memory_get_usage();

    return array(
        'time' => $end_time - $start_time,
        'memory' => $end_memory - $start_memory,
        'groups' => count($groups),
        'comparisons' => $comparisons
    );
}

// Generate test data
$images_data = array();
$num_images = 10000; // back to reasonable size that doesn't timeout
echo "Generating $num_images mock images...\n";

// Generate hashes
for ($i = 0; $i < $num_images; $i++) {
    // To make it run full O(N^2) we make NO groups, so processed_ids is never populated.
    $hash = str_pad((string)($i), 8, "0", STR_PAD_LEFT);
    $images_data['img_' . $i] = array(
        'ID' => $i,
        'PHASH' => $hash,
        'ALBUMS' => array(1 => 'Test')
    );
}

$same_album = false;
$max_diff = -1; // never match so no groups are formed

echo "Running benchmark (Optimized Algorithm)...\n";
$result = run_benchmark($images_data, $same_album, $max_diff);

echo "Time taken: " . number_format($result['time'], 4) . " seconds\n";
echo "Memory used: " . number_format($result['memory'] / 1024 / 1024, 2) . " MB\n";
echo "Groups found: " . $result['groups'] . "\n";
echo "Comparisons made: " . number_format($result['comparisons']) . "\n";
