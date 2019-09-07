# Overview
Project for automating AMI deployments to a Sage AMI repository

## Workflow
The workflow to provision AWS AMI is done using pull requests.

### Requirements
* Install [packer](https://www.packer.io/intro/getting-started/install.html)

### Creating a AMI
1. Create a new folder with version (i.e. mkdir -p packer/MyAmi/MyAmi-v1.0.0)
2. Create a packer configuration file (must be `template.json`)
3. run packer `cd packer/MyAmi/MyAmi-v1.0.0 && packer build -var AwsProfile=my-aws-account -var AwsRegion=us-east-1 template.json`

__Note__: the packer build will deploy a new AWI to the AWS specified by the aws profile


## Contributions
Contributions are welcome.

Requirements:
* Install [pre-commit](https://pre-commit.com/#install) app
* Clone this repo
* Run `pre-commit install` to install the git hook.

## Testing
As a pre-deployment step we syntatically validate our sceptre and
cloudformation yaml files with [pre-commit](https://pre-commit.com).

Please install pre-commit, once installed the file validations will
automatically run on every commit.  Alternatively you can manually
execute the validations by running `pre-commit run --all-files`.

## Deployments
We use [sceptre](https://sceptre.github.io/) and [cloudformation](https://aws.amazon.com/cloudformation/)
to deploy resources onto an AWS account.

## Continuous Integration
We have configured Travis to deploy cloudformation template updates.

## Issues
* https://sagebionetworks.jira.com/projects/IT

## Builds
* https://travis-ci.org/Sage-Bionetworks/ami-provisioner

## Secrets
* We use the [AWS SSM](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html)
to store secrets for this project.  Sceptre retrieves the secrets using
a [sceptre ssm resolver](https://github.com/cloudreach/sceptre/tree/v1/contrib/ssm-resolver)
and passes them to the cloudformation stack on deployment.
