#!/usr/bin/env bash
# shellcheck disable=SC2154
# -----------------------------------------------------------------------------
# PURPOSE:  1-time setup for the admin-project and terraform user account.
#           Some controls are necessary at the Organization and project level.
# -----------------------------------------------------------------------------
#    EXEC:  scripts/setup/bucket-project-create.sh
# -----------------------------------------------------------------------------
#set -x

###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------


###----------------------------------------------------------------------------
### FUNCTIONS
###----------------------------------------------------------------------------
function pMsg() {
    theMessage="$1"
    printf '%s\n' "$theMessage"
}

###----------------------------------------------------------------------------
### MAIN
###----------------------------------------------------------------------------
### Setup Terraform state storage
###----------------------------------------------------------------------------
printf '\n\n%s\n' "Creating a bucket for remote terraform state..."
# Bucket name must be unique to all bucket names
gsutil mb -p "$TF_VAR_project_id" "gs://${TF_VAR_state_bucket}"


###---
### Enable storage versioning
###---
gsutil versioning set on "gs://${TF_VAR_state_bucket}"


###---
### Create the Terraform backend definition for this bucket
###---
scripts/setup/tf-backend-create.sh


###---
### Make the announcement
###---
printf '\n\n%s\n\n' "We're ready to start Terraforming!"


###---
### fin~
###---
exit 0

