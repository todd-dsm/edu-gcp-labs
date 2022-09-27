#!/usr/bin/env make
# vim: tabstop=8 noexpandtab
SHELL := /bin/bash 

# Grab some ENV stuff
KUBECONFIG		?= $(shell $((KUBECONFIG))
TF_VAR_envBuild		?= $(shell $(TF_VAR_envBuild))
TF_VAR_cluster_apps	?= $(shell $(TF_VAR_cluster_apps))
TF_VAR_cluster_vault	?= $(shell $(TF_VAR_cluster_vault))
planFile		?= $(shell $(planFile))

# Start Terraforming
prep:	## Prepare for the build
	@scripts/setup/set-project-params.sh
	@printf '\n\n%s\n\n' "IF THIS LOOKS CORRECT YOU ARE CLEAR TO TERRAFORM"

all:    plan apply vault works pipeline_info  ## All-in-one
#all:    plan apply

tf-init: ## Initialize the build
	terraform init -backend=true \
	       -get=true -lock=true -no-color -verify-plugins=true

plan:	## Run and Plan the build with output log
	terraform plan -no-color \
		-out=$(planFile) 2>&1 | \
		tee /tmp/tf-$(TF_VAR_cluster_apps)-plan.out

apply:	## Build Terraform project with output log
	terraform apply --auto-approve -no-color \
		-input=false "$(planFile)" 2>&1 | \
		tee /tmp/tf-$(TF_VAR_cluster_apps)-apply.out

vault: vault-install vault-config

vault-install:	## Creates cluster and deploy HashiCorp Vault
	#kubectl config use-context minikube
	#kubectl config use-context $(TF_VAR_cluster_vault)
	scripts/vault-inst.sh 2>&1 | tee /tmp/vault-install.out

vault-config:	## Create vault configs and auth
	scripts/vault-conf.sh 2>&1 | tee /tmp/vault-config.out

works:	## configure the works cluster: kubes-${env}-{location}
	kubectl config use-context $(TF_VAR_cluster_apps)
	helm install diag vanderhoofen/diagnostics

pipeline_info: ## Creates SA and retrieves required info for k8s integration
	scripts/pipeline-auth-gitlab.sh

# ------------------------ 'make all' ends here ------------------------------#

creds:	## get cluster credentials after the build
	@scripts/get-creds.sh

contour: ## Installs contour ingress controller
	scripts/inst-contour.sh --install
	scripts/inst-contour.sh --certmanager

gitlab: ## deploys gitlab to cluster with reserved external dns
	scripts/inst-gitlab.sh --install

gitlab-password: ## retrieves gitlab root password
	scripts/inst-gitlab.sh --password

datadog: ## Deploy Datadog for observability
	# Uncommented: helm v2; commented helm v3
	helm upgrade --install datadog -f addons/datadog/values.yaml \
		stable/datadog \
	 	--set datadog.apiKey=$(DATADOG_API_KEY) \
	 	--set targetSystem=$(TARGET_SYSTEM)
	kubectl wait --for=condition=ready pod -l app=datadog --timeout=300s

contour-demo: ## Installs Contour ingressroute for demo purposes
	scripts/inst-contour.sh --https

istio:	## Create a separate Istio cluster and deploy
	scripts/istio/bootstrap-cluster.sh
	scripts/inst-istio.sh

graph:	## Create a visual graph pre-build 
	scripts/test-graphit.sh

xdns:	## configures external-dns on-cluster
	kubectl create -f addons/xdns/

pfvault: ## port-forward out to the vault container
	scripts/portforward-to-pod.sh vault 8200

open_vault: ## initialize and unseal the vault
	scripts/open-vault.sh

policy: ## Configure Vault - update this per-use
	vault audit  enable file file_path=stdout
	vault auth   enable kubernetes
	vault policy write admin_policy addons/secrets/vault/policies/admin_policy.hcl
	vault secrets enable kv
	vault secrets enable gcp

exfil:	## exfil vault to retest
	scripts/vault-exfil.sh

exfil-full:	## Nuke to oblivion
	scripts/vault-exfil.sh --purge

burn:	# Destroy Terraformed resources and all generated files with output log
	#helm list --short | xargs -L1 helm delete --purge | true
	#sleep 5
	# scripts/xvault.sh
	terraform destroy --force -auto-approve -no-color 2>&1 | \
		tee /tmp/tf-$(TF_VAR_cluster_apps)-destroy.out
	rm -f "$(planFile)"
	rm -f /tmp/vault-stuff.out
	rm -f /tmp/tf-apps-stage-la-*.out
	# gcloud container clusters delete -q istio-cluster --region=us-west2
	# kubectl config delete-context istio-cluster
	# clean up helm stuff
	# scripts/lysol.sh
	#gcloud compute config-ssh --remove
	#scripts/janitorial.sh

reset:  ## clear-off kubeconfig cruft
	# kubectl config use-context minikube
	kubectl config delete-context $(TF_VAR_cluster_apps)  | true
	kubectl config delete-context $(TF_VAR_cluster_vault) | true
	cat /dev/null > $(KUBECONFIG)

clean:	burn reset ## burn it all down

#-----------------------------------------------------------------------------#
#------------------------   MANAGERIAL OVERHEAD   ----------------------------#
#-----------------------------------------------------------------------------#
print-%  : ## Print any variable from the Makefile (e.g. make print-VARIABLE);
	@echo $* = $($*)

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

