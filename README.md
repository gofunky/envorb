# envorb

[![CircleCI](https://circleci.com/gh/gofunky/envorb/tree/master.svg?style=shield)](https://circleci.com/gh/gofunky/envorb/tree/master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/22c19fadee13479fac231d551e6442e9)](https://www.codacy.com/app/gofunky/envorb?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=gofunky/envorb&amp;utm_campaign=Badge_Grade)
![GitHub last commit](https://img.shields.io/github/last-commit/gofunky/envorb.svg)
![GitHub License](https://img.shields.io/github/license/gofunky/envorb.svg)

CircleCI orb that loads and passes environment variables from various sources.

## Why is it necessary?

CircleCI 2.1 still allows environment variables persistency only via a bash workaround.
Slim images such as Alpine, however, don't bash included.

The other challenge, you may face in a CI setup, is the question how to automatically pass semantic versions into a build.
Is your setup depending on versions extracted from cli commands, a file, a web page, git or GitHub?

Thanks to the new orb system form CircleCI 2.1, envorb fetches the environment variables, persists it to the workspace, and allows you via a simple `source` command to load it in your own orb.
Thereby, public orbs have the capability to require variables idiomatically.
 
## How to integrate?

Only few steps are necessary to integrate envorb into your inline or public orb.

### Option 1: Orb only

#### Import the script into your orb yaml

During the preparation steps, fetch the script from the online repository.

```yaml
- run:
    name: Deploy envorb store
    command: |
      if [ ! -e "/usr/local/bin/envload" ]; then
        echo "Installing envorb loader..."
        wget -O /usr/local/bin/envload https://raw.githubusercontent.com/gofunky/orbs/master/envorb/load.sh
        chmod +x /usr/local/bin/envload
      fi
```

### Option 2: Integrate the script in your orb's Docker image (recommended)

#### Add envorb as submodule

```cmd
git submodule add https://github.com/gofunky/envorb.git
```

#### Build the Docker image

envorb provides templates to build and test your image.
It is meant to be used as a separate layer and tag.

The following is a simplified example of our git image that is build using our docker orb. 

```yaml
- dockerorb/build_test_push:
    name: build_envload
    # Separate tag for envload
    tags: "git:envload"
    # To use the Dockerfile from the submodule that is located under ./envorb
    path: "./envorb"
    # To use the compose test provided in the submodule
    compose: "./envorb/test/docker-compose.test.yml"
    # Use the previously built and pushed image as base argument
    args: "BASE=git:latest"
    # Build this after the base image has been built
    requires:
    - build_latest
```  

#### (Optional) Enable dependabot

Dependabot allows you to automatically create pull request for submodule updates.
If envorb is updated, you can keep your orb updated.

### Finally, use the script (for both options)

In every step, where the environment variables are needed or should be available to the user of the orb, `source` the imported script first.
Make sure to attach the workspace first, the variables will not be found otherwise.

```yaml
- run:
    name: Your step with environment variables available
    command: |
      source /usr/local/bin/envload
      your-cli-cmd
```

## How to use the envorb?

The choice is yours how you load your environment variables.
Just import the orb and execute a envorb job in your workflow before the envload job that depends on it.

```yaml
orbs:
  orb-tools: gofunky/envorb@volatile
```

### Parameters

These are the parameters that are available in all jobs:

#### alpine_version (optional)

The Docker alpine version of the envorb image. It is recommended to specify the version explicitly.

```yaml
alpine_version: "3.8"
```

#### variable (required)

The name of the variable to set.

```yaml
variable: MY_VAR
```

#### attach (disabled by default)

To attach the workspace before the variable is set or derived.

```yaml
attach: true
```

#### attach_at (optional, `.` by default)

Where to attach the workspace.

```yaml
attach_at: .
```

#### checkout (disabled by default)

To checkout the branch before the variable is set or derived.

```yaml
checkout: true
```

#### prepare (optional)

Additional prepare steps to execute before the variable is set or derived. 

```yaml
prepare:
- run:
    name: Update git
    command: |
      apk add --no-cache --upgrade git
```

### Jobs

The following jobs are available. Some have additional parameters.

#### envorb/value

Set a variable explicitly.

```yaml
- envorb/value:
    variable: HARDCODED_VAR
    value: "foo"
```

#### envorb/value

Derive the variable from the given command.

```yaml
- envorb/cmd:
    variable: VAR_FROM_CMD
    cmd: my-cli --get-var
```

#### envorb/http

Derive the variable from the given http address.

```yaml
- envorb/http:
    variable: VAR_FROM_HTTP
    address: https://github.com/gofunky/my-variable-page
```


#### envorb/cmd_version

Derive a semantic version from the given command. The version is matched automatically.

```yaml
- envorb/cmd_version:
    variable: VERSION_FROM_CMD
    cmd: my-cli --version
```

#### envorb/http_version

Derive a semantic version from the given http address. The version is matched automatically.

```yaml
- envorb/http_version:
    variable: VERSION_FROM_HTTP
    address: https://github.com/gofunky/my-repo-with-version
```

#### envorb/github

Derive the version from the github.com tag. The version is matched automatically.

```yaml
- envorb/github:
    variable: VERSION_FROM_GITHUB
    repository: gofunky/my-repo-with-version
```

#### envorb/git_tag

Derive the version from the latest git tag. The version is matched automatically.

```yaml
- envorb/git_tag:
    # checkout is always true
    variable: VERSION_FROM_CMD
    # The path to the local git repository, the current path by default
    repository: .
```
