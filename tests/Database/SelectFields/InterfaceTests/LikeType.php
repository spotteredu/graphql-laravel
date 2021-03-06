<?php

declare(strict_types = 1);
namespace Rebing\GraphQL\Tests\Database\SelectFields\InterfaceTests;

use GraphQL\Type\Definition\Type;
use Rebing\GraphQL\Support\Facades\GraphQL;
use Rebing\GraphQL\Support\Type as GraphQLType;
use Rebing\GraphQL\Tests\Support\Models\Like;

class LikeType extends GraphQLType
{
    protected $attributes = [
        'name' => 'Like',
        'model' => Like::class,
    ];

    public function fields(): array
    {
        return [
            'id' => [
                'type' => Type::nonNull(Type::id()),
            ],
            'likable' => [
                'type' => GraphQL::type('LikableInterface'),
            ],
        ];
    }
}
