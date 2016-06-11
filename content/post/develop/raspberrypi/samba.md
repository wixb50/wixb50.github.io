+++
categories = ["raspberry-pi"]
date = "2016-05-24T20:25:17+08:00"
description = "主要介绍树莓派samba搭建离线下载器。"
keywords = ["raspberry-pi"]
title = "树莓派samba离线下载器"

+++

## 简介
主要用samba实现局域网共享。

## 安装
apt安装：
```
sudo apt-get install samba samba-common-bin
```

配置文件/etc/samba/smb.conf，在最后添加以下命令：
```
[raspi]                                   #共享文件的名称，将在网络上以此名称显示
        path = /mnt/myusbdrive                     #共享文件的路径
        valid users = pi             #允许访问的用户
        browseable = yes                  #允许浏览                                 
        public = yes                      #共享开放                                      
        writable = yes                    #可写
```

保存后，重启 samba 服务，输入:
```
sudo /etc/init.d/samba restart
```

设置密码：
```
smbpasswd –a pi
```

## 连接
在`nautilus`中选择连接到服务器，地址为`smb://192.168.1X.10X/`，连接输入用户名密码即可。或者在windows上映射到网络驱动器，地址`\\192.1.1.1XX\{{你的目录}}`即可连接。