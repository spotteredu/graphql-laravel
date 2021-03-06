#!/usr/bin/env bash

# Inspired by https://github.com/nunomaduro/larastan/blob/669b489e10558bd45fafc2429068fd4a73843802/tests/laravel-test.sh
#
# Create a fresh Laravel installation, install our package in it and run some
# basic tests to ensure everything works.
#
# This script is meant to be run on CI environments

echo "Install Laravel"
composer create-project --quiet --prefer-dist "laravel/laravel" ../laravel
cd ../laravel

echo "Add package from source"
sed -e 's|"type": "project",|&\n"repositories": [ { "type": "path", "url": "../graphql-laravel" } ],|' -i composer.json
composer require --dev "rebing/graphql-laravel:*"

echo "Publish vendor files"
php artisan vendor:publish --provider="Rebing\GraphQL\GraphQLServiceProvider"

echo "Make GraphQL ExampleQuery"
php artisan make:graphql:query ExampleQuery

echo "Add ExampleQuery to config"
sed -e "s|// ExampleQuery::class,|\\\App\\\GraphQL\\\Queries\\\ExampleQuery::class,|" -i config/graphql.php

echo "Start Webserver"
php -S 127.0.0.1:8001 -t public >/dev/null 2>&1 &
sleep 2

echo "Send GraphQL HTTP request to fetch ExampleQuery"
curl 'http://127.0.0.1:8001/graphql?query=%7Bexample%7D' -sSfLv | grep 'The example works'

if [[ $? = 0 ]]; then
  echo "Example GraphQL query works 👍"
else
  echo "Example GraphQL query DID NOT work 🚨"
  curl 'http://127.0.0.1:8001/graphql?query=%7Bexample%7D' -sSfLv
  cat storage/logs/*
  exit 1
fi

echo "Test accessing GraphiQL"
curl 'http://127.0.0.1:8001/graphiql' -sSfLv | grep '<div id="graphiql">Loading...</div>'

if [[ $? = 0 ]]; then
  echo "Can access GraphiQL 👍"
else
  echo "Cannot access GraphiQL 🚨"
  curl 'http://127.0.0.1:8001/graphiql' -sSfLv
  cat storage/logs/*
  exit 1
fi
