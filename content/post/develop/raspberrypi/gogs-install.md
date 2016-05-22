+++
categories = ["raspberry-pi"]
date = "2016-05-18T14:25:17+08:00"
description = "主要介绍使用树莓派安装Gogs搭建个人git服务器。"
keywords = ["raspberry-pi"]
title = "树莓派安装Gogs"

+++

## 简介
本文主要介绍二进制安装方案，如果想用其他方法安装，请参考[官方文档](https://gogs.io/docs);

## 准备工作
1. 所有的版本都支持 MySQL 和 PostgreSQL、SQLite作为数据库，针对你想要存放的位置建立好数据库服务器。
2. 在 https://github.com/gogits/gogs/releases 下载号对应的二进制安装包，下载最新的rsapi*.zip即可，导入到树莓派中。

## 新建用户
Gogs 默认以 git 用户运行，所以最好新建一个用户，要不然可能会出现你的主账户无法登录的问题。运行`sudo adduser git`新建好用户，`su git`以git用户身份登录。
## 运行配置
1. 解压压缩包。
2. 使用命令 cd 进入到刚刚创建的目录。
3. 执行命令 ./gogs web，然后，访问http://IP:3000，填写服务器信息就可以了(建议直接使用SQLite，反正就你自己用)。

## 部署应用

### 端口问题
端口占用问题，可以通过启动命令指定端口
```
./gogs web -port 3001
```

### 开机启动
**采用Systemd以守护进程定义service运行。**

1.在`/etc/systemd/system/gogs.service`新建文件。
```
[Unit]
Description=Gogs (Go Git Service)
After=syslog.target
After=network.target
#After=mysqld.service
#After=postgresql.service
#After=memcached.service
#After=redis.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
Type=simple
User=git
Group=git
WorkingDirectory=/home/git/gogs
ExecStart=/home/git/gogs/gogs web
Restart=always
Environment=USER=git HOME=/home/git

[Install]
WantedBy=multi-user.target
```

2.更新 User、Group、WorkingDirectory、ExecStart 和 Environment 为相对应的值。其中 WorkingDirectory 为您的 Gogs 实际安装路径根目录。

3.[可选] 如果您 Gogs 安装示例使用 MySQL/MariaDB、PostgreSQL、Redis 或 memcached，请去掉相应 After 属性的注释。

4.然后通过 `sudo systemctl enable gogs` 命令激活，最后执行 `sudo systemd start gogs`，就可以做到开机启动了。

## 参考文档
+ [Gogs二进制安装](https://gogs.io/docs/installation/install_from_binary)