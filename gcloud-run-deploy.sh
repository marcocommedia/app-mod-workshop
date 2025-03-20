#!/bin/bash

DEPLOY_VER='1.2'

########################
# CHANGELOG
########################
#
# 4nov24  v1.2 Ecplicited the Project Number
# 8oct24  v1.1b Enabled IAM: for GCE-SA to access SM.
# 8oct24  v1.1 Adding DB_PASS from Secret Manager
# 6oct24  v1.0 All of it.
#
########################


. .env

set -euo pipefail

# --env-vars-file .env doesnt work: it wants a YAML!!!

#    --set-env-vars PORT="80" \
# ERROR: (gcloud.run.deploy) spec.template.spec.containers[0].env: The following reserved env names were provided: PORT. These values are automatically set by the system.
SECRET_MANAGER_PERMAURL_DB_PASS="projects/$PROJECT_NUMBER/secrets/php-amarcord-db-pass"

APP_VERSION="$(cat VERSION)"
# For Riccardo
#    --set-env-vars DB_PASS="$DB_PASS" \
## DB_PASS: projects/839850161816/secrets/php-amarcord-db-pass
gcloud --project "$PROJECT_ID" run deploy \
    php-amarcord-bin \
    --source . \
    --port 80 \
    --set-secrets DB_PASS="$SECRET_MANAGER_PERMAURL_DB_PASS" \
    --set-env-vars DB_USER="$DB_USER" \
    --set-env-vars DB_HOST="$DB_HOST" \
    --set-env-vars DB_NAME="$DB_NAME" \
    --set-env-vars APP_NAME="$APP_NAME (built locally from CLI)" \
    --set-env-vars APP_VERSION="${APP_VERSION}-obsolete-cli" \
    --region europe-west8 \
    --allow-unauthenticated

# Secret mounting:
#--update-secrets=/secrets/api/key=mysecret:latest,ENV=othersecret:1