+++
categories = ["docker","cloud"]
date = "2015-12-11T18:38:38+08:00"
description = "docker images/container batch operation command"
keywords = ["docker"]
title = "Docker Batch Operation"

+++

批量操作docker images or container commander.

#### Remove all stopped containers.
```
docker rm $(docker ps -a -q)
```
#### Remove all containers.
```
docker rm $(docker ps -a -q)
```
#### Remove all untagged images
```
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```
#### Remove all images
```
docker rmi $(docker images | grep \ | awk '{print $3}')
```