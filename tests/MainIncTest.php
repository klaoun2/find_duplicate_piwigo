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
}
