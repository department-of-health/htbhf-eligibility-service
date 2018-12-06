#!/bin/bash

echo "base url is $1"
cd integration
exit 1
./gradlew clean test -Dbase_url=https://$1