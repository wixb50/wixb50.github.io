#!/bin/bash

#1.first you need generate the static website.
./hugo server -b "http://wixb50.github.io/" --appendPort=false
#choose where to deployed and generate
./hugo server -b "http://wixb50.gitcafe.io/" --appendPort=false

#2.then submit the source file to develop branch.
git add content
git commit -m "submit message"
git push origin develop

#3.then submit the static web to master branch.
cd public
git add .
git commit -m "submit message"
git push origin master

#finish

#addition command
# 添加 gitcafe 远程源
git remote add gitcafe https://gitcafe.com/wixb50/wixb50.git
#提交到gitcafe,git在本地可同时保存多个远程仓库如github(origin),gitcafe(gitcafe)
git push -u gitcafe master:gitcafe-pages

#end
