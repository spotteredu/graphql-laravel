<?php

declare(strict_types = 1);
namespace Rebing\GraphQL\Tests\Unit;

use Rebing\GraphQL\Tests\Support\Objects\ExamplesQuery;
use Rebing\GraphQL\Tests\TestCase;

class SchemaHyphenInPathTest extends TestCase
{
    protected function getEnvironmentSetUp($app): void
    {
        parent::getEnvironmentSetUp($app);

        $app['config']->set('graphql.schemas.with-hyphen', [
            'query' => [
                'examples' => ExamplesQuery::class,
            ],
        ]);
    }

    public function testWithHyphen(): void
    {
        $graphql = <<<'GRAPHQL'
{
    examples {
        test
    }
}
GRAPHQL;

        $response = $this->call('GET', '/graphql/with-hyphen', [
            'query' => $graphql,
        ]);

        $result = $response->json();

        $expectedResult = [
            'data' => [
                'examples' => [
                    [
                        'test' => 'Example 1',
                    ],
                    [
                        'test' => 'Example 2',
                    ],
                    [
                        'test' => 'Example 3',
                    ],
                ],
            ],
        ];
        self::assertSame($expectedResult, $result);
    }
}
