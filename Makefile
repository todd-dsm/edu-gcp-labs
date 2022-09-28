#!/usr/bin/env make
# vim: tabstop=8 noexpandtab
SHELL := /usr/bin/env bash

# Grab some ENV stuff
TF_VAR_build_env	?= $(shell $(TF_VAR_build_env))
TF_VAR_project_id	?= $(shell $(TF_VAR_project_id))

prep:	## Prepare for the build
	@scripts/setup/set-project-params.sh
	@printf '\n\n%s\n\n' "IF THIS LOOKS CORRECT YOU ARE CLEAR TO TERRAFORM"

# Start Terraforming
all:    init plan apply

init:	## Initialize the build
	terraform init -get=true -backend=true -upgrade=true -reconfigure

plan:	## Run and Plan the build with output log
	terraform fmt -recursive=true
	terraform plan -no-color 2>&1 | \
		tee /tmp/tf-$(TF_VAR_project_id)-plan.out

apply:	## Build Terraform project with output log
	terraform apply --auto-approve -no-color \
		-input=false "$(planFile)" 2>&1 | \
		tee /tmp/tf-$(TF_VAR_project_id)-apply.out

clean:	## Clean WARNING Message
	@echo ""
	@echo "Destroy $(TF_VAR_project)?"
	@echo ""
	@echo "    ***** STOP, THINK ABOUT THIS *****"
	@echo "You're about to DESTROY ALL that we have built"
	@echo ""
	@echo "IF YOU'RE CERTAIN, THEN 'make destroy'"
	@echo ""
	@exit

destroy:	## Destroy Terraformed resources and all generated files with output log
	terraform apply -destroy -auto-approve -no-color 2>&1 | \
		tee "/tmp/tf-${TF_VAR_project_id}-destroy.out"


#-----------------------------------------------------------------------------#
#------------------------   MANAGERIAL OVERHEAD   ----------------------------#
#-----------------------------------------------------------------------------#
print-%  : ## Print any variable from the Makefile (e.g. make print-VARIABLE);
	@echo $* = $($*)

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

