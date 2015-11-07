## Wixb's blog source file place

**说明**

在这里(develop)保存利用`hugo`生成的所有源代码和`markdown`文件(除了hugo动态生成的静态网页:保存在`master`分支下面)。

**develop**:所有markdown源文件，和主题theme文件，以及所有的配置文件;其中忽略了`public文件夹(master分支)`。

**master**:保存hugo生成的静态网站(develop的public文件夹)，用于展示在[http://wixb50.github.io/](http://wixb50.github.io/)主页上。

**运行提交**

1.直接使用运行脚本`./github-submit.sh`，将develop、master分支推送到github上面。  

2.直接使用运行脚本`./gitcafe-submit.sh`，将master分支强制推送到gitcafe的`gitcafe-pages`分支上面。

---
#### Support by Wixb.