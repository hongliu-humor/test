#!/usr/bin/env bash


check_result()
{
  echo check input params: $1
  if [ "$1" -ne 0 ]; then
    echo "Error return result: $1"
    exit $1
  fi
}



if [ "$#" -ne 1 ]; then
  echo "Missing arguments"
  echo "Usage: $0 <POM_VERSION>"
  exit 1
fi
release_version=$1

# Execute the script and capture its output
sh ./change_pom_version.sh $release_version
echo $?
check_result $?
#v1 = $?
#echo $?
#echo $v1
working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
echo "$working_dir"
#  cd ${working_dir}/scripts
sh ./ci_generate_release_branch.sh $release_version
echo $?
check_result $?