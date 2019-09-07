#!/bin/bash
# set -e

# Deploy images to AWS account to share with other projects.

# get all packer templates
TEMPLATES=$(find . -name template.json)
for template in $TEMPLATES
do
  dir="${template%/*}"
  file="${template##*/}"  # filename with extension
  extension="${file##*.}"
  filename="${file%.*}"
  # provisioners reference files relative to current dir therefore need to run
  # build in each directory
  pushd "${dir}"
  log="$(packer build -var AwsProfile=default -var AwsRegion=us-east-1 ${file} 2>&1)"
  status=$?
  echo "${log}"
  # special case skip build if AWS contains an AMI with the same name
  if [[ ${log} =~ "name conflicts with an existing AMI" && ${status} -ne 0 ]]; then
    printf "\n\e[1;33m==> WARN: Skipped build, AMI already exists.\n\n"
  elif [[ ${status} -ne 0 ]]; then   # catch any other failure
    popd
    exit 1
  fi
  popd
done
