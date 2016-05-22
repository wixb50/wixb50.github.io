+++
categories = ["node","npm"]
date = "2016-05-14T12:51:33+08:00"
description = "npm命令个人笔记"
keywords = [""]
title = "npm命令个人笔记"

+++

# 修改npm源为淘宝npm源的三种方法

镜像地址：[淘宝 NPM 镜像](https://npm.taobao.org/)

## 通过config命令
```
npm config set registry https://registry.npm.taobao.org 
npm info underscore （如果上面配置正确这个命令会有字符串response）
```
## 命令行指定
```
npm --registry https://registry.npm.taobao.org info underscore 
```
## 编辑 ~/.npmrc 加入下面内容
```
registry = https://registry.npm.taobao.org
```

# tutorial
+ [npm模块管理器](http://javascript.ruanyifeng.com/nodejs/npm.html)