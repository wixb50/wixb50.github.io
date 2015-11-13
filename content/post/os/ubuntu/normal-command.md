+++
categories = ["ubuntu","os","command"]
date = "2015-11-07T22:07:33+08:00"
description = "ubuntu常用命令集合"
keywords = ["ubuntu","command"]
title = "ubuntu常用命令集合"

+++

### 关机、重启命令

```
shutdown –help  #可以查看shutdown命令如何使用，当然也可以使用man shutdown命令。
shutdown -h now #现在立即关机
shutdown -r now #现在立即重启
shutdown -r +3 #三分钟后重启
shutdown -h +3 “The System will shutdown after 3 minutes” #提示使用者将在三分钟后关机
shutdown -r 20:23 #在20：23时将重启计算机
shutdown -r 20:23 & #可以将在20：23时重启的任务放到后台去，用户可以继续操作终端
```

### ln 命令

功能是为某一个文件或目录在另外一个位置建立一个同步的链接：  

这里有两点要注意：ln的链接又 软链接和硬链接两种，软链接就是ln –s ** **，它只会在你选定的位置上生成一个文件的镜像，不会占用磁盘空间，硬链接ln ** **，没有参数-s， 它会在你选定的位置上生成一个和源文件大小相同的文件。
>这个命令最常用的参数是-s，具体用法是(软链接)：  

`sudo ln -s 源文件 目标文件 `

>删除链接  

`rm -rf   symbolic_name   注意不是rm -rf   symbolic_name/`