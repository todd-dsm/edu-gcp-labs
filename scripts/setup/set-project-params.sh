#!/usr/bin/env bash
# shellcheck disable=SC2154


function pMsg() {
    theMessage="$1"
    printf '\n%s\n' "$theMessage"
}


emailID="$(gcloud auth list --filter=status:ACTIVE --format="value(account)")"
pMsg "Setting project user: $emailID"
gcloud config set account "$emailID"


pMsg "Setting to pre-existing project..."
gcloud config set project "$TF_VAR_project_id"


pMsg "Setting project region and zone..."
gcloud config set compute/region "$TF_VAR_region"
gcloud config set compute/zone   "$TF_VAR_zone"


pMsg "The new project parameters:"
gcloud config configurations list
