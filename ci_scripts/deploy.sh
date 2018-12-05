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

/bin/bash ci_scripts/install_cf_cli.sh;

APP_FULL_NAME="$APP_NAME-$CF_SPACE"

echo "Logging into cloud foundry with api:$CF_API, org:$CF_ORG, space:$CF_SPACE with user:$CF_USER"
cf login -a ${CF_API} -u ${CF_USER} -p "${CF_PASS}" -s ${CF_SPACE} -o ${CF_ORG}

echo "Deploying $APP_FULL_NAME to $CF_SPACE"

APP_VERSION=`cat version.properties | grep "version" | cut -d'=' -f2`
APP_PATH="build/libs/$APP_NAME-$APP_VERSION.jar"

if cf app ${APP_FULL_NAME} >/dev/null 2>/dev/null; then
  echo "$APP_FULL_NAME exists, performing blue-green deployment"

  cf push -p ${APP_PATH} --var suffix=${CF_SPACE}-green
  cf map-route ${APP_FULL_NAME}-green ${CF_DOMAIN} --hostname ${APP_FULL_NAME}
  cf unmap-route ${APP_FULL_NAME} ${CF_DOMAIN} --hostname ${APP_FULL_NAME}
  cf unmap-route ${APP_FULL_NAME}-green ${CF_DOMAIN} --hostname ${APP_FULL_NAME}-green
  cf delete-route -f ${CF_DOMAIN} --hostname ${APP_FULL_NAME}-green
  cf delete -f ${APP_FULL_NAME}
  cf rename ${APP_FULL_NAME}-green ${APP_FULL_NAME}

else
  echo "$APP_FULL_NAME does not exist, doing regular deployment"
  cf push -p ${APP_PATH} --var suffix=${CF_SPACE}
fi