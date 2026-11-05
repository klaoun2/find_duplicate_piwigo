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

    public function testFindDuplicatesSetGroupFavoriteMarkAll()
    {
        $updated = find_duplicates_set_group_favorite('10,20,10,invalid,-5', 1);

        $this->assertSame([10, 20], $updated);
        $queries = get_captured_queries();
        $this->assertCount(1, $queries);
        $this->assertSame(
            'INSERT INTO piwigo_find_duplicates_hashes (image_id, is_favorite) VALUES (10, 1), (20, 1) ON DUPLICATE KEY UPDATE is_favorite = VALUES(is_favorite)',
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
            'INSERT INTO piwigo_find_duplicates_hashes (image_id, is_favorite) VALUES (101, 0), (102, 0) ON DUPLICATE KEY UPDATE is_favorite = VALUES(is_favorite)',
            $queries[0]
        );
    }

    public function testFindDuplicatesSetGroupFavoriteWithEmptyInput()
    {
        $updated = find_duplicates_set_group_favorite('', 1);

        $this->assertEmpty($updated);
        $this->assertEmpty(get_captured_queries());
    }
}
