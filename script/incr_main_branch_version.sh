#!/usr/bin/env bash


working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd ${working_dir}/..

#echo "Using maven version: $(mvn -v)"
CURRENT_VERSION=$(cat pomVersion)

#mvn versions:set -DnewVersion=${NEW_VERSION} -q
#echo ${NEW_VERSION} > pomVersion
#echo "The change_pom_version script executed successfully, Changed pom version to ${NEW_VERSION}"

if [[ "${CURRENT_VERSION}" =~ .*"-SNAPSHOT"$ ]]; then
#  BUILD_NUMBER=${BUILD_NUMBER:-$(date '+%Y%m%d.%H%M%S')}
# increment the current version
  NEW_VERSION=${CURRENT_VERSION/%-SNAPSHOT/}
else
  NEW_VERSION=${CURRENT_VERSION}
fi

nums=$(echo $NEW_VERSION | tr "." "\n")
# add items in nums to a new array
arr=()
for n in $nums
do
    arr+=($n)
done
# increment the last item
len=${#arr[*]}
arr[len-1]=$((${arr[len-1]}+1))

#new_version="${arr[0]}.${arr[1]}.${arr[2]}-SNAPSHOT"
new_version=""
for i in $(seq 0 $((${#arr[*]}-1)))
do
    if [ $i -eq $((${#arr[*]}-1)) ]; then
        new_version="${new_version}${arr[i]}"
    else
        new_version="${new_version}${arr[i]}."
    fi
done
new_version="${new_version}-SNAPSHOT"
echo "Original version is: ${NEW_VERSION}"
echo "Build version is: ${new_version}"


mvn versions:set -DnewVersion=${new_version} -q
echo ${new_version} > pomVersion
