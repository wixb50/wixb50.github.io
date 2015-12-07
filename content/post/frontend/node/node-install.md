+++
categories = ["node"]
date = "2015-12-06T12:51:33+08:00"
description = "nodejs linux安装与卸载"
keywords = [""]
title = "nodejs linux安装与卸载"

+++

## Node.js 安装、卸载、升级

### 安装、源码下载

下载最新版本node的源代码：[下载](https://nodejs.org/en/download/)  

解压下载文件：  
`tar -xzvf node-v4.2.1.tar.gz`  

切换工作目录至源代码目录：  
`cd node-v4.2.1`  

`configure`配置安装文件：  
`./configure`  

make编译码代码：  *(编译Node源码时间较长，我编译用了大约40分左右。)*  
`make`   

make install安装：  
`sudo make install`  

查看安装：*(显示版本号)*  
`node -v`

### 卸载 

保留编译完成的源码包，或者自己再重新编译生成个

干掉make install命令时装进去的文件,需要管理员身份  
`sudo make uninstall`   


只删除make时产生的临时文件：  
`make clean`  

同时删除configure和make产生的临时文件  
`make distclean`

### 升级Node版本

直接下载源码重新编译，安装。（覆盖了旧的版本）

## Ps
<small>也同样适用与其他linux平台编译安装软件。</small>