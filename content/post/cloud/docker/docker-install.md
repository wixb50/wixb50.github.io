+++
categories = ["docker","cloud"]
date = "2015-11-02T21:38:38+08:00"
description = "简述docker的安装与配置"
keywords = ["docker"]
title = "docker安装与配置"

+++

### 安装命令，运行即可
```
sudo apt-get install apt-transport-https
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo bash -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker
```

___
完