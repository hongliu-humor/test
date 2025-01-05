#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo "Missing arguments"
  echo "Usage: $0 <POM_VERSION>"
  exit 1
fi
release_version=$1

# Execute the script and capture its output
result=$(sh ./change_pom_version.sh $release_version)

# Print the captured result
echo "The result of the script execution is: $result"
echo "$result" == "ok"
if [ "$result" == "ok" ]; then
  echo "The change_pom_version script executed successfully, Changed pom version to ${release_version}"
  working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
  echo "$working_dir"
#  cd ${working_dir}/scripts
  result2=$(sh ./ci_generate_release_branch.sh $release_version)
  if [ "$result2" == "release ok" ]; then
    echo "The ci_generate_release_branch script executed successfully, release ok"
  else
    echo "The ci_generate_release_branch script failed"
  fi
else
  echo "The script failed"
fi


echo "$(pwd)"
working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd ${working_dir}/..
rm  pom.xml.versionsBackup

# delete pom.xml.versionsBackup files in every child module
echo "Deleting pom.xml.versionsBackup files"
for module in $(ls -d */ | cut -f1 -d'/'); do
 # ensure that the module is a directory and its name is not scripts
   if [ -d "${module}" ] && [ "${module}" != "scripts" ]; then

       echo "Deleting ${module}/pom.xml.versionsBackup"
       rm ${module}/pom.xml.versionsBackup

   fi
done