+++
categories = ["CentOS","os","command"]
date = "2016-06-01T10:07:33+08:00"
description = "CentOS常用命令集合"
keywords = ["CentOS","command"]
title = "CentOS常用命令集合"

+++


## CentOS添加及删除用户

```
adduser int # 新增用户
passwd int # 设置或者修改密码
chmod 740 /etc/sudoers # 设置超级管理员组配置文件可写
vim /etc/sudoers # 编辑文件
```
添加int如下
```
## Allow root to run any commands anywhere 
root    ALL=(ALL)   ALL
int ALL=(ALL)   ALL
```
其他命令
```
userdel test # 删除用户
userdel -f test # 删除用户及用户组
```