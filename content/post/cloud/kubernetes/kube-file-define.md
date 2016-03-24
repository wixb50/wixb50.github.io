+++
categories = ["kubernetes","docker"]
date = "2016-03-13T15:10:38+08:00"
description = "Kubernetes关键对象定义文件详解"
keywords = ["docker"]
title = "Docker集群系列之－Kubernetes对象文件定义"

+++

## 说明
主要对kubernetes用户需要定义的Pod,RC和Service的配置文件进行详细说明。

## Pod定义文件详解
Pod定义文件模板(yaml格式)如下：
```
apiVersion: v1      # required
kind: Pod           # required
metadata:           # required
  name: string      # required
  namespace: string      # required
  labels:
    - name: string
  annotations:
    - name: string
spec:       # required
  containers:       # required
    - name: string      # required
      image: string     # required
      imagePullPolicy: [Always | Never | IfNotPresent]
      command: [string]
      workingDir: string
      volumeMounts:
        - name: string
          mountPath: string
          readOnly: boolean
      ports:
        - name: string
          containerPort: int
          hostPort: int
          protocol: string
      env:
        - name: string
          value: string
      resources:
        limits:
         cpu: string
         memory: string
  volumes:
    - name: string
      # Either emptyDir for an empty directory
      emptyDir: {}
      # Or hostPath for a pre-existing directory on the host
      hostPath:
        path: string
  restartPolicy: [Always | Never | OnFailure]
  dnsPlicy: [Default | ClusterFirst]        # required
  nodeSelector: object
  imagePullSercret: object
```
对Pod各属性详细说明表如下：

| 属 性 名 称 | 取 值 类 型 | 是 否 必 选  | 取 值 说明 |
| :-------------: | :-------------: | :-----: | :----: |
| version | String | Required | v1 |
| kind | String | Required | Pod |
| metadata | Object | Required | 元数据 |
| ... | ... | ... | ... |

## RC定义文件详解
RC(ReplicationController)定义文件模板(yaml格式)如下：
```
apiVersion: v1      # required
kind: ReplicationController           # required
metadata:           # required
  name: string      # required
  namespace: string      # required
  labels:
    - name: string
  annotations:
    - name: string
spec:       # required
  replicas: number      # required
  selector: []      # required
  template: object      # required
```

## Service定义文件详解
Service定义文件模板(yaml格式)如下：
```
apiVersion: v1      # required
kind: Service           # required
metadata:           # required
  name: string      # required
  namespace: string      # required
  labels:
    - name: string
  annotations:
    - name: string
spec:       # required
  selector: []      # required
  type: string      #required
  clusterIP: string
  sessionAffinity: string
  ports:
    - name: string
      port: int
      targetPort: int
      protocol: string
  status:
    loadBalancer:
      ingress:
        ip: string
        hostname: string
```
对Service各属性详细说明表如下：

| 属 性 名 称 | 取 值 类 型 | 是 否 必 选  | 取 值 说明 |
| :-------------: | :-------------: | :-----: | :----: |
| version | String | Required | v1 |
| kind | String | Required | Pod |
| metadata | Object | Required | 元数据 |
| metadata.name | String | Required | Service名称，符合RFC1035规范 |
| metadata.namespace | String | Required | 命名空间，不指定时系统使用名为"default"的命名空间 |
| metadata.labels[] | list |  | 自定义标签属性列表 |
| metadata.annotation[] | list |  | 自定义注解属性列表 |
| spec | object | Required | 详细描述 |
| spec.selector[] | list | Required | Label Selector配置，将选择具有指定label标签的Pod作为管理范围 |
| spec.type | string | Required | Service类型，指定Service访问方式，默认为ClusterIP。<br>ClusterIP: 虚拟的服务IP地址，该地址用户kubernetes集群内部Pod访问，在Node上kube-proxy通过设置的iptables规则进行转发;<br>NodePort: 使用宿主机的端口，使能够访问各Node的外部客户端通过Node的IP地址和端口号就能访问服务;<br>LoadBalancer: 使用外接负载均衡器完成到服务的负载分发，需要在spec.status.loadBalancer字段指定外部负载均衡器的IP地址，并同时定义nodePort和clusterIP. |
| spec.clusterIP | String |  | 虚拟服务IP地址，当type=ClusterIP时，如果不指定，则系统自动分配;当type=LoadBalancer时，则需要指定。 |
| spec.sessionAffinity | String |  | 是否支持Session，可选值为ClientIP，默认为空。<br>ClientIP: 表示同一个客户端(根据客户端的IP地址决定)的访问请求都转发到同一个后端Pod。 |
| spec.ports[] | list |  | Service需要暴露的端口号列表 |
| spec.ports[].name | String |  | 端口名称 |
| spec.ports[].port | int |  | 服务监听的端口号 |
| spec.ports[].targetPort | int |  | 需要转发到后端Pod的端口号 |
| spec.ports[].protocol | int |  | 端口协议，支持TCP和UDP，默认TCP |
| status | object |  | 当spec.type=LoadBalancer时，设置外部负载均衡器的地址 |
| status.loadBalancer | object |  | 外部负载均衡器 |
| status.loadBalancer.ingress | object |  | 外部负载均衡器 |
| status.loadBalancer.ingress.ip | string |  | 外部负载均衡器的IP地址 |
| status.loadBalancer.ingress.hostname | string |  | 外部负载均衡器的主机名 |

## 附录
根据yaml创建：
```
$ kubectl create -f <filename.yaml> [--validate[=true]]
```
根据yaml删除：
```
$ kubectl delete -f <filename.yaml>
```