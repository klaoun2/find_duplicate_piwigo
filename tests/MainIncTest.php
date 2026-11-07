<?php
use PHPUnit\Framework\TestCase;

class MainIncTest extends TestCase
{
    protected function setUp(): void
    {
        // Reset query log before each test
        reset_captured_queries();
    }

    public function testFindDuplicatesOnDeleteWithEmptyIds()
    {
        // Act
        find_duplicates_on_delete([]);

        // Assert
        $queries = get_captured_queries();
        $this->assertEmpty($queries, 'No queries should be executed when IDs array is empty.');
    }

    public function testFindDuplicatesOnDeleteWithValidIds()
    {
        // Arrange
        $ids = [1, 2, 5];

        // Act
        find_duplicates_on_delete($ids);

        // Assert
        $queries = get_captured_queries();
        $this->assertCount(1, $queries, 'Exactly one query should be executed.');

        $query = preg_replace('/\s+/', ' ', $queries[0]);
        $expectedPattern = '/DELETE FROM piwigo_find_duplicates_hashes WHERE image_id IN \(1,2,5\)/';
        $this->assertMatchesRegularExpression($expectedPattern, $query, 'The query should delete elements by their IDs.');
    }

    public function testFindDuplicatesOnDeleteWithMaliciousOrInvalidIds()
    {
        // Act with string containing SQL injection payload and invalid values
        find_duplicates_on_delete(['1 OR 1=1', 'abc', -10, 0, 7]);

        // Assert
        $queries = get_captured_queries();
        $this->assertCount(1, $queries, 'Query should be executed for sanitized positive integers.');
        $query = preg_replace('/\s+/', ' ', $queries[0]);
        $this->assertSame('DELETE FROM piwigo_find_duplicates_hashes WHERE image_id IN (1,7)', $query);
    }

    public function testFindDuplicatesOnDeleteWithAllInvalidIds()
    {
        find_duplicates_on_delete(['abc', 'xyz', -1, 0]);
        $this->assertEmpty(get_captured_queries(), 'No queries should be executed if no positive integers found.');
    }

    public function testFindDuplicatesSetGroupFavoriteMarkAll()
    {
        $updated = find_duplicates_set_group_favorite('10,20,10,invalid,-5', 1);

        $this->assertSame([10, 20], $updated);
        $queries = get_captured_queries();
        $this->assertCount(1, $queries);
        $this->assertSame(
            'INSERT INTO piwigo_find_duplicates_hashes (image_id, is_favorite) VALUES (10, 1), (20, 1) ON DUPLICATE KEY UPDATE is_favorite = 1',
            $queries[0]
        );
    }

    public function testFindDuplicatesSetGroupFavoriteUnmarkAll()
    {
        $updated = find_duplicates_set_group_favorite([101, 102], 0);

        $this->assertSame([101, 102], $updated);
        $queries = get_captured_queries();
        $this->assertCount(1, $queries);
        $this->assertSame(
            'INSERT INTO piwigo_find_duplicates_hashes (image_id, is_favorite) VALUES (101, 0), (102, 0) ON DUPLICATE KEY UPDATE is_favorite = 0',
            $queries[0]
        );
    }

    public function testFindDuplicatesSetGroupFavoriteWithEmptyInput()
    {
        $updated = find_duplicates_set_group_favorite('', 1);

        $this->assertEmpty($updated);
        $this->assertEmpty(get_captured_queries());
    }

    public function testEnsureFavoriteColumnAddsColumnWhenMissing()
    {
        global $mock_fetch_assoc_result;
        $mock_fetch_assoc_result = false;

        find_duplicates_ensure_favorite_column();

        $queries = get_captured_queries();
        $this->assertCount(2, $queries);
        $this->assertSame("SHOW COLUMNS FROM `piwigo_find_duplicates_hashes` LIKE 'is_favorite'", $queries[0]);
        $this->assertSame("ALTER TABLE `piwigo_find_duplicates_hashes` ADD COLUMN `is_favorite` tinyint(1) NOT NULL DEFAULT 0", $queries[1]);
    }

    public function testEnsureFavoriteColumnSkipsAlterWhenPresent()
    {
        global $mock_fetch_assoc_result;
        $mock_fetch_assoc_result = ['Field' => 'is_favorite'];

        find_duplicates_ensure_favorite_column();

        $queries = get_captured_queries();
        $this->assertCount(1, $queries);
        $this->assertSame("SHOW COLUMNS FROM `piwigo_find_duplicates_hashes` LIKE 'is_favorite'", $queries[0]);
    }

    public function testFindDuplicatesIsMotionPhoto()
    {
        // Positive matches (Pixel, Samsung, Google Camera)
        $this->assertSame(1, find_duplicates_is_motion_photo('PXL_20230501_123456.MP.jpg'));
        $this->assertSame(1, find_duplicates_is_motion_photo('PXL_20230501_123456.PORTRAIT.MP.jpg'));
        $this->assertSame(1, find_duplicates_is_motion_photo('PXL_20230501_123456.MP'));
        $this->assertSame(1, find_duplicates_is_motion_photo('MVIMG_20190101_120000.jpg'));
        $this->assertSame(1, find_duplicates_is_motion_photo('20230101_120000_MotionPhoto.jpg'));
        $this->assertSame(1, find_duplicates_is_motion_photo('MotionPhoto_20230101_120000.jpg'));
        $this->assertSame(1, find_duplicates_is_motion_photo('custom_name.jpg', 'PXL_20230501_123456.MP'));

        // Negative matches (Videos, Audio, regular photos)
        $this->assertSame(0, find_duplicates_is_motion_photo('video.mp4'));
        $this->assertSame(0, find_duplicates_is_motion_photo('sample.MP4'));
        $this->assertSame(0, find_duplicates_is_motion_photo('audio.mp3'));
        $this->assertSame(0, find_duplicates_is_motion_photo('camping.jpg'));
        $this->assertSame(0, find_duplicates_is_motion_photo('my_photo.png'));
        $this->assertSame(0, find_duplicates_is_motion_photo('PXL_20230501_123456.MP.mp4'));
    }
}
