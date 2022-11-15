# cdktf-playground

Terraform CDK examples and configuration to run `cdktf` in Docker containers.

These examples work with CDKTF v0.13. As of November 15, 2022, a lot of the CDKTF examples out there are broken for v0.13 because of a breaking change from v0.12 to v0.13. See https://github.com/hashicorp/terraform-cdk/issues/2160.

Running CDKTF in Docker also generates some additional complexity that these examples show how to navigate.

## Check Tool Versions

```
root@4a1779bfbb99:/mounted-files# python --version
Python 3.7.15
root@4a1779bfbb99:/mounted-files# pipenv --version
pipenv, version 2022.11.11
root@4a1779bfbb99:/mounted-files# node --version
v18.12.1
root@4a1779bfbb99:/mounted-files# cdktf --version
0.13.3
```

## Run the CDKTF Container

```
./go.sh
```

## Create A New CDKTF Project

### Make a Project Directory
```
root@4a1779bfbb99:/mounted-files# mkdir example1
root@4a1779bfbb99:/mounted-files# cd example1
```
### Customize `pipenv` Behavior

```
root@4a1779bfbb99:/mounted-files/example1# export PIPENV_VENV_IN_PROJECT=true
```

### Create the CDKTF Project
```
cdktf init --template python \
    --project-name example1 \
    --project-description "Example 1" \
    --local \
    --enable-crash-reporting false

```
### Install a Pre-built Provider
```
pipenv install cdktf-cdktf-provider-aws
```

### Add a Provider to `cdktf.json`

Add the AWS provider in `cdktf.json`. Set `terraformProviders` to `["aws"]`:
```
  "terraformProviders": ["aws"],
```

### Change File Ownership

Change project file ownership so they can be more easily edited outside of the container.
```
chown 1000:1000 * .*
```

### Edit `main.py`

Be sure to pick the right form of `import`, depending on how you installed CDKTF providers.

```python
#!/usr/bin/env python
from constructs import Construct
from cdktf import App, TerraformStack

# Use this if you are using the local providers from ./imports
# Those are created when execing "cdktf get"
# from imports.aws.provider import AwsProvider
# from imports.aws.sns_topic import SnsTopic

# Use this if you are using prebuilt-providers. 
# Install the pre-built providers using:
#   pipenv install cdktf-cdktf-provider-aws
from cdktf_cdktf_provider_aws.provider import AwsProvider
from cdktf_cdktf_provider_aws.sns_topic import SnsTopic

class MyStack(TerraformStack):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)

        # define resources here
        AwsProvider(self, 'Aws', region='us-east-1')
        SnsTopic(self, 'Topic', display_name='cdktf-example1-topic')

app = App()
MyStack(app, "example1")

app.synth()
```

### Deploy the Resources

```
cdktf deploy
```


### Destroy the Resources

```
cdktf destroy
```
