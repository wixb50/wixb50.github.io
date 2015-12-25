+++
categories = ["ubutnu","software"]
date = "2015-11-12T10:23:25+08:00"
description = "保存自己的常用软件集合,以及安装方法。"
keywords = []
title = "ubuntu常用软件集合"

+++

## 目录
<!-- MarkdownTOC -->

- [Broswer](#broswer)
- [Editor](#editor)
- [Git](#git)
- [美化](#美化)
- [添加字体](#添加字体)
- [SQL](#sql)
- [思维导图](#思维导图)
- [影音](#影音)
- [FQ](#fq)
- [虚拟机](#虚拟机)
- [Linux WPS](#linux-wps)
- [Develop](#develop)
- [LaTex](#latex)
- [Aria2下载工具](#aria2下载工具)
- [终端工具Terminator](#终端工具terminator)

<!-- /MarkdownTOC -->


### Broswer

+ [chrome](http://www.google.cn/intl/zh-CN/chrome/browser/desktop/index.html) 下载deb包安装，同步自己的chrome配置

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

### 添加字体

+ ubuntu添加字体非常简单，只需要在～目录下新建`.fonts`文件夹，然后把后缀为`.ttf`字体文件复制其中，就自动加入了。可以使用软件查看。

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
+ [Shadowsocks](https://shadowsocks.org/en/index.html) 装好之后还要设置浏览器代理  

安装PPA is for Ubuntu >= 14.04.
```
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5
```
设置**火狐浏览器**，代理设置
```
选择Manual Proxy Configuration，在Socks Host写入127.0.0.1，Port 1080。下面选Socks v5。点OK确认。
```
以代理模式启动**Chrome**命令如下：
```
google-chrome --proxy-server=socks5://127.0.0.1:1080
```
**[NOTICE] : Chrome推荐使用[SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega/releases)插件进行设置。自动规则：[wiki-GEWList](https://github.com/FelisCatus/SwitchyOmega/wiki/GFWList).**

### 虚拟机

+ 开源[VirtualBox](https://www.virtualbox.org/wiki/Downloads) 下载deb安装 

### Linux WPS

+ [WPS官网](http://www.wps.cn/)下载linux下的安装包，下载[Symbol 字体安装包](http://pan.baidu.com/s/1o7wTo7o)安装
```
#安装wps
sudo dpkg -i wps-office_9.1.0.4975-a19p1_amd64.deb
#安装symbol字体包
sudo dpkg -i symbol-fonts_1.2_all.deb
```

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

### LaTex
+ TexLive2015安装

    下载地址：

    + [官方镜像](http://mirrors.ctan.org/systems/texlive/Images/texlive2015.iso)
    + [USTC镜像](http://mirrors.ustc.edu.cn/CTAN/systems/texlive/Images/texlive2015.iso)  

**挂载ISO镜像**
```
mount -o loop texlive2015.iso  /mnt/
cd /mnt
sudo ./install-tl
```
出现选项后，输入 I 直接安装（也可以更改选项）。不出意外的话，5分钟应该就OK了。

**环境变量**  
在当前用户的 ~/.bashrc 中加入如下语句：  
```
# TeX Live 2015
export MANPATH=${MANPATH}:/usr/local/texlive/2015/texmf-dist/doc/man
export INFOPATH=${INFOPATH}:/usr/local/texlive/2015/texmf-dist/doc/info
export PATH=${PATH}:/usr/local/texlive/2015/bin/x86_64-linux  #建议还是把这个配置到/etc/profile里面去，这样texstudio打开能够识别

```
上面的建议如果出现找不到tex环境时候可以用一下。  
**卸载ISO镜像**  
```
$ cd
$ sudo umount /mnt/
```
[参考文档](http://seisman.info/install-texlive-under-linux.html)

+ TexStudio  
    [官网](http://texstudio.sourceforge.net/)下载deb安装包安装即可

### Aria2下载工具
[官网介绍](http://aria2.sourceforge.net/)
```
sudo apt-get install aria2
```

### 终端工具Terminator

+ 安装
```
sudo apt-get install terminator
```

+ 然后利用 Debian 的重新配置命令选择默认终端：
```
sudo update-alternatives --config x-terminal-emulator
```

+ terminator配置文件在~/.config/terminator/config 可以通过这个配置文件配置terminator的字体和颜色.
```
font = Monaco 10  #设置体字
background_color = "#204070" # 背景颜色
foreground_color = "#F0F0F0" # 字体颜色
cursor_blink = True          # 设置光标
scrollbar_position = disabled # 禁用滚动条
titlebars = no # 禁用标题栏
background_darkness = 0.4
background_type = transparent # 背景类型可以设置为图片
```
 更多配置见：`man terminator_config`

 + 快捷键
```
F11 #Toggle fullscreen
Ctrl + Shift+ O #Split terminals horizontally
Ctrl + Shift+ E #Split terminals vertically
Ctrl + Shift+ W #Close current Panel
Ctrl + Shift+ T #Open new tab

Ctrl+Shift+C 复制
Ctrl+Shift+V 粘贴
Ctrl+Shift+N 或者 Ctrl+Tab 在分割的各窗口之间切换
Ctrl+Shift+X 将分割的某一个窗口放大至全屏使用
Ctrl+Shift+Z 从放大至全屏的某一窗口回到多窗格界面

Alt + ↑ #Move to the terminal above the current one
Alt + ↓ #Move to the terminal below the current one
Alt + ← #Move to the terminal left of the current one
Alt + → #Move to the terminal right of the current one
```

+ 一个不错的配置
```
[global_config]
  title_transmit_bg_color = "#d30102"
  focus = system
  suppress_multiple_term_dialog = True
[keybindings]
[profiles]
  [[default]]
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    copy_on_selection = True
    background_image = None
    background_darkness = 0.85
    background_type = transparent
    use_system_font = False
    cursor_color = "#eee8d5"
    foreground_color = "#839496"
    show_titlebar = False
    font = Ubuntu Mono 14
    background_color = "#002b36"
  [[solarized-dark]]
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    background_color = "#002b36"
    background_image = None
    cursor_color = "#eee8d5"
    foreground_color = "#839496"
  [[solarized-light]]
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    background_color = "#fdf6e3"
    background_image = None
    cursor_color = "#002b36"
    foreground_color = "#657b83"
[layouts]
  [[default]]
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = default
    [[[window0]]]
      type = Window
      parent = ""
[plugins]
```
透明高亮很Geek.

+ 参考资料   
[开始使用Ubuntu作为工作环境](http://blog.codinglabs.org/articles/getting-started-with-ubuntu.html)
