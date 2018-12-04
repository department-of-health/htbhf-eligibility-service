#!/bin/bash

# quit at first error
set -e

export PATH=$PATH:./bin

# if this is a pull request or branch (non-master) build, then just exit
echo "TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST, TRAVIS_BRANCH=$TRAVIS_BRANCH"
if [[ "$TRAVIS_PULL_REQUEST" == "false"  || "$TRAVIS_BRANCH" != "master" ]]; then
   echo "Not tagging pull request or branch build"
   exit
fi

APP_FULL_NAME="$APP_NAME-$CF_SPACE"

echo "Logging into cloud foundry with api:$CF_API, org:$CF_ORG, space:$CF_SPACE with user:$CF_USER"
cf login -a ${CF_API} -u ${CF_USER} -p "${CF_PASS}" -s ${CF_SPACE} -o ${CF_ORG}

echo "Deploying $APP_FULL_NAME to $CF_SPACE"

APP_VERSION=`cat version.properties | grep "version" | cut -d'=' -f2`
APP_FULL_PATH="build/libs/$APP_NAME-$APP_VERSION.jar"

if cf app ${APP_FULL_NAME} >/dev/null 2>/dev/null; then
  echo "$APP_FULL_NAME exists, performing blue-green deployment"
else
  echo "$APP_FULL_NAME does not exist, doing regular deployment"
  cf push -p ${APP_FULL_PATH} --var space=${CF_SPACE}
fi