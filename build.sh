#!/bin/bash
# set -e

# Create and deploy images to AWS account to share with other projects.
# This script is designed to skip a build if an AMI with the same name
# already exist in the AWS account.
# Templates in folders named '-LATEST' are designed as AMI snapshots
# and will always get re-built and re-deployed to AWS. A redeploy
# will delete the previous '-LATEST' AMI and deploy a new one with
# a new AMI ID.

# Vars
AwsProfile="default"
AwsRegion="us-east-1"

# get all packer templates
TEMPLATES=$(find . -name template.json)
for template in $TEMPLATES
do
  dir="${template%/*}"
  file="${template##*/}"  # filename with extension
  extension="${file##*.}"
  filename="${file%.*}"
  echo "Packer building template: ${template}"
  # provisioners reference files relative to current dir therefore need to run
  # build in each directory
  pushd "${dir}"
  if [[ ${dir} =~ "LATEST" ]]; then
    log="$(packer build -force -var AwsProfile=${AwsProfile} -var AwsRegion=${AwsRegion} ${file} 2>&1)"
  else
    log="$(packer build -var AwsProfile=${AwsProfile} -var AwsRegion=${AwsRegion} ${file} 2>&1)"
  fi
  echo "${log}"
  status=$?
  # special case skip build if AWS contains an AMI with the same name
  if [[ ${log} =~ "name conflicts with an existing AMI" && ${status} -ne 0 ]]; then
    printf "\n\e[1;33m==> WARN: Skipped build, AMI already exists.\n\n"
  elif [[ ${status} -ne 0 ]]; then   # catch any other failure
    popd
    exit 1
  fi
  popd
done
