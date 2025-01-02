#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo "Missing arguments"
  echo "Usage: $0 <POM_VERSION>"
  exit 1
fi

NEW_VERSION=$1

working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd ${working_dir}/..

echo "Using maven version: $(mvn -v)"

mvn versions:set -DnewVersion=${NEW_VERSION} -q
echo ${NEW_VERSION} > pomVersion

echo $(dirname "$PWD")/pom.xml.versionsBackup
rm  pom.xml.versionsBackup


# change version of child modules
for module in $(ls -d */ | cut -f1 -d'/'); do
 # ensure that the module is a directory and its name is not scripts
   if [ -d "${module}" ] && [ "${module}" != "scripts" ]; then

       echo "Changing version of ${module} to ${NEW_VERSION}"
       mvn -f ${module}/pom.xml versions:set -DnewVersion=${NEW_VERSION} -q

   fi
done

echo "Changed pom version to ${NEW_VERSION}"

# delete pom.xml.versionsBackup files in every child module
echo "Deleting pom.xml.versionsBackup files"
for module in $(ls -d */ | cut -f1 -d'/'); do
 # ensure that the module is a directory and its name is not scripts
   if [ -d "${module}" ] && [ "${module}" != "scripts" ]; then

       echo "Deleting ${module}/pom.xml.versionsBackup"
       rm ${module}/pom.xml.versionsBackup

   fi
done