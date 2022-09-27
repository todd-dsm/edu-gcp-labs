# one-time-setup-stuff

There are a few important pregame steps:

1 - Export `GOOGLE_APPLICATION_CREDENTIALS` to your environment; EG:

When using `gcloud auth application-default login` the program drops credentials here by default:

This becomes a configuration line in my Oh My ZSH configuration: `~/.oh-my-zsh/custom/environment.zsh`

`export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"`

If it's not at this location, then find out where `gcloud` _is_ putting the file:

```shell
find "$HOME" -type f -name 'application_default_credentials.json'
```

Then just `exec zsh` to pull those changes in.

2 - Create a new Project in the [Google Console]; our standard is to create projects like:

* prod: `project_id=$projectName`
* staging: `project_id=${projectName}-stage` (it doesn't have to be complicated)

This new project name goes in the file `build.env` as the value to the variable `TF_VAR_project_id`.

3 - While you're in `build.env`, may as well set all Organization/Project parameters and values as well.

4 - Set the business stuff outside the repo: (billing/orgID, etc). This is organization-wide so the file is named after the Organization; mine looks like:

`~/.config/gcloud/configurations/kubes-rocks-sec`

Basically, this is anything that should not be committed to the repo. Update the file path/name in `build.env`.

5 Source-in your project variables

`source build.env <stage|prod>`; example:

`source build.env prod`

6 - Set the new project params in the shell:

```bash
make prep
...
The new project parameters:
NAME     IS_ACTIVE  ACCOUNT          PROJECT      COMPUTE_DEFAULT_ZONE  COMPUTE_DEFAULT_REGION
default  True       user@domain.tld  projectName  us-central1-a         us-central1
```

7 - Create a project bucket for the Terraform state files:

`scripts/setup/bucket-project-create.sh`

[Google Console]:https://console.cloud.google.com/home/dashboard