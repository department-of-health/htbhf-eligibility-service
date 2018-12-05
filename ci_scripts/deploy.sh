#!/bin/bash

perform_blue_green_deployment() {
  echo "$APP_FULL_NAME exists, performing blue-green deployment"

  cf push -p ${APP_PATH} --var suffix=${CF_SPACE}-green
  cf map-route ${APP_FULL_NAME}-green ${CF_DOMAIN} --hostname ${APP_FULL_NAME}
  unmap_blue_route
  unmap_temporary_route
  cf delete -f ${APP_FULL_NAME}
  cf rename ${APP_FULL_NAME}-green ${APP_FULL_NAME}
}

unmap_blue_route() {
  if cf check-route ${APP_FULL_NAME} ${CF_DOMAIN}; then
    cf unmap-route ${APP_FULL_NAME} ${CF_DOMAIN} --hostname ${APP_FULL_NAME}
  fi
}

unmap_temporary_route() {
  if cf check-route ${APP_FULL_NAME}-green ${CF_DOMAIN}; then
    cf unmap-route ${APP_FULL_NAME}-green ${CF_DOMAIN} --hostname ${APP_FULL_NAME}-green
    cf delete-route -f ${CF_DOMAIN} --hostname ${APP_FULL_NAME}-green
  fi
}

# quit at first error
set -e

export PATH=$PATH:./bin

# if this is a pull request or branch (non-master) build, then just exit
echo "TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST, TRAVIS_BRANCH=$TRAVIS_BRANCH"
if [[ "$TRAVIS_PULL_REQUEST" == "false"  || "$TRAVIS_BRANCH" != "master" ]]; then
   echo "Not tagging pull request or branch build"
   exit
fi

check_variable_is_set(){
    if [[ -z ${!1} ]]; then
        echo "$1 must be set and non empty"
        exit 1
    fi
}
 # check necessary environment variables are set and not empty
check_variable_is_set APP_NAME
check_variable_is_set APP_LOCATION
check_variable_is_set CF_SPACE
check_variable_is_set CF_API
check_variable_is_set CF_ORG
check_variable_is_set CF_USER
check_variable_is_set CF_PASS
check_variable_is_set CF_DOMAIN

/bin/bash ci_scripts/install_cf_cli.sh;

APP_FULL_NAME="$APP_NAME-$CF_SPACE"

echo "Logging into cloud foundry with api:$CF_API, org:$CF_ORG, space:$CF_SPACE with user:$CF_USER"
cf login -a ${CF_API} -u ${CF_USER} -p "${CF_PASS}" -s ${CF_SPACE} -o ${CF_ORG}

echo "Deploying $APP_FULL_NAME to $CF_SPACE"

APP_VERSION=`cat version.properties | grep "version" | cut -d'=' -f2`
APP_PATH="${APP_LOCATION}/$APP_NAME-$APP_VERSION.jar"

if cf app ${APP_FULL_NAME} >/dev/null 2>/dev/null; then
  perform_blue_green_deployment
else
  echo "$APP_FULL_NAME does not exist, doing regular deployment"
  cf push -p ${APP_PATH} --var suffix=${CF_SPACE}
fi