#!/bin/bash

#1.first you need generate the static website.
./hugo server -b "http://wixb50.gitcafe.io/" --appendPort=false &
sleep 2
pkill hugo
#input the submit message
echo "please input the submit message:"
read msg
if [  "$msg" = "" ];then
	msg="submit message"
fi
echo $msg

#2.then submit the static web to master branch.
cd public
git add -A
git commit -m "$msg"
# 添加 gitcafe 远程源,强制推送到gitcafe
git remote add gitcafe https://gitcafe.com/wixb50/wixb50.git
git push -f gitcafe master:gitcafe-pages

#finish