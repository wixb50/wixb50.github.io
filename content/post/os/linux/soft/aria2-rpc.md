+++
categories = ["linux","software"]
date = "2015-12-23T16:21:30+08:00"
description = "linux aria2下载工具，远程下载"
keywords = ["linux"]
title = "aria2 rpc"

+++

##目录
<!-- MarkdownTOC -->

- [](#前言null-link)
- [初步部署 Aria2 简易版](#初步部署-aria2-简易版)
- [进阶 Aria2](#进阶-aria2)
- [End](#end)
- [参考](#参考)

<!-- /MarkdownTOC -->

## [前言][null-link]
[null-link]: chrome://not-a-link
[Aria2](http://aria2.sourceforge.net/) 是一个轻量级多协议和多源命令行下载实用工具。它支持 HTTP / HTTPS, FTP, SFTP, bt 和 Metalink。通过内置 Aria2 可以操作 json - rpc 和 xml - rpc。对，Aria2 没有 GUI 图形界面，只有粗糙的命令行界面！但这也正是 Aria2 之轻快好省所在。

+ 官方下载链接：[http://sourceforge.net/projects/aria2/files/stable/](http://sourceforge.net/projects/aria2/files/stable/)

## 初步部署 Aria2 简易版

**1. 安装aria**
终端输入安装
```
sudo apt-get install aria2
```
**2.创建一个目录存放aria2配置终端输入**
```
sudo mkdir /etc/aria2    #新建文件夹
sudo touch /etc/aria2/aria2.session    #新建session文件
sudo chmod 777 /etc/aria2/aria2.session    #设置aria2.session可写
sudo vim /etc/aria2/aria2.conf    #创建配置文件
```
在aria2.conf添加已经代码 **根据实际情况修改：**

```
#＝＝＝＝＝＝＝＝＝文件保存目录自行修改
dir=/home/nishishui/aria2_download
disable-ipv6=true
#打开rpc的目的是为了给web管理端用
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
#rpc-listen-port=6800
continue=true
input-file=/etc/aria2/aria2.session
save-session=/etc/aria2/aria2.session
max-concurrent-downloads=5
```

**3.启动aria2**
```
sudo aria2c --conf-path=/etc/aria2/aria2.conf
```
如果没有提示错误，按ctrl+c停止运行命令，转为后台运行：
```
sudo aria2 --conf-path=/etc/aria2/aria2.conf -D
```
**4. 创建启动脚本**
```
vim ~/aria2/aria2_start.sh 
sudo aria2c --conf-path=/etc/aria2/aria2.conf -D  

vim ~/aria2/aria2_stop.sh 
#!/bin/bash
process_name=aria2c
kill_process(){
        process_id=`ps -eo pid,command|grep $process_name |grep -v "grep" |awk '{print $1}'`
        sudo kill $process_id
}
kill_process
```


**5. Web 前端控制**

如此这般，Aria2 就配置好了，那么问题就来了，这么一个看不见摸不着的软件怎么使用？别急，即使没有 GUI，Aria2 也还是有 Web 端控制界面的，目前比较知名的有 [Aria2 Web UI](https://github.com/ziahamza/webui-aria2) 和 [YAAW](https://github.com/binux/yaaw)。

+ Aria2 Web UI（推荐！）: [英文原版](http://ziahamza.github.io/webui-aria2/)
+ YAAW: [英文原版](http://binux.github.io/yaaw/demo/)  
**Tips：其他控制界面/扩展/脚本可能会需要填写 JSON-RPC Path，默认为: http://localhost:6800/jsonrpc**

简易版的 Aria2 至此就部署完毕，你可以在 Web 控制前段方便地添加下载链接/bt种子了。

## 进阶 Aria2

**1. 配置文件 aria2.conf 详解**

更多参数请参考官方说明文档：[http://aria2.sourceforge.net/manual/en/html/aria2c.html](http://aria2.sourceforge.net/manual/en/html/aria2c.html )

网友翻译的部分内容：  [http://sydi.org/posts/linux/aria2c-usage-sample-cns.html#fn.1](http://sydi.org/posts/linux/aria2c-usage-sample-cns.html#fn.1)

**2. 结合Docker使用**

可查看ziahamza大神配置好的：[Aria2 Web UI](https://github.com/ziahamza/webui-aria2)

**3. 搭配脚本/扩展**

迅雷离线（需会员账号）

+ Chrome Extension: [ThunderLixianAssistant](https://chrome.google.com/webstore/detail/thunderlixianassistant/eehlmkfpnagoieibahhcghphdbjcdmen)
+ UserScript: [ThunderLixianExporter](https://github.com/binux/ThunderLixianExporter)

旋风离线

+ UserScript: [XuanFengEx](https://greasyfork.org/zh-CN/scripts/354-xuanfengex)
+ UserScript: [LixianExporter](https://greasyfork.org/zh-CN/scripts/2398-lixianexporter)

百度网盘

+ Chrome Extension: [BaiduExporter](https://chrome.google.com/webstore/detail/baiduexporter/mjaenbjdjmgolhoafkohbhhbaiedbkno)
+ Firefox Addons: [BaiduExporter](https://github.com/acgotaku/BaiduExporter)
+ UserScript: [BaiduPanDownloadHelper](https://greasyfork.org/scripts/294-baidupandownloadhelper)

其他脚本

+ Chrome Extension: [添加到 aria2](https://chrome.google.com/webstore/detail/%E6%B7%BB%E5%8A%A0%E5%88%B0aria2/nimeojfecmndgolmlmjghjmbpdkhhogl) [Chrome Download Helper](http://git.oschina.net/yky/CDHelper)

End
-

参考
-
+ [https://gist.github.com/aa65535/5e956c4eb4f451ddec29](https://gist.github.com/aa65535/5e956c4eb4f451ddec29)
+ [在树莓派中使用aria2下载工具](http://www.aliencn.net/2015/08/02/Use_aria2_in_RaspberryPi/)
+ [ubuntu 配置 aria2](http://www.nixonli.com/linux/ubuntu/17040.html)