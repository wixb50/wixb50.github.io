+++
categories = ["docker","cloud"]
date = "2015-12-11T18:38:38+08:00"
description = "docker images/container operation command"
keywords = ["docker"]
title = "Docker Operation"

+++

## 目录
<!-- MarkdownTOC -->

- [normal commander](#normal-commander)
    - [Docker 使用代理连接 Docker Hub](#docker-使用代理连接-docker-hub)
    - [存出或者载入镜像](#存出或者载入镜像)
- [批量操作docker commander.](#批量操作docker-commander)
    - [Stop all containers.](#stop-all-containers)
    - [Remove all stopped containers.](#remove-all-stopped-containers)
    - [Remove all untagged images](#remove-all-untagged-images)
    - [Remove all images](#remove-all-images)

<!-- /MarkdownTOC -->

## normal commander
### Docker 使用代理连接 Docker Hub
如果你的宿主操作系统是 linux 那方法就很简单了，直接通过命令来启动服务即可。
```
sudo HTTP_PROXY=10.125.156.21:8118 docker -d
```
如果是只是临时使用可以用下面语句
```
sudo HTTP_PROXY=10.125.156.21:8118 docker pull node
```
### 存出或者载入镜像
存出镜像
```
sudo docker save -o ubuntu_14.04.tar ubuntu:14.04
```
载入镜像
```
sudo docker load < ubuntu_14.04.tar
#or
sudo docker --input ubuntu_14.04.tar
```

## 批量操作docker commander.
NOTE: `sudo`maybe.
#### Stop all containers.
```
docker stop $(docker ps -a -q)
```
#### Remove all stopped containers.
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