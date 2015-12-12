+++
categories = ["ubuntu","os"]
date = "2015-12-08T16:43:33+08:00"
description = "ubuntu更改源设置"
keywords = ["source"]
title = "ubuntu更改源设置"

+++

+ 首先备份源列表：

```
sudo cp /etc/apt/sources.list /etc/apt/sources.list_backup
```

+ 而后用vim或其他编辑器打开:

```
sudo vim /etc/apt/sources.list
```

+ 从下面列表中选择合适的源，替换掉文件中所有的内容，保存编辑好的文件:

    <font color="red">注意：一定要选对版本</font>

+ 最后，刷新列表

```
sudo apt-get update
```


*附上ubuntu14.04源：*  

网易163源：
```
deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
```
搜狐源：
```
deb http://mirrors.sohu.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-backports main restricted universe multiverse
```
oschina源：
```
deb http://mirrors.oschina.net/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.oschina.net/ubuntu/ trusty-backports main restricted universe multiverse
deb http://mirrors.oschina.net/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.oschina.net/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.oschina.net/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.oschina.net/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.oschina.net/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.oschina.net/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.oschina.net/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.oschina.net/ubuntu/ trusty-updates main restricted universe multiverse
```