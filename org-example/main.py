#!/usr/bin/env python
from constructs import Construct
from cdktf import App, TerraformStack
from cdktf_cdktf_provider_aws.provider import AwsProvider
from cdktf_cdktf_provider_aws.data_aws_organizations_organization import DataAwsOrganizationsOrganization

REGION = "us-east-1"

class MyStack(TerraformStack):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)

        # define resources here
        AwsProvider(self, "aws", profile="cu-org-root-cq", region=REGION)
        org = DataAwsOrganizationsOrganization(self, "org")
        print("################################################")
        print(f"{org.accounts}")
        print("################################################")
        print(f"{org.accounts.get(0)}")
        print("################################################")
        print(f"{org.accounts.get(0).id}")
        print("################################################")
        print("################################################")


app = App()
MyStack(app, "org-example")

app.synth()
