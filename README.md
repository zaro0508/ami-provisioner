# Overview
Project for automating AMI deployments to a Sage AMI repository

## Workflow
The workflow to provision AWS AMI is done using pull requests.

### Requirements
* Install [packer](https://www.packer.io/intro/getting-started/install.html)

### Create snapshot AMI
1. Create new folder (i.e. mkdir -p packer/sagebio/MyAmi-LATEST)
2. Go into MyAmi-LATEST directory (i.e. cd packer/sagebio/MyAmi-LATEST)
3. Create a packer configuration file (must be `template.json`).  Set `ImageName` in the `variables`
section to `MyAmi-LATEST`
4. Validate packer file (i.e. packer validate template.json)
5. Create a PR with new files.

__Note__: A snapshot AMI is re-deployed (with a new AMI ID) on every PR merge.  This allows us
to make updates to this `LATEST` AMI.

### Manual AMI Build
If you would like to test building an AMI run:
```
cd packer/sagebio/MyAmi-LATEST
packer build -var AwsProfile=my-aws-account -var AwsRegion=us-east-1 template.json)
```

Packer will do the following:
* Create a temporary EC2 instance, configure it with shell/ansible/puppet/etc. scripts.
* Create an AMI from the EC2
* Delete the EC2

__Note__: Packer deploys a new AMI to the AWS account specified by the AwsProfile

### Version a snapshot AMI
1. Copy the snapshot AMI folder and give it a version (i.e. cp -r packer/sagebio/MyAmi-LATEST packer/sagebio/MyAmi-v1.0.0)
2. Go into MyAmi-v1.0.0 directory (i.e. cd packer/sagebio/MyAmi-v1.0.0)
2. Change `ImageName` in the `variables` section of template.json to `MyAmi-v1.0.0`
3. Validate packer file (i.e. packer validate template.json)
4. Create a PR with new files.

__Note__: Once an AMI has been versioned it will never be re-built.  The purpose is to preserve
dependencies to it by other resources

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
