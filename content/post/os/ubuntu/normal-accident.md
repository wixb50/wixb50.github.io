+++
categories = ["ubuntu","os"]
date = "2015-12-17T13:50:50+08:00"
description = "ubuntu常见故障收集"
keywords = ["ubuntu"]
title = "ubuntu常见故障"

+++

## 目录
<!-- MarkdownTOC -->

- [ssh错误: permission denied (publickey)](#ssh错误-permission-denied-publickey)

<!-- /MarkdownTOC -->

## ssh错误: permission denied (publickey)
1. 登录远程主机，将/etc/ssh/sshd_config文件中的`PasswordAuthentication no` 改为`PasswordAuthentication yes`。  
2. 重启sshd服务：`/etc/init.d/sshd restart`。
3. 问题解决。

原因：scp是基于ssh的拷贝服务，ssh在没有密钥登录的情况下，禁用了密码登录，故出现如上错误