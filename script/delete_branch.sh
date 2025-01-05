#!/usr/bin/env bash


if [ "$#" -ne 1 ]; then
  echo "Missing arguments"
  echo "Usage: $0 <delete branch name>"
  exit 1
fi
new_branch_version=$1

git checkout main

#git delete -D release/${new_branch_version}



#// 删除本地分支
git branch -d release/${new_branch_version}

#// 删除远程分支
git push origin --delete release/${new_branch_version}