+++
categories = ["kubernetes","kube-ui"]
date = "2015-01-02T15:38:38+08:00"
description = "kubernetes 安装配置 kube-ui"
keywords = ["kubernetes"]
title = "kubernetes 安装配置 kube-ui"

+++

1. 下载gcr.io/google_containers/pause镜像并导入

    部署kubernetes应用需要一个基础images，谷歌的镜像地址被墙了，无法pull拉取镜像，解决方法：

        docker pull docker.io/kubernetes/pause
        docker tag docker.io/kubernetes/pause gcr.io/google_containers/pause:0.8.0
        docker rmi docker.io/kubernetes/pause

2. 下载kube-ui镜像并导入

    谷歌的镜像地址被墙了，无法pull拉取镜像，可从第三方国内云拉取：[时速云(google_containers/kube-ui)](https://hub.tenxcloud.com/repos/google_containers/kube-ui),拉取后更改名称：

        docker pull index.tenxcloud.com/google_containers/kube-ui:v4
        docker tag index.tenxcloud.com/google_containers/kube-ui:v4 gcr.io/google_containers/kube-ui:v4
        docker rmi index.tenxcloud.com/google_containers/kube-ui:v4

3. 创建kube-system namespace  

    创建kube-system.yaml，内容如下：

        apiVersion: v1
        kind: Namespace
        metadata:
          name: kube-system
    运行以下命令创建namespace

        # kubectl create -f kube-system.yaml
        # kubectl get namespace
        NAME          LABELS    STATUS
        default       <none>    Active
        kube-system   <none>    Active

4. 创建rc

    创建kube-ui-rc.yaml 文件，并写入一下内容

        apiVersion: v1
        kind: ReplicationController
        metadata:
          name: kube-ui-v4
          namespace: kube-system
          labels:
            k8s-app: kube-ui
            version: v4
            kubernetes.io/cluster-service: "true"
        spec:
          replicas: 1
          selector:
            k8s-app: kube-ui
            version: v4
          template:
            metadata:
              labels:
                k8s-app: kube-ui
                version: v4
                kubernetes.io/cluster-service: "true"
            spec:
              containers:
              - name: kube-ui
                image: gcr.io/google_containers/kube-ui:v4
                resources:
                  limits:
                    cpu: 100m
                    memory: 50Mi
                ports:
                - containerPort: 8080
                livenessProbe:
                  httpGet:
                    path: /
                    port: 8080
                  initialDelaySeconds: 30
                  timeoutSeconds: 5

      运行一下命令创建rc,并查看

        # kubectl create -f kube-ui-rc.yaml

        #kubectl get rc --all-namespaces
        NAMESPACE     CONTROLLER   CONTAINER(S)   IMAGE(S)                              SELECTOR                     REPLICAS
        kube-system   kube-ui-v3   kube-ui        gcr.io/google_containers/kube-ui:v4   k8s-app=kube-ui,version=v4   1

5. 创建service

    创建 kube-ui-svc.yaml 文件，并写入以下内容

        apiVersion: v1
        kind: Service
        metadata:
          name: kube-ui
          namespace: kube-system
          labels:
            k8s-app: kube-ui
            kubernetes.io/cluster-service: "true"
            kubernetes.io/name: "KubeUI"
        spec:
          selector:
            k8s-app: kube-ui
          ports:
          - port: 80
            targetPort: 8080

    运行以下命令创建service，并查看service 和 pods

        # kubectl create -f kube-ui-svc.yaml
        # kubectl get rc,pods --all-namespaces
        NAMESPACE     CONTROLLER   CONTAINER(S)   IMAGE(S)                              SELECTOR                     REPLICAS
        kube-system   kube-ui-v3   kube-ui        gcr.io/google_containers/kube-ui:v4   k8s-app=kube-ui,version=v4   1
        NAMESPACE     NAME               READY     STATUS    RESTARTS   AGE
        kube-system   kube-ui-v3-0zyjp   1/1       Running   0          21h

6. master配置[flannel](https://github.com/coreos/flannel)网络，与minion连通
    
    其中需要借助flannel，打通master和minion的网络，要确保自己集群已经配置好flannel。

7. 访问kube-ui

    访问 http://master_ip:8080/ui/ 会自动跳转 http://kube-ui:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui/#/dashboard/ 即可访问kube-ui的dashboard 页面，如下图所示：
    ![image](http://www.sunmite.com/wp-content/uploads/2015/11/1.jpg)
    可以查看minion的系统信息，pods，RC，services等信息。

8. 可能遇到的问题

    问题1，访问 http://master_ip:8080/ui/ ：

        Error: 'dial tcp 172.17.0.1:8080: no route to host'
        Trying to reach: 'http://172.17.0.1:8080/'
    解决：这是docker进程的问题，重启所有的minion，问题解决。
