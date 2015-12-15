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
- [linux下怎样设置ssh无密码登录](#linux下怎样设置ssh无密码登录)
    - [1.生成公钥和私钥](#1生成公钥和私钥)
    - [2.导入公钥到认证文件,更改权限](#2导入公钥到认证文件更改权限)
        - [2.1 导入本机](#21-导入本机)
        - [2.2 导入要免密码登录的服务器](#22-导入要免密码登录的服务器)
        - [2.3 在服务器上更改权限](#23-在服务器上更改权限)
    - [3.测试](#3测试)

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
>这个命令最常用的参数是-s，具体用法是(软链接)：  

`sudo ln -s 源文件 目标文件 `

>删除链接  

`rm -rf   symbolic_name   注意不是rm -rf   symbolic_name/`

## linux下怎样设置ssh无密码登录
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
首先将公钥复制到服务器，Shell代码 
```
scp ~/.ssh/id_rsa.pub xxx@host:~/id_rsa.pub  
```
然后，将公钥导入到认证文件，这一步的操作在服务器上进行，Shell代码 
```
cat ~/id_rsa.pub >> ~/.ssh/authorized_keys 
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