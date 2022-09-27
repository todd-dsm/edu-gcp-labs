#!/usr/bin/env bash
# shellcheck disable=SC2154
# -----------------------------------------------------------------------------
# PURPOSE:  1-time setup for the admin-project and terraform user account.
#           Some controls are necessary at the Organization and project level.
# -----------------------------------------------------------------------------
# PREREQS:  source-in all your environment variables from build.env
# -----------------------------------------------------------------------------
#    EXEC:  scripts/setup/tf-backend-create.sh
# -----------------------------------------------------------------------------
: "${TF_VAR_state_bucket?  I dont have my vars, bro!}"
#set -x

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
### Create the Terraform bucket definition for the backend
###---
cat > backend.tf <<EOF
/*
  -----------------------------------------------------------------------------
                           CENTRALIZED HOME FOR STATE
                           inerpolations NOT allowed
  -----------------------------------------------------------------------------
*/
terraform {
  backend "gcs" {
    bucket = "$TF_VAR_state_bucket"
  }
}
EOF


###---
### fin~
###---
exit 0

