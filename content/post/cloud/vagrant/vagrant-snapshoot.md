+++
categories = ["cloud","vagrant"]
date = "2015-11-03T12:45:55+08:00"
description = "Vagrant建立快照"
keywords = ["vagrant"]
title = "Vagrant建立快照"

+++

>使用Vagrant的快照功能可以很方便快速的创建当前虚拟机的一个临时备份状态，在进行重要操作时可以先创建一个快照以便在操作失误后快速恢复。

安装Vagrant快照插件：  
`vagrant plugin install vagrant-multiprovider-snap`

```
$ vagrant snap
Usage: vagrant snap <command> [<args>]

Available subcommands:
     back
     delete
     go
     list
     take

For help on any individual command run `vagrant snapshot <command> -h
```

使用方法：  

+ 创建一个快照  
`vagrant snapshot take "Name"`
+ 查看快照列表  
`vagrant snapshot list`
+ 从指定快照中恢复  
`vagrant snapshot go "Name"`
+ 删除一个快照  
`vagrant snapshot delete "Name"`

---
一些参考资料：  

+ [使用 Vagrant 打造跨平台开发环境](http://segmentfault.com/a/1190000000264347)
+ [Vagrant 三种网络配置详解](http://www.williamsang.com/archives/2401.html)