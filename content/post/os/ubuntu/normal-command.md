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