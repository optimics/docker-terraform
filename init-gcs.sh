#!/usr/bin/env bash

set -e

# If there is a terraform dir, assume that all of terraform lives there
if [ -d terraform ]
then
  echo "Entering terraform dir"
  cd terraform
fi

# Write contents of TF_VAR_GOOGLE_CREDENTIALS into a file to initialize 
# the Google Cloud Storage Terraform Backend.
if [ "${TF_VAR_GOOGLE_CREDENTIALS}" != "" ]
then
  export GOOGLE_APPLICATION_CREDENTIALS=$(realpath ./terraform-credentials.json)
  echo -E "$TF_VAR_GOOGLE_CREDENTIALS" > $GOOGLE_APPLICATION_CREDENTIALS
  echo "Stored GCP credentials into $GOOGLE_APPLICATION_CREDENTIALS"

  # Activate the Service Account to enable gcloud access
  gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
  echo "Initialized service account"
else
  echo "TF_VAR_GOOGLE_CREDENTIALS is not set"
  exit 2
fi

# Initialize terraform backend
if [ "${TF_VAR_BUCKET_TERRAFORM}" != "" ]
then
  terraform init -backend-config "bucket=$TF_VAR_BUCKET_TERRAFORM"
  echo "Using ${TF_VAR_BUCKET_TERRAFORM} for GCS backend"
else
  echo "TF_VAR_BUCKET_TERRAFORM is not set"
  exit 3
fi

set +e
