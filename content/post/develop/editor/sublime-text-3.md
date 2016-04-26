+++
categories = ["editor"]
date = "2015-11-03T11:21:17+08:00"
description = "收集一些自己常用的sublime插件集合和平常配置"
keywords = ["sublime"]
title = "sublime-text-3配置"

+++
## 目录
<!-- MarkdownTOC -->

- [Sublime Text 3编辑器插件](#sublime-text-3编辑器插件)
- [sublime text 3安装Package Control](#sublime-text-3安装package-control)
  - [简单安装方法](#简单安装方法)
  - [常规安装方法](#常规安装方法)
- [Sublime Text 2/3 输入法修复](#Ubuntu(Debian))
  - [使用方法](#使用方法)
- [卸载已安装的插件](#卸载已安装的插件)

<!-- /MarkdownTOC -->

## Sublime Text 3编辑器插件

1.HTML代码格式化插件`Tag`;

2.右键菜单增强插件`SideBarEnhancements`;

3.JS代码格式化插件`JSformat`;

4.Json格式化插件`Pretty Json`;

5.Go语言sublime编辑器`Gosublime`;
```
/*配置 Preferences -> Package Settings -> GoSublime -> Settings -> User*/
//添加
{"env": {"GOPATH": "/home/int/WorkSpace/Go", "GOROOT": "/usr/local/go"}}
```

6.markdown编辑和预览器：  

+ `MarkDown Edting`,markdown编辑插件;  
+ `omniMarkupPreview`,浏览器markdown预览导出.
+ `MarkdownTOC`,sublime的markdown目录自动生成器.

        //My配置文件:
        {
          "default_autolink": true, //目录添加自动链接
          "default_depth": 0, //默认无限目录
          "default_bracket": "round", //圆括号
          "default_autoanchor": false  //是否添加锚链接
        }

7.[Git](https://github.com/kemayo/sublime-text-git)插件,`ctrl+shift+p`使用命令

8.[Terminal](https://github.com/wbond/sublime_terminal),打开在当前文件所在的目录的终端,*改快捷键*

9.[Emmet](http://emmet.io/),html/css开发利器

10.[SublimeREPL](https://github.com/wuub/SublimeREPL)

11.[anaconda](https://github.com/DamnWidget/anaconda),python功能插件

12.[Javatar](https://javatar.readthedocs.org/),Java IDE插件

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

### 使用方法

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

+ 完成! 重新启动后控制台运行`subl`就可以在Sublime Text 2/3 中 使用Fcitx了! 注意: 皮肤可能需要自己选择 ^_^

+ 补充，[修正只能在终端中打开才能输入中文问题](https://github.com/lyfeyaj/sublime-text-imfix/issues/10)。就可以放心的玩耍了。

## 卸载已安装的插件

如果是通过package control安装的, 快捷键Cmd + shift + p打开面板搜索Package Control: Remove Package然后选择需要卸载的插件.
