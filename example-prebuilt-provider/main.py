#!/usr/bin/env python
from constructs import Construct
from cdktf import App, TerraformStack

################################################################
# Use this if you are using the local providers from ./imports
# Those are created when exec'ing "cdktf get"
################################################################
# from imports.aws.provider import AwsProvider
# from imports.aws.sns_topic import SnsTopic

################################################################
# Use this if you are using prebuilt-providers. 
# Install the pre-built providers using:
#   pipenv install cdktf-cdktf-provider-aws
################################################################
from cdktf_cdktf_provider_aws.provider import AwsProvider
from cdktf_cdktf_provider_aws.sns_topic import SnsTopic

class MyStack(TerraformStack):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)

        # define resources here
        AwsProvider(self, 'Aws', region='us-east-1')
        SnsTopic(self, 'Topic', display_name='cdktf-example-prebuilt-provider-topic')


app = App()
MyStack(app, "example-prebuilt-provider")

app.synth()
