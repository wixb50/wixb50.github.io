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