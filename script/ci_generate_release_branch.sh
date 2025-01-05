#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo "Missing arguments"
  echo "Usage: $0 <RELEASE_VERSION>"
  exit 1
fi
new_branch_version=$1

working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")/.." ; pwd -P )
cd $working_dir
echo "$working_dir"
git checkout -b release/"${new_branch_version}"

#mvn versions:set -q -DnewVersion=${new_version} > /dev/null
#echo "New version is: ${new_version}"

#git add */pom.xml
for module in $(ls -d */ | cut -f1 -d'/'); do
 # ensure that the module is a directory and its name is not scripts
   if [ -d "${module}" ] && [ "${module}" != "scripts" ]; then

       git add ${module}/pom.xml

   fi
done
git add pom.xml pomVersion
git commit -m "bump version to ${new_version} [skip-ci]"
git push --set-upstream origin release/${new_branch_version}

echo "release ok"