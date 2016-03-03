+++
categories = ["linux"]
date = "2016-02-26T22:15:30+08:00"
description = "linux 路由表设置 之 route 指令详解"
keywords = ["linux"]
title = "linux 路由表设置 之 route 指令"

+++


## 简介
路由表（routing table）是一个存储在路由器或者联网计算机中的电子表格或类数据库。路由表存储着指向特定网络地址的路径（在有些情况下，还记录有路径的路由度量值）。路由表中含有网络周边的拓扑信息。路由表建立的主要目标是为了实现路由协议和静态路由选择。

在Linux系统中，设置路由通常是为了解决以下问题：该Linux系统在一个局域网中，局域网中有一个网关，能够让机器访问Internet，那么就需要将这台机器的IP地址设置为Linux机器的默认路由。要注意的是，直接在命令行下执行route命令来添加路由，不会永久保存，当网卡重启或者机器重启之后，该路由就失效了;可以在/etc/rc.local中添加route命令来保证该路由设置永久有效。

## 使用实例

route 或者 route -n
```
# route 
Destination     Gateway         Genmask Flags Metric Ref    Use Iface  
192.168.0.0     *               255.255.255.0   U     0      0        0 eth0  
169.254.0.0     *               255.255.0.0     U     0      0        0 eth0  
default         192.168.0.1     0.0.0.0         UG    0      0        0 eth0 
```
route 命令的输出项说明：  

Gateway 网关地址，”*” 表示目标是本主机所属的网络，不需要路由  
Genmask 网络掩码  
Flags   标记。一些可能的标记如下：  
　U Up表示此路由当前为启动状态  
　H Host，表示此网关为一主机  
　G Gateway，表示此网关为一路由器  
　R Reinstate Route，使用动态路由重新初始化的路由  
　D Dynamically,此路由是动态性地写入  
　M Modified，此路由是由路由守护程序或导向器动态修改  
　! 表示此路由当前为关闭状态  
Metric  路由距离，到达指定网络所需的中转数（linux 内核中没有使用）  
Ref 路由项引用次数（linux 内核中没有使用）   
Use 此路由项被路由软件查找的次数  
Iface   该路由表项对应的输出接口  
备注：  
route -n (-n 表示不解析名字,列出速度会比route 快)

## 3 种路由类型
**主机路由**  

主机路由是路由选择表中指向单个IP地址或主机名的路由记录。主机路由的Flags字段为H。例如，在下面的示例中，本地主机通过IP地址192.168.1.1的路由器到达IP地址为10.0.0.10的主机。
```
Destination    Gateway       Genmask Flags     Metric    Ref    Use    Iface
-----------    -------     -------            -----     ------    ---    ---    -----
10.0.0.10     192.168.1.1    255.255.255.255   UH       0    0      0    eth0
```
**网络路由**  

网络路由是代表主机可以到达的网络。网络路由的Flags字段为N。例如，在下面的示例中，本地主机将发送到网络192.19.12.0的数据包转发到IP地址为192.168.1.1的路由器。
```
Destination    Gateway       Genmask Flags    Metric    Ref     Use    Iface
-----------    -------     -------         -----    -----   ---    ---    -----
192.19.12.0     192.168.1.1    255.255.255.0      UN      0       0     0    eth0
```
**默认路由**  

当主机不能在路由表中查找到目标主机的IP地址或网络路由时，数据包就被发送到默认路由（默认网关）上。默认路由的Flags字段为G。例如，在下面的示例中，默认路由是IP地址为192.168.1.1的路由器
```
Destination    Gateway       Genmask Flags     Metric    Ref    Use    Iface
-----------    -------     ------- -----      ------    ---    ---    -----
default       192.168.1.1     0.0.0.0    UG       0        0     0    eth0
```

## 配置静态路由
**route 命令**

设置和查看路由表都可以用 route 命令，设置内核路由表的命令格式是：
```
# route [-f] [-p] [Command [Destination] [mask Netmask] [Gateway] [metric Metric]] [if Interface]] 
```
Route命令是用于操作基于内核ip路由表，它的主要作用是创建一个静态路由让指定一个主机或者一个网络通过一个网络接口，如eth0。当使用"add"或者"del"参数时，路由表被修改，如果没有参数，则显示路由表当前的内容。

其中：  
　-c 显示更多信息  
　-n 不解析名字  
　-v 显示详细的处理信息  
　-F 显示发送信息   
　-C 显示路由缓存   
　-f 清除所有网关入口的路由表。    
　-p 与 add 命令一起使用时使路由具有永久性。  
-  
　add:添加一条新路由。  
　del:删除一条路由。  
　-net:目标地址是一个网络。  
　-host:目标地址是一个主机。  
　netmask:当添加一个网络路由时，需要使用网络掩码。  
　gw:路由数据包通过网关。注意，你指定的网关必须能够达到。  
　metric：设置路由跳数。  
　Command 指定您想运行的命令 (Add/Change/Delete/Print)。   
　Destination 指定该路由的网络目标。   
　mask Netmask 指定与网络目标相关的网络掩码（也被称作子网掩码）。   
　Gateway 指定网络目标定义的地址集和子网掩码可以到达的前进或下一跃点 IP 地址。   
　metric Metric 为路由指定一个整数成本值标（从 1 至 9999），当在路由表(与转发的数据包目标地址最匹配)的多个路由中进行选择时可以使用。    
　if Interface 为可以访问目标的接口指定接口索引。若要获得一个接口列表和它们相应的接口索引，使用 route print 命令的显示功能。可以使用十进制或十六进制值进行接口索引。

**route 命令使用举例**

添加到主机的路由
```
# route add -host 192.168.1.2 dev eth0 
# route add -host 10.20.30.148 gw 10.20.30.40     #添加到10.20.30.148的网管
```
添加到网络的路由
```
# route add -net 10.20.30.0 netmask 255.255.255.0 eth0   #添加10.20.30.40的网络
# route add -net 10.20.30.0 netmask 255.255.255.0 gw 10.20.30.41 #添加10.20.30.48的网络
# route add -net 192.168.1.0/24 eth1
```
添加默认路由
```
# route add default gw 192.168.1.1
```
删除路由
```
# route del -host 192.168.1.2 dev eth0:0
# route del -host 10.20.30.148 gw 10.20.30.40
# route del -net 10.20.30.40 netmask 255.255.255.248 eth0
# route del -net 10.20.30.48 netmask 255.255.255.248 gw 10.20.30.41
# route del -net 192.168.1.0/24 eth1
# route del default gw 192.168.1.1
```

## End

## 参考资料

+ [Linux route命令详解](http://www.2cto.com/net/201503/386381.html)
+ [route 指令详解](http://blog.csdn.net/vevenlcf/article/details/48026965)