+++
categories = ["raspberry-pi"]
date = "2016-05-18T14:25:17+08:00"
description = "主要介绍使用树莓派搭建ownCloud个人云存储平台。"
keywords = ["raspberry-pi"]
title = "树莓派搭建ownCloud"

+++

## 简介
我们将要搭建自己的云系统平台，更精确点是一个云存储系统，我们将使用开源的软件ownCloud搭建私有云，这个平台已经适用于大多数主流平台，android、IOS、mac、linux、windows都是可以的。

首先介绍一下ownCloud： 简单来说就是一个基于PHP的自建网盘。基本上是私人使用，没有用户注册功能，但是有用户添加功能，你可以无限制地添加用户，OwnCloud还提供了不少的免费应用，这些应用可以让你更好观看视频、倾听音乐等。

## 安装步骤

### 安装LAMP套件
1.安装apache2
```
sudo apt-get install apache2
```
2.安装mysql
```
sudo apt-get install mysql-server
```
3.安装php和依赖
```
sudo apt-get install php5 php5-mysql php5-gd php5-curl #其中可能漏掉了，有错误提示的时候装上即可
```
4.从  https://owncloud.org/install/ 下载最新的ownCloud Server

5.web服务器的根目录为`/var/www/html`将文件解压到本目录即可
```
cd /var/www/html  #（网页目录）
tar -xzvf owncloud-9.0.1.tar.bz2 -C  /var/www/html   #(解压至web目录)
cd /var/www/html/owncloud         #（进入owncloud web目录）
mkdir data          #(建立数据库目录)
cd data
```
6.OwnCloud在安装的过程中需要对一些目录有写的权限,为此，web服务器用户（www-data对于基于Debian的系统）必须要拥有apps、data、config目录的权限。运行以下命令完成：
```
#owncloud 目录下
sudo chown -R www-data:www-data data 
sudo chown -R www-data:www-data config 
sudo chown -R www-data:www-data apps
```
7.打开浏览器，输入 http://IP/owncloud ,进入设置界面设计，即可访问


## 参考资料
+ [使用owncloud云服务](http://www.voidcn.com/blog/u010873775/article/p-5812004.html)