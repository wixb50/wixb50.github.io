#!/bin/bash

#1.first you need generate the static website.
./hugo server -b "http://wixb50.github.io/" --appendPort=false &
sleep 2
pkill hugo
#input the submit message
while [ ! $msg ]
do
	echo "please input the submit message:"
	read msg
done

#2.then submit the source file to develop branch.
git add -A
git reset HEAD public
git commit -m $msg
git push origin develop

#3.then submit the static web to master branch.
cd public
git add -A
git commit -m $msg
git push origin master

#finish