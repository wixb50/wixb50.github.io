+++
categories = ["ubuntu","os"]
date = "2015-12-17T13:50:50+08:00"
description = "ubuntu常见故障收集"
keywords = ["ubuntu"]
title = "ubuntu常见故障"

+++

## 目录
<!-- MarkdownTOC -->

- [ssh错误: permission denied \(publickey\)](#ssh错误-permission-denied-publickey)
- [unity菜单栏消失](#unity菜单栏消失)
- [google chrome更新出错](#google-chrome更新出错)
- [云服务器内存耗尽，打开虚拟内存](#云服务器内存耗尽，打开虚拟内存)
- [修改了SSH默认端口之后，如何配置git](#修改了ssh默认端口之后，如何配置git)
- [Linux WPS不能使用中文输入法](#linux-wps不能使用中文输入法)

<!-- /MarkdownTOC -->

## ssh错误: permission denied (publickey)
1. 登录远程主机，将/etc/ssh/sshd_config文件中的`PasswordAuthentication no` 改为`PasswordAuthentication yes`。  
2. 重启sshd服务：`/etc/init.d/sshd restart`。
3. 问题解决。

原因：scp是基于ssh的拷贝服务，ssh在没有密钥登录的情况下，禁用了密码登录，故出现如上错误

## unity菜单栏消失
1. 安装`ccsm`，终端打开`ccsm`；
2. 点击`桌面->ubuntu unity plugin`，启用、忽略错误、重启即可。
3. 点击`桌面->Desktop Wall`，启用，启用桌面快捷键。
4. 问题解决。

原因：compiz设置错误。

## google chrome更新出错
1.Setup key with:
```
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
```
2.Setup repository with:
```
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
```
3.Update package with:
```
sudo apt-get update
```
参考方案: [3rd Party Repository: Google Chrome](http://www.ubuntuupdates.org/ppa/google_chrome)

## 云服务器内存耗尽，打开虚拟内存
virtual memory exhausted: Cannot allocate memory 问题：
```
$ dd if=/dev/zero of=/swap bs=1024 count=1M 
Format the swap file: 
$ mkswap /swap 
Enable the swap file: 
$ swapon /swap 
Enable swap on boot: 
$ echo "/swap swap swap sw 0 0" >> /etc/fstab
```

## 修改了SSH默认端口之后，如何配置git
现在假设原来的项目的remote设置为git@domain.com:Projects/p1.git，将服务器SSH默认端口修改为3022后，导致push出错。

第一种解决方案:
```
# 直接修改URL为SSH://开头
git remote set-url origin ssh://git@domain.com:3022/~/Projects/p1.git
```
第二种解决方案：
```
# 修改本地配置文件
cat>~/.ssh/config
# 映射一个别名
host newdomain
hostname domain.com
port 3022
# ctrl+D
```

## Linux WPS不能使用中文输入法

因为环境变量的问题无法使用，直接修改在/usr/bin目录下的wps、wpp、et三个文件，在文件的开头加上下面的代码：
```
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
```