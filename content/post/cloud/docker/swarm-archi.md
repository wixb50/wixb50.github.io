+++
categories = ["docker","cloud"]
date = "2016-09-17T10:38:38+08:00"
description = "简述docker1.12最新集群整一套实践方案"
keywords = ["docker"]
title = "docker1.12 集群实践方案"

+++

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [[前言](#)](#前言)
- [docker私有仓库](#docker私有仓库)
- [Docker swarm](#docker-swarm)
	- [docker service](#docker-service)
- [add on](#add-on)
	- [consul、registrator服务注册](#consulregistrator服务注册)
	- [graylog 日志收集](#graylog-日志收集)
- [参考](#参考)

<!-- /TOC -->

# [前言](#)

Docker 1.12将原先独立的项目`docker swarm`已经集成进自带的`docker engine`，并为集群方案提供了整一套的跨主机集群、灵活调度、高可用性的方案，同时引入service的概念，增加了服务创建的简易性、灵活性，还拥有服务注册、服务发现、服务自动负载均衡等特性。

在本docker集群方案中，先介绍私有仓库的概念，作为集群服务部署的基础；然后利用docker提供的官方的集群方案swarm搭建集群；最后补充一些其他方案满足整集群的监控，日志收集等方面。

# docker私有仓库

仓库（Repository）是集中存放镜像文件的场所。仓库分为公开仓库（Public）和私有仓库（Private）两种形式。

最大的公开仓库是 Docker Hub，存放了数量庞大的镜像供用户下载。

当需要加快service的更新速度的时候，就需要在局域网内拥有自建的私有仓库，当用户创建了自己的镜像之后就可以使用 push 命令将它上传到私有仓库，这样下次在另外一台机器上使用这个镜像时候，只需要从仓库上 pull 下来就可以了。

# Docker swarm

在docker1.12版本中不再试独立的项目，而集成在docker engine中，对于创建和管理集群都是非常方便的。

初始化集群master节点
```
$ docker swarm init
Swarm initialized: current node (0khsh2muxte9lkh584btlhgkv) is now a manager.

To add a worker to this swarm, run the following command:
    docker swarm join \
    --token SWMTKN-1-3re5jcwzt0yjx5h5gtxgaspgib0gxrs75peyiwufbk9bzr4nmh-f496phvvqbtekc21lulndjnfy \
    192.168.65.2:2377

To add a manager to this swarm, run the following command:
    docker swarm join \
    --token SWMTKN-1-3re5jcwzt0yjx5h5gtxgaspgib0gxrs75peyiwufbk9bzr4nmh-5beo6o66ep6p9yhqh7m2f0h8y \
    192.168.65.2:2377
```
然后在同局域网中worker节点执行上述提供的加入集群命令即可。

> docker swarm集群最小只需一个master节点即可，同时也可以多个manager、多个worker节点；所以为了保证集群的高可用性，可创建多几个manager节点。

## docker service

docker将所有部署的应用都抽象为service，在新建集群之后需要在集群中部署服务，这时候就要利用service命令了。

+ 创建service
```
$ docker service create --name gateway --publish 80:80 --replicas 2 nginx:latest
```
1.在创建service之后，master会自动下发任务给集群节点，并生成指定数量的服务容器replicas；2.同时由于swarm采用的是overlay(跨主机网络)，在swarm内部会自动将该服务name注册到内部的注册中心；3.如该服务是提供给内部系统调用的话，只需要访问其service name即可自动转发到相应服务，这样就避免了难记又易变得ip地址。4.并且由于service是可能部署多个replicas的，所以swarm也能达到一定的负载均衡的作用。5.我们就只需要对提供给外部网络访问的服务暴露指定的端口`--publish 80:80`就可以了。

+ scale service数量
```
docker service scale gateway=2
```
同时如果由于异常容器退出的话，swarm自带的 **安全检查** 会删除原来的失败的容器，并重新启动一个新的，保证服务的replicas数量。

+ service滚动更新

当我们代码有更新需要重新部署的时候，重新构建镜像push到仓库(不同tag版本命名)
```
$ docker service update --image new-image-name gateway
```
service更新的时候如果image不一样，则service会自动根据新的image拉取镜像，进行滚动更新。

+ 删除service
```
$ docker service rm gateway
```

# add on

## consul、registrator服务注册

由于swarm内部的服务注册和发现机制是内部的，不对外开放的，而且不是通过service启动的容器，swarm是发现不了的，所以为了监控整个集群的所有容器，我们可以自己搭建一套。

+ consul注册中心

consul用户保存集群中注册的所有容器，提供一个信息存储中心，只需要搭建一个即可(也可部署集群)
```
docker run -d -h node \
   --name=consul \
   -p 8500:8500 \
   -p 8600:53/udp \
   progrium/consul:latest \
   -server \
   -bootstrap \
   -advertise $DOCKER_IP \
   -log-level debug
```
通过浏览器能够访问$DOCKER_IP:8500，你将在控制面板上看到Consul中已经注册的所有服务。

+ registrator注册组件

该组件Registrator配置好相应的环境变量并将这个容器注册到Consul上。它会监控本机的docker进程，如果容器开启会自动注册到consul，关闭则自动移除。所以需要在集群的每台主机上配置安装下。
```
docker run -d \
   --name=registrator \
   --net=host \
   -v /var/run/docker.sock:/tmp/docker.sock \
   gliderlabs/registrator:latest \
   consul://$DOCKER_IP:8500
```

## graylog 日志收集

由于服务都是集群部署，上线之后直接使用`docker logs`命令查看容器日志是不合理的，同时问题排查也相当困难。

所以搭建一个统一的日志收集器用以收集容器所有日志。
```
$ docker run -d --name graylog -p 9000:9000 -p 12201:12201/udp graylog2/allinone:latest
// 在需要收集日志的容器或者service启动命令中加入(docker官方推荐)
--log-driver=gelf --log-opt gelf-address=udp://192.168.0.42:12201
```
这样对于直接`stdout`的日志将都会被发送到graylog中。至于graylog有什么强大功能就需要自己去发掘了。

# 参考

+ http://dockone.io/article/272

集群项目
   * Docker compose、Docker machine、Docker swarm
   * Kubernetes
