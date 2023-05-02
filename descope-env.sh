#!/usr/bin/env bash

set -e

PROJECT_ENVIRONMENT="$1"

if [ "${PROJECT_ENVIRONMENT}" = "" ]
then
  # Consider unset environment a staging environment
  PROJECT_ENVIRONMENT=STAGING

  # If this Pipeline runs on a semver tag, consider this
  # the production environment.
  if [ "${BITBUCKET_TAG}" != "" ] && [ "$(echo "${BITBUCKET_TAG}" | grep "^v")" != "" ]
  then
    echo "Detected semver tag"
    PROJECT_ENVIRONMENT=PRODUCTION
  fi

  # If this pipeline contains deployment variable and it has environment
  # behind last dash, attempt to extract the environment from there, mapping:
  # * -sg -> STAGING
  # * -pn -> PRODUCTION
  # * -le -> PRODUCTION
  env_bitbucket=$(echo $BITBUCKET_DEPLOYMENT_ENVIRONMENT | rev | cut -d '-' -f1 | rev)
  if [ "${env_bitbucket}" == "sg" ]; then
    PROJECT_ENVIRONMENT=STAGING
  elif [ "${env_bitbucket}" == "pn" ] || [ "${env_bitbucket}" == "le" ]; then
    PROJECT_ENVIRONMENT=PRODUCTION
  fi
fi

# If we have jq and package.json, then read environment variables
package_path="./package.json"
if [ $( which jq ) ] && [ -f $package_path ]; then
  echo "Checking variables from '${package_path}'"
  vars=$(cat $package_path | jq -c .env)
  if [[ "$vars" != "null" ]]; then
    vars=$(echo $vars | jq -r 'keys[] as $k | "\($k)=\(.[$k])"')
    for item in $vars; do
      export $item
      echo "Imported $(echo $item | cut -d '=' -f1)"
    done
  fi
fi

# Consume environment specific variables
# This part de-prefixes variables prefixed with environment name
# For example: STAGING_DEPLOY_CREDENTIALS -> DEPLOY_CREDENTIALS
if [ "${PROJECT_ENVIRONMENT}" != "" ]
then
  echo "Using environment '${PROJECT_ENVIRONMENT}'"
  env_prefix="${PROJECT_ENVIRONMENT}"
  env_specific=$(printenv | grep "^${env_prefix}_" | cut -d '=' -f1)
  for var_name in $env_specific; do
    # Strip environment name
    env_name=$(echo $var_name | cut -d _ -f2-)
    # Export as a global variable
    eval export $env_name=\$$var_name
    echo "Applied ${env_name}"
  done
fi

set +e
