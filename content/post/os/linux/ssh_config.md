+++
categories = ["linux"]
date = "2016-04-28T18:15:30+08:00"
description = "使用ssh_config来管理ssh会话"
keywords = ["linux"]
title = "ssh_config来管理ssh会话"

+++

## 简介
通常利用 ssh 连接远程服务器，一般都要输入以下类型命令：
```
ssh user@hostname -p port
```
但是如果有多个服务器的话，每次都需要重新输入，还需要专门记忆，个人比较懒，不想记这么多，也不想为了登录一个server，打重复代码太多。

一般，有一种解决方案是，采用第三方的manager工具，比如：putty、PAC manager，但是对于喜欢在终端玩耍的孩纸就不喜欢这个了。

## ssh_config方案
还好，ssh提供一种优雅灵活的方案，就是利用ssh的用户配置文件config管理ssh会话。ssh的用户配置文件放在用户`~/.ssh/config`目录中，不存在则新建一个。配置语法如下：
```
Host 别名
    HostName  主机名
    User      用户名
    Port      端口，默认22
    IdentityFile 密钥文件的路径，默认当前目录的
```
有了这些配置，就可以这样用ssh 登录服务器了：
```
ssh 别名
```

## Ps
如果需要实现无密码登录主机的，请在自行google配置。