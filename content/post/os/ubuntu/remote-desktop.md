+++
categories = ["os","ubuntu"]
date = "2015-12-06T17:27:25+08:00"
description = "ubuntu搭建远程桌面服务器"
keywords = ["desktop"]
title = "ubuntu搭建远程桌面服务器"

+++

1、安装xrdp和vnc4server  
```
sudo apt-get install xrdp
sudo apt-get install vnc4server
```
tightvncserver在ubuntu14.04下面是不用装的，如果连接的是ubuntu12.04的话。是需要安装的
```
sudo apt-get install tightvncserver
```
2、安装xfce4的桌面
```
sudo apt-get install xubuntu-desktop
echo "xfce4-session" >~/.xsession  #在需要远程登录的用户下执行一遍即可
sudo service xrdp restart
```
如果无法远程连接成功，记得在终端下执行：
```
sudo reboot
```
重新启动系统。  

Windows下的操作：  
使用"窗口键+R"打开"运行对话框"-->输入"mstsc"-->回车-->输入Ubuntu主机的IP地址-->"连接"。在Ubuntu下可以通过“ifconfig”获得本机网络连接的概况，其中包括IP地址。
填上正确的IP地址，按回车，会出现一个登陆框，我们选择“sesman-Xvnc”这个，然后输入你的Ubuntu的用户名和密码，OK！

后记：使用这种方法连上Ubuntu还有个问题，就是键盘的快捷键会有点小混乱。此时断开远程桌面，在Ubuntu的实体机器上，打开管理键盘快捷键，将带有“windows”键，ubunntu显示是“mod5”键（好像是类似的，记不清了）的快捷键组合删掉即可。