#!/bin/bash
set -e

# Validate all packer templates

# get all packer templates
TEMPLATES=$(find . -name template.json)
for template in $TEMPLATES
do
  dir="${template%/*}"
  file="${template##*/}"  # filename with extension
  extension="${file##*.}"
  filename="${file%.*}"
  printf "\n\e[1;33m==> Validating Packer template: ${template}\n\n"
  # provisioners reference files relative to current dir therefore need to run
  # validate in each directory
  pushd "${dir}"
  packer validate ${file}
  popd
done
