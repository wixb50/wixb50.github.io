+++
categories = ["git","jenkins"]
date = "2015-11-05T13:26:17+08:00"
description = "简单ssh构建"
keywords = ["git","jenkins"]
title = "Jenkins教程-简单ssh构建"

+++

# Jenkins教程之——简单远程执行ssh构建
___
Jenkins CI is the leading open-source continuous integration server.


## 说明
___
此教程中jenkins只充当于一个中间件的作用，并且所有的构建和部署都在**远端服务器**完成。

## 安装
___
### jenkins安装
这个自行google去，教程很简单，只要把war包下载执行即可，本文是基于dokcer的jenkins镜像安装的。 
### gitlab安装 
见[gitlab官网](https://gitlab.com/)，或者可以直接使用gitlab托管源码。

## jenkins配置
___
1.配置安全设置：`系统管理->Configure Global Security`中启用安全，然后根据自己需要，可配置用户权限等。  

2.插件安装：`系统管理->管理插件`中安装可选插件，本教程中需要的插件有：GIT client plugin、GIT plugin、Gitlab Hook Plugin、**Publish Over SSH**。  

3.新建一个`构建一个自由风格的软件项目`，输入名称(不要带大写)。  

4.然后在`源码管理`地方选择`Git`输入`Repository URL`，以及配置好`Credentials`(可选择username或者ssh配置)，完成后选择要构建的分支`e.g.,*/develop`。  

5.**构建触发器**选择`触发远程构建`，并根据提示填好身份令牌，**并且在**你的`gitlab项目`中设置好`web hook(e.g.,JENKINS_URL/job/zeu_frontend/build?token=TOKEN_NAME)`。  

6.**构建**`增加构建步骤`选择`send files or execute commands over ssh`，然后配置好组要在远端执行脚本的ssh server测试能连接上，然后在`Exec command`中输入脚本，或者`Transfer Set Source files`可以执行jenkins中的脚本在远端执行，这里简单起见，就直接输入命令。  

7.这样就差不多了，还有想加的步骤，自己加把，提交一下，是不是自己开始构建了呢。  

**提示：**输入的脚本要自己在远端跑一下，能完整跑通才行，注意为远程服务器git配置号user和name，以及sshKey，这样就不要输入密码pull了。  

## Auth
___
Support by [elegancetse](http://elegencetse.com).