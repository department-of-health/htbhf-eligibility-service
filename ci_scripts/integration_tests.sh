#!/bin/bash

echo "base url is $1"
cd integration
./gradlew clean test -Dbase_url=https://$1