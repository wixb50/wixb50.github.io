+++
categories = ["docker","cloud"]
date = "2016-06-17T19:38:38+08:00"
description = "简述docker的安装与简单入门"
keywords = ["docker"]
title = "docker入门"

+++

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:0 orderedList:0 -->

- [[前言](#)](#前言)
- [基本概念](#基本概念)
	- [镜像](#镜像)
	- [容器](#容器)
	- [仓库](#仓库)
	- [安装](#安装)
- [常用命令](#常用命令)
	- [镜像命令](#镜像命令)
	- [容器命令](#容器命令)
- [Docker进阶](#docker进阶)
	- [数据卷](#数据卷)
		- [主机容器数据共享](#主机容器数据共享)
		- [数据卷容器](#数据卷容器)
	- [Dockerfile](#dockerfile)

<!-- /TOC -->

# [前言](#)

**虚拟化**，是指通过虚拟化技术将一台计算机虚拟为多台逻辑计算机。在一台计算机上同时运行多个逻辑计算机，每个逻辑计算机可运行不同的操作系统，并且应用程序都可以在相互独立的空间内运行而互不影响，从而显著提高计算机的工作效率。

**Docker** 是个开源项目，它彻底释放了虚拟化的威力，极大提高了应用的运行效率，降低了云计算资源供应的成本，同时让应用的部署、测试和分发都变得前所未有的高效和轻松。Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。

如果把虚拟化比做OS，则Docker是OS上的再一层抽象，它运行的容器可以看作一个进程级别的虚拟机。启动、运行、安装都是只通过一个命令就能解决。对于搭建集群、系统CI和不可变基础设施是非常有利的。

**Docker简单原理** Docker只是管理运行轻量级容器的工具，容器是基于Linux内核技术包括namespace，cgroup，叠加文件系统如AUFS，工具提供运行应用，打包应用，分发应用。

**Docker影响** Docker成为最火热，甚至最具颠覆性的技术之一。相对于传统的云服务提供商(Iaas,Paas,Saas)，提出了一种全新的Caas(容器即服务)，国内比较领先的有DaoCloud、时速云等。Docker提出了“Build once，Run anywhere。

# 基本概念

![原理图](http://www.otokaze.cn/wp-content/uploads/2016/09/docker_vs_vm.png)

Docker 包括三个基本概念

+ 镜像（Image）
+ 容器（Container）
+ 仓库（Repository）

理解了这三个概念，就理解了 Docker 的整个生命周期。

## 镜像
Docker 镜像（Image）就是一个只读的模板，相当于操作系统(OS)安装的Ghost。

例如：一个镜像可以包含一个完整的 ubuntu 操作系统环境，里面仅安装了 Apache 或用户需要的其它应用程序。

镜像可以用来创建 Docker 容器。

Docker 提供了一个很简单的机制来创建镜像或者更新现有的镜像，用户甚至可以直接从其他人那里下载一个已经做好的镜像来直接使用。
## 容器
Docker 利用容器（Container）来运行应用。

容器是从镜像创建的运行实例。它可以被启动、开始、停止、删除。每个容器都是相互隔离的、保证安全的平台。同时容器也可以暴露相应的“端口”和挂载“容器卷”，分别用以网络和存储共享。

可以把容器看做是一个简易版的 Linux 环境（包括root用户权限、进程空间、用户空间和网络空间等）和运行在其中的应用程序。
## 仓库
仓库（Repository）是集中存放镜像文件的场所。

仓库分为公开仓库（Public）和私有仓库（Private）两种形式。

最大的公开仓库是 Docker Hub，存放了数量庞大的镜像供用户下载。

国内的公开仓库包括 时速云 、网易云 等，可以提供大陆用户更稳定快速的访问。

当用户创建了自己的镜像之后就可以使用 push 命令将它上传到公有或者私有仓库，这样下次在另外一台机器上使用这个镜像时候，只需要从仓库上 pull 下来就可以了。

\*注：Docker 仓库的概念跟 Git 类似，注册服务器可以理解为 GitHub 这样的托管服务。

## 安装

Docker 目前只能安装在 64 位平台上，并且要求内核版本不低于 3.10，实际上内核越新越好，过低的内核版本容易造成功能的不稳定。

快捷安装脚本
```
curl -sSL https://get.docker.com/ | sh
```

# 常用命令

## 镜像命令

获取镜像
```
$ sudo docker pull ubuntu:12.04
```
下载过程中，会输出获取镜像的每一层信息。
该命令实际上相当于 $ sudo docker pull registry.hub.docker.com/ubuntu:12.04 命令，即从注册服务器 registry.hub.docker.com 中的 ubuntu 仓库来下载标记为 12.04 的镜像。

使用 docker images 显示本地已有的镜像。
```
$ sudo docker images
```
移除本地的镜像，可以使用 docker rmi 命令。注意 docker rm 命令是移除容器。
```
$ sudo docker rmi training/sinatra
```

## 容器命令
基于一个images，新建并启动一个容器
```
$ sudo docker run ubuntu:14.04 /bin/echo 'Hello world'
Hello world
```
列出所有启动的容器
```
$ sudo docker ps
```
列出所有的容器(包括未启动的)
```
$ sudo docker ps -a
```
根据容器id，或者name启动，重启，停止容器
```
$ sudo docker start/restart {containerID|containerName}
```
更多的时候，需要让 Docker在后台运行而不是直接把执行命令的结果输出在当前宿主机下。此时，可以通过添加 -d 参数来实现。
```
$ sudo docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
77b2dc01fe0f3f1265df143181e7b9af5e05279a884f4776ee75350ea9d8017a
```
此时容器会在后台运行并不会把输出的结果(STDOUT)打印到宿主机上面(输出结果可以用docker logs 查看)。

容器中可以运行一些网络应用，要让外部也可以访问这些应用，可以通过 -P 或 -p 参数来指定端口映射。
```
$ sudo docker run -d -p 5000:5000 training/webapp python app.py
```
使用 hostPort:containerPort 格式本地的 5000 端口映射到容器的 5000 端口.
# Docker进阶

## 数据卷

用于Docker 内部以及容器之间管理数据共享与存储。

### 主机容器数据共享
挂载一个主机目录作为数据卷,使用 -v 标记也可以指定挂载一个本地主机的目录到容器中去
```
$ sudo docker run -d -P --name web -v /src/webapp:/opt/webapp training/webapp python app.py
```
之后对容器相应的目录更改便直接反映在主机中了。

### 数据卷容器

数据卷容器，其实就是一个正常的容器，专门用来提供数据卷供其它容器挂载的。

首先，创建一个命名的数据卷容器 dbdata：
```
$ sudo docker run -d -v /dbdata --name dbdata training/postgres echo Data-only container for postgres
```
然后，在其他容器中使用 --volumes-from 来挂载 dbdata 容器中的数据卷。
```
$ sudo docker run -d --volumes-from dbdata --name db1 training/postgres
```

## Dockerfile

docker 采用分层存储驱动，使用 Dockerfile 可以允许用户创建自定义的镜像。

Dockerfile 分为四部分：基础镜像信息、维护者信息、镜像操作指令和容器启动时执行指令。

```
# Base image to use, this must be set as the first line
FROM ubuntu

# Maintainer: docker_user <docker_user at email.com> (@docker_user)
MAINTAINER docker_user docker_user@email.com

# Commands to update the image
RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Commands when creating a new container
CMD /usr/sbin/nginx
```
其中，一开始必须指明所基于的镜像名称，接下来推荐说明维护者信息。

后面则是镜像操作指令，例如 RUN 指令，RUN 指令将对镜像执行跟随的命令。每运行一条 RUN 指令，镜像添加新的一层，并提交。

最后是 CMD 指令，来指定运行容器时的操作命令。
