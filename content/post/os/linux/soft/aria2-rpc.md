+++
categories = ["linux","software"]
date = "2015-12-23T16:21:30+08:00"
description = "linux aria2下载工具，远程下载"
keywords = ["linux"]
title = "aria2 rpc"

+++

##目录
<!-- MarkdownTOC -->

- [前言](#null-link)
- [初步部署 Aria2 简易版](#初步部署-aria2-简易版)
- [进阶 Aria2](#进阶-aria2)
- [End](#end)

<!-- /MarkdownTOC -->

## [前言][null-link]
[null-link]: chrome://not-a-link
[Aria2](http://aria2.sourceforge.net/) 是一个轻量级多协议和多源命令行下载实用工具。它支持 HTTP / HTTPS, FTP, SFTP, bt 和 Metalink。通过内置 Aria2 可以操作 json - rpc 和 xml - rpc。对，Aria2 没有 GUI 图形界面，只有粗糙的命令行界面！但这也正是 Aria2 之轻快好省所在。

+ 官方下载链接：[http://sourceforge.net/projects/aria2/files/stable/](http://sourceforge.net/projects/aria2/files/stable/)

## 初步部署 Aria2 简易版

**1. 新建几个有关文件**

上面已经提供了下载链接，根据平台/系统位数（32bit/64bit）下载相应文件即可。（存放路径最好是英文/数字）然后在目录下以新建文本文档的方式新建几个文件，方便之后的使用。

+ Aria2.log（运行日志）
+ aria2.session（下载历史）
+ aria2.conf（配置文件）
+ HideRun.vbs （用来隐藏命令行窗口,仅限windows下）


而后用记事本修改配置文件 aria2.conf，**根据实际情况修改：**

```
dir=默认下载目录（例：D:\Inbox）
log=日志文件存放目录（例：D:\Aria2\Aria2.log）
input-file=记录下载历史文件目录（例：D:\Aria2\aria2.session）
save-session=存放下载历史文件目录（例：同上）
save-session-interval=60
force-save=true
log-level=error
  
  
# see --split option
max-concurrent-downloads=5
continue=true
max-overall-download-limit=0
max-overall-upload-limit=50K
max-upload-limit=20
  
# Http/FTP options
connect-timeout=120
lowest-speed-limit=10K
max-connection-per-server=10
max-file-not-found=2
min-split-size=1M
split=5
check-certificate=false
http-no-cache=true
  
# FTP Specific Options
  
# BT/PT Setting
bt-enable-lpd=true
#bt-max-peers=55
follow-torrent=true
enable-dht6=false
bt-seed-unverified
rpc-save-upload-metadata=true
bt-hash-check-seed
bt-remove-unselected-file
bt-request-peer-speed-limit=100K
seed-ratio=0.0
  
  
# Metalink Specific Options
  
# RPC Options
enable-rpc=true
pause=false
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-save-upload-metadata=true
rpc-secure=false
  
# Advanced Options
daemon=true
disable-ipv6=true
enable-mmap=true
file-allocation=falloc
max-download-result=120
#no-file-allocation-limit=32M
force-sequential=true
parameterized-uri=true
```

**Windows NOTE :** 而后修改 HideRun.vbs，将 Aria2c.exe 与配置文件 Aria2.conf 链接，并实现无命令行启动。那么日后打开 Aria2 就双击 HideRun.vbs 这个文件而不是双击 aria2c.exe。
```
CreateObject("WScript.Shell").Run "（程序所在目录 例：D:\Aria2\aria2c.exe） --conf-path=aria2.conf",0
```
**Linux NOTE :** 可使用配置文件直接运行，转到后台即可。
```
aria2c --conf-path=aria2.conf &  #其中&(后台运行)是可选项
```

**2. Web 前端控制**

如此这般，Aria2 就配置好了，如果要添加开机自启动将 HideRun.vbs 的快捷方式拖入启动文件夹建立计划任务就 OK 了。那么问题就来了，这么一个看不见摸不着的软件怎么使用？别急，即使没有 GUI，Aria2 也还是有 Web 端控制界面的，目前比较知名的有 [Aria2 Web UI](https://github.com/ziahamza/webui-aria2) 和 [YAAW](https://github.com/binux/yaaw)。

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
