+++
categories = ["ubuntu","os","command"]
date = "2015-11-07T22:07:33+08:00"
description = "ubuntu常用命令集合"
keywords = ["ubuntu","command"]
title = "ubuntu常用命令集合"

+++
## 目录
<!-- MarkdownTOC -->

- [shutdown 命令](#shutdown-命令)
- [ln 命令](#ln-命令)
- [linux下设置ssh无密码登录](#linux下设置ssh无密码登录)
  - [1.生成公钥和私钥](#1生成公钥和私钥)
  - [2.导入公钥到认证文件,更改权限](#2导入公钥到认证文件更改权限)
    - [2.1 导入本机](#21-导入本机)
    - [2.2 导入要免密码登录的服务器](#22-导入要免密码登录的服务器)
    - [2.3 在服务器上更改权限](#23-在服务器上更改权限)
  - [3.测试](#3测试)
- [dpkg命令](#dpkg命令)
- [apt命令](#apt命令)
  - [软件安装后相关文件位置](#软件安装后相关文件位置)
- [设置su密码的命令](#设置su密码的命令)
- [新增User](#新增user)
- [fg、bg、jobs、&、nohup、ctrl+z、ctrl+c 、kill命令](#fg、bg、jobs、、nohup、ctrlz、ctrlc-、kill命令)
- [kill，killall，pkill，xkill 命令](#kill，killall，pkill，xkill-命令)
- [add-apt-repository命令](#add-apt-repository命令)

<!-- /MarkdownTOC -->

## shutdown 命令

```
shutdown –help  #可以查看shutdown命令如何使用，当然也可以使用man shutdown命令。
shutdown -h now #现在立即关机
shutdown -r now #现在立即重启
shutdown -r +3 #三分钟后重启
shutdown -h +3 “The System will shutdown after 3 minutes” #提示使用者将在三分钟后关机
shutdown -r 20:23 #在20：23时将重启计算机
shutdown -r 20:23 & #可以将在20：23时重启的任务放到后台去，用户可以继续操作终端
```

## ln 命令

功能是为某一个文件或目录在另外一个位置建立一个同步的链接：  

这里有两点要注意：ln的链接又 软链接和硬链接两种，软链接就是ln –s ** **，它只会在你选定的位置上生成一个文件的镜像，不会占用磁盘空间，硬链接ln ** **，没有参数-s， 它会在你选定的位置上生成一个和源文件大小相同的文件。

+ 这个命令最常用的参数是-s，具体用法是(软链接)：  

```
sudo ln -s 源文件 目标文件
```

+ 删除链接  

```
rm -rf   symbolic_name   注意不是rm -rf   symbolic_name/
```

## linux下设置ssh无密码登录
原理说明
>密匙认证需要依靠密匙，  
1.首先创建一对密匙（包括公匙和密匙，并且用公匙加密的数据只能用密匙解密），并把公匙放到需要远程服务器上。  
2.这样当登录远程 服务器时，客户端软件就会向服务器发出请求，请求用你的密匙进行认证。  
3.服务器收到请求之后，先在你在该服务器的宿主目录下寻找你的公匙，然后检查该公匙是 否是合法，如果合法就用公匙加密一随机数（即所谓的challenge）并发送给客户端软件。  
4.客户端软件收到 “challenge”之后就用私匙解密再把它发送给服务器。因为用公匙加密的数据只能用密匙解密，服务器经过比较就可以知道该客户连接的合法性。

### 1.生成公钥和私钥
Shell代码 
```
ssh-keygen -t rsa
```
默认在 ~/.ssh目录生成两个文件：  
　id_rsa      ：私钥  
　id_rsa.pub  ：公钥  
### 2.导入公钥到认证文件,更改权限
#### 2.1 导入本机
Shell代码 
```
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys  
```
#### 2.2 导入要免密码登录的服务器
方法一：
首先将公钥复制到服务器，Shell代码 
```
scp ~/.ssh/id_rsa.pub xxx@host:~/id_rsa.pub  
```
然后，将公钥导入到认证文件，这一步的操作在服务器上进行，Shell代码 
```
cat ~/id_rsa.pub >> ~/.ssh/authorized_keys 
```
方法二：
直接用命令将公钥添加到远程服务器上去
```
cat ~/.ssh/id_rsa.pub | ssh root@[your.ip.address.here] "cat >> ~/.ssh/authorized_keys"
```
可以执行测试登录，如果无任何错误提示，可以输密码登录，但就是不能无密码登录，则执行下步。
#### 2.3 在服务器上更改权限
Shell 代码
```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys 
```
### 3.测试
执行Shell
```
ssh xxx@host
```
第一次登录可能需要yes确认，之后就可以直接登录了。

## dpkg命令
以下是一些 Dpkg 的普通用法：   

1. dpkg -i  
        安装一个 Debian 软件包，如你手动下载的文件。   
2. dpkg -c    
        列出包的内容。   
3. dpkg -I    
       从 中提取包裹信息。   
4. dpkg -r    
        移除一个已安装的包裹。   
5. dpkg -P    
      完全清除一个已安装的包裹。和 remove 不同的是，remove 只是删掉数据和可执行文件，purge 另外还删除所有的配制文件。   
6. dpkg -L    
      列出 安装的所有文件清单。同时请看 dpkg -c 来检查一个 .deb 文件的内容。   
7. dpkg -s    
      显示已安装包裹的信息。同时请看 apt-cache 显示 Debian 存档中的包裹信息，以及 dpkg -I 来显示从一个 .deb 文件中提取的包裹信息。   
8. dpkg-reconfigure    
      重新配制一个已经安装的包裹，如果它使用的是 debconf (debconf 为包裹安装提供了一个统一的配制界面)。 

## apt命令
### 软件安装后相关文件位置
1. 下载的软件存放位置

    /var/cache/apt/archives

2. 安装后软件默认位置
     
     /usr/share

3. 可执行文件位置 
     
     /usr/bin

4. 配置文件位置
      
      /etc

5. lib文件位置
    
    /usr/lib  
    
**其他几个和apt-get相关的目录:  **

/var/lib/dpkg/available  
文件的内容是软件包的描述信息, 该软件包括当前系统所使用的 Debian 安装源中的所有软件包,其中包括当前系统中已安装的和未安装的软件包.  

/var/cache/apt/archives  
目录是在用 apt-get install 安装软件时，软件包的临时存放路径  

/etc/apt/sources.list  
存放的是软件源站点, 当你执行 sudo apt-get install xxx 时，Ubuntu 就去这些站点下载软件包到本地并执行安装  

/var/lib/apt/lists  
使用apt-get update命令会从/etc/apt/sources.list中下载软件列表，并保存到该目录  

## 设置su密码的命令  
Ubuntu安装之默认状态下是不能使用su命令了，如果我们要使用su命令需要把root设置一个密码这样就可以使用su命令了。
 
使用sudo  
```
sudo passwd  
```
系统提示输入密码，即安装时的用户密码，然后，系统提示输入两次新密码，输入完毕后，  
```
su  
```
即可进入su，具备了相应的权限了.  

[NOTICE] : 在terminal中利用su命令就可以切换到root用户了。  
注：su和sudo的区别是：  
1). su的密码是root的密码，而sudo的密码是用户的密码；  
2). su直接将身份变成root，而sudo是以用户登录后以root的身份运行命令，不需要知道root密码；  

## 新增User
+ 使用有权限的用户，在终端里输入
```
sudo adduser username
```
然后一直回车即可，新建成功。

+ 添加sudo用户

>当你安装Ubuntu的时候，它会自动添加第一个用户到sudo组，允许这个用户通过键入其自身帐户密码来获得超级用户(root)身份。然而，系统不会再自动添加其他的用户到sudo组当中去。如果你想在你的共享系统上授予某人某些超级用户特权，你必须给予他们sudo权利。

要添加新用户到sudo，最简单的方式就是使用 usermod 命令。运行
```
sudo usermod -G sudo username
```
如果用户已经是其他组的成员，你需要添加 -a 这个选项，象这样
```
sudo usermod -a -G sudo username
```

## fg、bg、jobs、&、nohup、ctrl+z、ctrl+c 、kill命令

+ &
```
加在一个命令的最后，可以把这个命令放到后台执行，如

watch  -n 10 sh  test.sh  &  #每10s在后台执行一次test.sh脚本
```
+ ctrl + z
```
可以将一个正在前台执行的命令放到后台，并且处于暂停状态。
```
+ jobs
```
查看当前有多少在后台运行的命令

jobs -l选项可显示所有任务的PID，jobs的状态可以是running, stopped, Terminated。但是如果任务被终止了（kill），shell 从当前的shell环境已知的列表中删除任务的进程标识。
```
+ fg
```
将后台中的命令调至前台继续运行。如果后台中有多个命令，可以用fg %jobnumber（是命令编号，不是进程号）将选中的命令调出。
```
+ bg
```
将一个在后台暂停的命令，变成在后台继续执行。如果后台中有多个命令，可以用bg %jobnumber将选中的命令调出。
```
+ kill
```
法子1：通过jobs命令查看job号（假设为num），然后执行kill %num
法子2：通过ps命令查看job的进程号（PID，假设为pid），然后执行kill pid
前台进程的终止：Ctrl+c
```
+ nohup
```
如果让程序始终在后台执行，即使关闭当前的终端也执行（之前的&做不到），这时候需要nohup。该命令可以在你退出帐户/关闭终端之后继续运行相应的进程。关闭中断后，在另一个终端jobs已经无法看到后台跑得程序了，此时利用ps（进程查看命令）

ps -aux | grep "test.sh"  #a:显示所有程序 u:以用户为主的格式来显示 x:显示所有程序，不以终端机来区分
```

## kill，killall，pkill，xkill 命令

+ kill
```
kill ［信号代码］ 进程ID（kill  -pid）
－s：指定发送的信号。 
－p：模拟发送信号。 
－l：指定信号的名称列表。 
pid：要中止进程的ID号。 
Signal：表示信号。
注：信号代码可以省略；我们常用的信号代码是-9 ，表示强制终止；对于僵尸进程，可以用kill -9 来强制终止退出；
```
+ killall
```
killall 通过程序的名字，直接杀死所有进程。
用法：killall 正在运行的程序名
killall 也和ps或pgrep 结合使用，比较方便；通过ps或pgrep 来查看哪些程序在运行
```
+ pkill
```
pkill 和killall 应用方法差不多，也是直接杀死运行中的程序；如果您想杀掉单个进程，请用kill 来杀掉。
用法：pkill 正在运行的程序名
```
+ xkill
```
xkill 是在桌面用的杀死图形界面的程序。比如当firefox 出现崩溃不能退出时，点鼠标就能杀死firefox 。
当xkill运行时出来和个人脑骨的图标，哪个图形程序崩溃一点就OK了。如果您想终止xkill ，就按右键取消；
xkill 调用方法：
[root@localhost ~]# xkill
```

## add-apt-repository命令
个人软件包档案（PPA）是Ubuntu独有的解决方案，允许独立开发者和贡献者构建、贡献任何定制的软件包来作为通过启动面板的第三方APT仓库。如果你是Ubuntu用户，有可能你已经增加一些流行的第三方PPA仓库到你的Ubuntu系统。如果你需要删除掉已经预先配置好的PPA仓库，下面将教你怎么做。

假如你想增加一个叫“ppa:webapps/preview”第三方PPA仓库到你的系统中，如下：
```
$ sudo add-apt-repository ppa:webapps/preview
```
如果你想要 单独地删除某个PPA仓库，运行下面的命令：
```
$ sudo add-apt-repository --remove ppa:someppa/ppa 
```
注意，上述命令不会同时删除任何已经安装或更新的软件包。

如果你想要 完整的删除一个PPA仓库并包括来自这个PPA安装或更新过的软件包，你需要ppa-purge命令。

```
# 首先要安装ppa-purge软件包
$ sudo apt-get install ppa-purge
# 然后使用如下命令删除PPA仓库和与之相关的软件包
$ sudo ppa-purge ppa:webapps/preview 
```
这样就ok了。

