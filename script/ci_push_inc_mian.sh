#!/usr/bin/env bash

CURRENT_VERSION=$(cat pomVersion)

working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")/.." ; pwd -P )
cd $working_dir
echo "$working_dir"

#git add */pom.xml
for module in $(ls -d */ | cut -f1 -d'/'); do
 # ensure that the module is a directory and its name is not scripts
   if [ -d "${module}" ] && [ "${module}" != "scripts" ]; then

       git add ${module}/pom.xml

   fi
done
git add pom.xml pomVersion
git commit -m "bump version to ${CURRENT_VERSION} [skip-ci]"
git push --set-upstream origin main

echo "increase version of main branch ok"