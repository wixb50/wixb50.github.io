+++
categories = ["golang"]
date = "2015-11-23T22:00:33+08:00"
description = "golang使用http client发起get和post请求示例"
keywords = [""]
title = "golang使用http client发起get和post请求"

+++

需要导入的包`"io/ioutil"`、`"net/http"`。

### get请求
get请求可以直接http.Get方法
```
func httpGet() {
    resp, err := http.Get("http://www.01happy.com/demo/accept.php?id=1")
    if err != nil {
        // handle error
    }

    defer resp.Body.Close()
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        // handle error
    }

    fmt.Println(string(body))
}
```

### post请求
***使用http.Post方式***
```
func httpPost() {
    resp, err := http.Post("http://www.01happy.com/demo/accept.php",
        "application/x-www-form-urlencoded",
        strings.NewReader("name=cjb"))
    if err != nil {
        fmt.Println(err)
    }

    defer resp.Body.Close()
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        // handle error
    }

    fmt.Println(string(body))
}
```
Tips：使用这个方法的话，第二个参数要设置成”application/x-www-form-urlencoded”，否则post参数无法传递。

***使用http.PostForm方法***
```
func httpPostForm() {
    resp, err := http.PostForm("http://www.01happy.com/demo/accept.php",
        url.Values{"key": {"Value"}, "id": {"123"}})

    if err != nil {
        // handle error
    }

    defer resp.Body.Close()
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        // handle error
    }

    fmt.Println(string(body))

}
```

### 复杂的请求
有时需要在请求的时候设置头参数、cookie之类的数据，就可以使用http.Do方法。
```
func httpDo() {
    client := &http.Client{}

    req, err := http.NewRequest("POST", "http://www.01happy.com/demo/accept.php", strings.NewReader("name=cjb"))
    if err != nil {
        // handle error
    }

    req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
    req.Header.Set("Cookie", "name=anny")

    resp, err := client.Do(req)

    defer resp.Body.Close()

    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        // handle error
    }

    fmt.Println(string(body))
}
```
同上面的post请求，必须要设定Content-Type为application/x-www-form-urlencoded，post参数才可正常传递.

### Head请求
发起head请求可以直接使用http client的head方法。