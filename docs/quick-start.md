# GCP Account Sing-up Quickstart

The hardest part of the learning process really seems to be the first few steps. This is how I got through them; I hope it helps speed things up for you too.

## First Time Setup Stuff

1 - [Sign-up] for a GCP Account; there are 2 types of account:

      i.  Personal: (if you want to move quickly)
      ii. Organization (if your intent is learn so you can find work)

This repo will focus on `ii. Organization`. In either case, it only takes a moment and the first year is free; you are granted a $300 credit for signing up.

NOTE: you may be asked to make a decision between Cloud Identity and Google Workspaces. If you can ignore this distinction, then do. If not, I ran with Workspaces. For those companies that work inter-cloud, like to use the G-suite set of tools, it's pretty handy to know. But, both will likely be covered.

2 - Domain Setup

The Google [Domains Registrar] is super simple; find something cheap. Use the [Cloud DNS Quickstart] to help finish off the config.

3 - The _first user_. 

I used the first user account (`example@domain.com`), to invite my personal account into the org: `user@gmail.com`. The first user account will serve as a 'root' account when I need it. I'll use my personal account for now. 


4 - The CLI Install

Install the Google Cloud SDK

`brew install --cask google-cloud-sdk`

5 - You should set up some helper completions files in the environment. I've graduated to the macOS default [ZSH]; to level-up shell interactions, I've installed/configured [Oh My Zsh]. This is highly recommended. Anyway, they could look [something like this].

Once your environment is configured, activate it: `exec zsh`

6 - Auth the account

Whichever account you intend to use as your limited, daily-driver account, you must authenticate in the shell; for me, this was: 

`gcloud auth login user@gmail.com`

I simply invited my personal identity (email address) into the GCP Organization and assigned it some permissions.

---

## GCP First Steps

### List/Set Projects

Projects created with either the CLI or WebUI; mine looks like this:

```shell
% gcloud projects list
PROJECT_ID         NAME              PROJECT_NUMBER
edu-gcp-labs       edu-gcp-labs      0101010101015
hip-return-362523  My First Project  010101010101       # ignore this one and work around it
whatever           whatever          010101010101
```

Using the Terminal, initialize the project locally

```shell
gcloud init
```

And follow the prompts. But, these things can all be set individually as well.

```shell
% gcloud config set project edu-gcp-labs
```

### Set the user account for project assignment

```shell
% gcloud config set account user@gmail.com
```

### Optionally, set the default zone/region if you want

```shell
% gcloud config set compute/region us-central1
% gcloud config set compute/zone   us-central1-a
```

### Display the active configuration

```shell
% gcloud config configurations list
NAME     IS_ACTIVE  ACCOUNT         PROJECT         DEFAULT_ZONE   DEFAULT_REGION
default  True       user@gmail.com  default-219918  us-central1-a  us-central1
```

```shell
% gcloud compute project-info describe | head -9
commonInstanceMetadata:
  fingerprint: mYfInGrPrInT
  kind: compute#metadata
creationTimestamp: '2022-09-27T10:31:41.010-07:00'
defaultNetworkTier: PREMIUM
defaultServiceAccount: 0101010101010-compute@developer.gserviceaccount.com
id: '0101010101010101010'
kind: compute#project
name: edu-gcp-labs
```

---

## Homework

These are some pretty important reading materials; bookmark this stuff:

* [Authentication at Google]
* [Setting up OAuth 2.0]
* [Terraform Authentication]
  * Provide credentials for [Application Default Credentials]
  * [GCP Best Practices] for using Terraform
  * [Terraform on GCP]

That should be enough for now.


[Sign-up]:https://cloud.google.com
[Cloud DNS Quickstart]:https://cloud.google.com/dns/docs/set-up-dns-records-domain-name
[Domains Registrar]:https://domains.google.com/registrar/?hl=en-US
[ZSH]:https://www.zsh.org/
[Oh My Zsh]:https://ohmyz.sh/
[something like this]:https://gist.github.com/todd-dsm/17f4f6af9a3fd838d47db3527724b732#file-environment-zsh-L95-L100
[Authentication at Google]:htps://cloud.google.com/docs/authentication/
[Setting up OAuth 2.0]:https://support.google.com/cloud/answer/6158849
[Terraform Authentication]:https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#primary-authentication
[Application Default Credentials]:https://cloud.google.com/docs/authentication/provide-credentials-adc
[GCP Best Practices]:https://cloud.google.com/docs/terraform/best-practices-for-terraform
[Terraform on GCP]:https://cloud.google.com/docs/terraform#training-and-tutorials
