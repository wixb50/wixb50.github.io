+++
categories = ["ubutnu","software"]
date = "2015-11-12T10:23:25+08:00"
description = "保存自己的常用软件集合,以及安装方法。"
keywords = []
title = "ubuntu常用软件集合"

+++

### Broswer

+ [chrome](http://www.google.cn/intl/zh-CN/chrome/browser/desktop/index.html) 下载deb包安装

### Editor

+ The Most Intelligent Java IDE:[Intellij IDEA](https://www.jetbrains.com/idea/)  
1.安装配置好JDK环境,下载tar.gz文件,解压到`tar -zxvf ideaIU-14.tar.gz -C /usr/local/intellijIDEA(自己命名)`;  
2.进入安装目录下的bin目录，执行`./idea.sh`.
```
几个license：
(1)
key:IDEA
value:61156-YRN2M-5MNCN-NZ8D2-7B4EW-U12L4
(2)
key:huangwei
value:97493-G3A41-0SO24-W57LI-Y2UGI-JGTU2
(3)
key:itey
value:91758-T1CLA-C64F3-T7X5R-A7YDO-CRSN1
```
+ [Sublime Text 3](http://www.sublimetext.com/3) 下载deb包安装
+ 神一样的[Vim](http://www.vim.org/)
+ [Emacs](https://www.gnu.org/software/emacs/) How to [Install](http://ubuntuhandbook.org/index.php/2014/10/emacs-24-4-released-install-in-ubuntu-14-04/)
+ 简单的MD编辑器[Retext](http://sourceforge.net/projects/retext/)

### Git
安装`sudo apt-get install git`  

+ git客户端[SmartGit](http://www.syntevo.com/smartgit/) 建议直接命令行  

>删除`.smartgit`下面的`settings.xml`即可重新使用1个月。

### 美化

>默认使用Unity桌面

+ unity-tweak-tool  
 安装`sudo apt-get install unity-tweak-tool` 
+ 也可以通过安装ubuntu-tweak来实现主题更换  
```
sudo add-apt-repository ppa:tualatrix/ppa
sudo apt-get update
sudo apt-get install ubuntu-tweak
```
+ 主题网址[http://gnome-look.org/](http://gnome-look.org/) 将解压的主题文件夹拷贝到/usr/share/themes/目录下,然后使用`unity-tweak-tool`选择;
+ icon网址[https://github.com/NitruxSA/ardis-icon-theme](https://github.com/NitruxSA/ardis-icon-theme) 将解压的主题文件夹拷贝到/usr/share/icons/目录下,然后使用`unity-tweak-tool`选择;或者直接命令安装再设置;

### SQL

+ Mysql客户端 [Workbench](http://dev.mysql.com/downloads/workbench/) 下载deb安装
+ Redis客户端 [Redis Desktop Manager](http://redisdesktop.com/) 下载deb安装
+ Mongo客户端 [Robomongo](http://robomongo.org/) 下载deb安装 

### 思维导图

+ 最流行的思维导图 [XMind](http://www.xmind.net/cn/) 下载deb安装 
+ 百度在线脑图 [百度脑图](http://naotu.baidu.com/)

### 影音

+ `VLC Media Player` 软件商店安装

### FQ

+ 开放网络客户端 [Lantern](https://getlantern.org/)

### 虚拟机

+ 开源[VirtualBox](https://www.virtualbox.org/wiki/Downloads) 下载deb安装 

### Develop

Frontend：  

+ [node](https://nodejs.org/en/) 最好编译安装 [install-tutorial](https://linux.cn/article-5766-1.html)
+ [npm](null-link) node包管理器
+ [bower](null-link) 前端开发包管理器
+ [gulp](null-link) 构建工具
+ [grunt-cli]() 比较老的构建工具

Backend：  

+ [Go]() 解压存放`/usr/local/go`,配置好`GOROOT、GOPATH`和path环境。`GOPATH`最好一个就够了。

> GoTools：`gocode`代码自动化提示工具。`godep`go包管理器。`goconvey`go测试工具。  
> Tips：如需sudo也支持go命令,执行链接命令：`sudo ln -s /usr/local/go/bin/go /usr/bin/go`。

+ [gradle]() java包管理器,构建工具

Server：  

+ [Docker]() 容器化服务器
+ [vagrant]() 虚拟机管理工具
