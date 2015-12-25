+++
categories = ["docker","cloud"]
date = "2015-11-02T21:38:38+08:00"
description = "简述docker的安装与配置"
keywords = ["docker"]
title = "docker安装与配置"

+++

### 方法一：安装命令
```
sudo apt-get install apt-transport-https
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo bash -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker
```
### 方法二：安装命令(推荐)
```
curl -sSL https://get.docker.com/ | sh
```
完

### Docker资料收集
+ [Deploy a Mesos Cluster with 7 Commands Using Docker](https://medium.com/@gargar454/deploy-a-mesos-cluster-with-7-commands-using-docker-57951e020586#.74cyoyjp5)
+ [Docker Clustering Tools Compared: Kubernetes vs Docker Swarm](http://technologyconversations.com/2015/11/04/docker-clustering-tools-compared-kubernetes-vs-docker-swarm/)
+ [DOCKER CLUSTERING ON MESOS WITH MARATHON](https://mesosphere.com/blog/2014/11/10/docker-on-mesos-with-marathon/)
+ [Swarm、Fleet、Kubernetes和Mesos的比较](http://www.tuicool.com/articles/nyyENrY)