+++
categories = ["coreos","vagrant"]
date = "2015-12-12T15:38:38+08:00"
description = "Vagrant快速搭建CoreOS集群"
keywords = ["etcd"]
title = "快速搭建CoreOS集群"

+++

## 目录
<!-- MarkdownTOC -->

- [前言](#前言)
- [准备工作](#准备工作)
- [配置工作](#配置工作)
    - [安装 Vagrant and VirtualBox](#安装-vagrant-and-virtualbox)
    - [从CoreOS官方代码库获取基本配置，并进行修改](#从coreos官方代码库获取基本配置，并进行修改)
- [启动集群](#启动集群)
- [测试集群](#测试集群)

<!-- /MarkdownTOC -->

## [前言](null)
第一次接触CoreOS这样的分布式平台，运行一个集群看起来好像一个很复杂的任务，这里我们给你展示在本地快速搭建一个CoreOS集群环境是多么的容易。
## 准备工作
本地的机器上已经安装了最新版本的Virtualbox, Vagrant 和 git。
## 配置工作

### 安装 Vagrant and VirtualBox
[vagrant](https://www.vagrantup.com/) 和 [virtualbox](https://www.virtualbox.org/wiki/Downloads)都是直接下载双击安装的，具体安装教程看官网。

### 从CoreOS官方代码库获取基本配置，并进行修改  

首先，获取模板配置文件
```
git clone https://github.com/coreos/coreos-vagrant
cd coreos-vagrant
cp user-data.sample user-data
```
获取新的token
```
curl https://discovery.etcd.io/new
```
使用新的token配置到user-data文件如下，[官网示例](https://coreos.com/os/docs/latest/booting-on-vagrant.html)
```
#cloud-config

coreos:
  etcd2:
    # generate a new token for each unique cluster from https://discovery.etcd.io/new?size=3
    # specify the initial size of your cluster with ?size=X
    # WARNING: replace each time you 'vagrant destroy'
    discovery: https://discovery.etcd.io/<token>
    # multi-region and multi-cloud deployments need to use $public_ipv4
    advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001
    initial-advertise-peer-urls: http://$private_ipv4:2380
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380
  fleet:
    public-ip: $public_ipv4
  flannel:
    interface: $public_ipv4
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
    - name: flanneld.service
      drop-ins:
      - name: 50-network-config.conf
        content: |
          [Service]
          ExecStartPre=/usr/bin/etcdctl set /coreos.com/network/config '{ "Network": "10.1.0.0/16" }'
      # Uncomment line above if you want to use flannel in your installation.
      # command: start
```
>提示：编辑完毕后，请到[http://codebeautify.org/yaml-validator][]校验下yaml文件格式是否正确。
## 启动集群
默认情况下，CoreOS Vagrantfile 将会启动单机。

我们需要复制并修改config.rb.sample文件.

复制文件
```
cp config.rb.sample config.rb
```
修改 config.rb 文件，配置 $num_instances 和 $update_channel 这两个参数。比如：
```
# Official CoreOS channel from which updates should be downloade
$num_instances=3  ## 表示我们要创建3台主机
# Official CoreOS channel from which updates should be downloade
$update_channel='stable'  ## 表示使用的coreos版本，有：'stable'、'beta'、'alpha'.
```
>提示：如果国内下载比较慢，可以先事先下载好`coreos_production_vagrant.box`，添加到vagrant的box里面。注意更改名字为"coreos-stable|coreos-beta|coreos-alpha"，和你上面填写的对应。

启动集群
```
vagrant up
```
**添加ssh的公匙**
```
ssh-add ~/.vagrant.d/insecure_private_key
```
连接集群中的第一台机器
```
vagrant ssh core-01 -- -A
```
## 测试集群
使用fleet来查看机器运行状况
```
fleetctl list-machines
=>
MACHINE   IP            METADATA
517d1c7d... 172.17.8.101  -
cb35b356... 172.17.8.103  -
17040743... 172.17.8.102  -
```
如上类似的信息，恭喜，本地基于三台机器的集群已经成功启动，可能需要等个几秒才会完全启动。

那么之后你就可以基于CoreOS的三大工具做任务分发，分布式存储等很多功能了。