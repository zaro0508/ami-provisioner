# Overview
Project for automating AMI deployments to a Sage AMI repository

## Workflow
The workflow to provision AWS AMI is done using pull requests.

### Requirements
* Install [packer](https://www.packer.io/intro/getting-started/install.html)

### Create snapshot AMI
1. Create new folder (i.e. mkdir -p packer/MyAmi-LATEST)
2. Create a packer configuration file (must be `packer/MyAmi/template.json`).  Set `ami_name` to `MyAmi-LATEST`
3. Validate packer file (i.e. packer validate packer/MyAmi/template.json)
4. Create a PR with new files.

__Note__: a snapshot AMI is re-built on every travis build however the AMI ID will change on every build

### Version a snapshot AMI
1. Copy the snapshot AMI folder and give it a version (i.e. cp packer/MyAmi-LATEST packer/MyAmi-v1.0.0)
2. Change the `ami_name` in template.json to `MyAmi-v1.0.0`
3. Validate packer file (i.e. packer validate packer/MyAmi/template.json)
4. Create a PR with new files.

__Note__: once an AMI has been versioned it will never be rebuilt to preserve dependencies to it by other resources

### Manual AMI Build
If you would like to test building an AMI run:
```
Build AMI (i.e. packer build -var AwsProfile=my-aws-account -var AwsRegion=us-east-1 packer/MyAmi/template.json)
```

Packer will do the following:
* Create a temporary EC2 instance, configure it with shell/ansible/puppet/etc. scripts.
* Create an AMI from the EC2
* Delete the EC2

__Note__: packer deploys a new AWI to the AWS account specified by the AwsProfile

## Contributions
Contributions are welcome.

Requirements:
* Install [pre-commit](https://pre-commit.com/#install) app
* Clone this repo
* Run `pre-commit install` to install the git hook.

## Testing
As a pre-deployment step we syntatically validate our packer json
files with [pre-commit](https://pre-commit.com).

Please install pre-commit, once installed the file validations will
automatically run on every commit.  Alternatively you can manually
execute the validations by running `pre-commit run --all-files`.

## Deployments
Travis runs packer which temporarily deploys an EC2 to create an AMI.

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
