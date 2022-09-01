#!/usr/bin/env sh
PROJECT_ENVIRONMENT="$1"

if [ "${PROJECT_ENVIRONMENT}" = "" ]
then
  # Consider unset environment a staging environment
  PROJECT_ENVIRONMENT=STAGING

  # If this Pipeline runs on a semver tag, consider this
  # the production environment.
  is_semver_tag=$(echo ${BITBUCKET_TAG} | grep "^v")
  if [ "${is_semver_tag}" != "" ]
  then
    PROJECT_ENVIRONMENT=PRODUCTION
  fi
fi

# Consume environment specific variables
# This part de-prefixes variables prefixed with environment name
# For example: STAGING_DEPLOY_CREDENTIALS -> DEPLOY_CREDENTIALS
if [ "${PROJECT_ENVIRONMENT}" != "" ]
then
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
