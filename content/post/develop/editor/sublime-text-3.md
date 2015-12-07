+++
categories = ["editor"]
date = "2015-11-03T11:21:17+08:00"
description = "收集一些自己常用的sublime插件集合和平常配置"
keywords = ["sublime"]
title = "sublime-text-3配置"

+++

## sublime text 3编辑器插件

1.HTML代码格式化插件`Tag`;

2.右键菜单增强插件`SideBarEnhancements`;

3.JS代码格式化插件`JSformat`;

4.Json格式化插件`Pretty Json`;

5.Go语言sublime编辑器`Gosublime`;

6.markdown编辑和预览器：  

+ `MarkDown Edting`,markdown编辑插件;  
+ `omniMarkupPreview`,浏览器markdown预览导出.

## sublime text 3安装Package Control

### 简单安装方法

The simplest method of installation is through the Sublime Text console. The console is accessed via the`ctrl+` shortcut or the`View > Show Console`menu. Once open, paste the appropriate Python code for your version of Sublime Text into the console.
```
import urllib.request,os,hashlib; h = '2915d1851351e5ee549c20394736b442' + '8bc59f460fa1548d1514676163dafc88'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```
### 常规安装方法

If for some reason the console installation instructions do not work for you (such as having a proxy on your network), perform the following steps to manually install [Package Control](https://packagecontrol.io/Package%20Control.sublime-package):
```
1.Click the Preferences > Browse Packages… menu
2.Browse up a folder and then into the Installed Packages/ folder
3.Download ‘Package Control.sublime-package’ and copy it into the ‘Installed Packages/’ directory
4.Restart Sublime Text
```
结束  

## Sublime Text 2/3 输入法修复[Ubuntu(Debian)]

主要目的:

+ 安装 Sublime Text 3
+ 安装 Fcitx 输入法 + 皮肤
+ 修复 Sublime Text 2/3's 在 Ubuntu(Debian) 系统下的无法输入中文输入法的问题

### **注意**

+ **这个修复仅当在终端中使用 `subl .` 调用 Sublime Text 的时有效, 具体原因请看源代码[src/subl](https://github.com/lyfeyaj/sublime-text-imfix/blob/master/src/subl)**

### 使用方法 ###

+ 更新并升级系统为最新(较新的系统会解决很多可能出现的问题)

```bash
sudo apt-get update && sudo apt-get upgrade
```

+ 克隆项目到本地 : 

```bash
git clone https://github.com/lyfeyaj/sublime-text-imfix.git
```

+ 运行脚本 : 

```bash
cd sublime-text-imfix && ./sublime-imfix
```

+ 完成! 重新启动后就可以在Sublime Text 2/3 中 使用Fcitx了! 注意: 皮肤可能需要自己选择 ^_^

## 卸载已安装的插件

如果是通过package control安装的, 快捷键Cmd + shift + p打开面板搜索Package Control: Remove Package然后选择需要卸载的插件.
