+++
categories = ["golang","golang-map"]
date = "2015-11-20T18:32:33+08:00"
description = "golang map sort排序实现"
keywords = [""]
title = "golang排序实现 sort接口实现"

+++

sort.Interface接口有三个方法,给自己的struct实现这三个方法,然后用将自己的结构体传给sort.Sort方法就排序完成.  

sort包也有几个常用的方法sort.Float64Slice sort.IntSlise sort.StringSlise

源码：
```
package main

import (
    "fmt"
    "sort"
)

type MapSorter []Item

type Item struct {
    Key string
    Val int64
}

func NewMapSorter(m map[string]int64) MapSorter {
    ms := make(MapSorter, 0, len(m))

    for k, v := range m {
        ms = append(ms, Item{k, v})
    }

    return ms
}

func (ms MapSorter) Len() int {
    return len(ms)
}

func (ms MapSorter) Less(i, j int) bool {
    return ms[i].Val < ms[j].Val // 按值排序
    //return ms[i].Key < ms[j].Key // 按键排序
}

func (ms MapSorter) Swap(i, j int) {
    ms[i], ms[j] = ms[j], ms[i]
}

func main(){
    m  := map[string]int64 {
        "e": 10,
        "a": 2,
        "d": 15,
        "c": 8,
        "f": 1,
        "b": 12,
    }

    ms := NewMapSorter(m)
    sort.Sort(ms)

    for _, item := range ms {
        fmt.Printf("%s:%d\n", item.Key, item.Val)
    }
}
```

完成.