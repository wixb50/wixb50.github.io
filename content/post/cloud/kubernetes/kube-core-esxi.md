+++
categories = ["coreos","kubernetes","docker"]
date = "2015-12-30T19:10:38+08:00"
description = "在ESXi5上搭建基于CoreOS的kubernetes集群"
keywords = ["docker"]
title = "Docker集群系列之－ESXi5.5上搭建基于CoreOS的kubernetes集群"

+++

# 目录

<!-- MarkdownTOC -->

- [VMware-coreos-multi-nodes-Kubernetes](#vmware-coreos-multi-nodes-kubernetes)
- [Prerequisites](#prerequisites)
- [CoreOS on VMware](#coreos-on-vmware)
- [Cloud-Config for master node](#cloud-config-for-master-node)
- [Cloud-Config for minion node](#cloud-config-for-minion-node)
- [Start the cluster](#start-the-cluster)
- [Check](#check)
- [Enjoy](#enjoy)
- [Reference](#reference)
- [Appendix](#appendix)

<!-- /MarkdownTOC -->


# VMware-coreos-multi-nodes-Kubernetes
Create a Kubernetes Cluster on VMware ESXi with CoreOS.

# Prerequisites
* VMware ESXi
  * (optional) a DRS cluster with VCenter for high-availability host.
* DHCP server
* A VMware datastore
* vSphere
* Attention: This requires at least CoreOS version 695.0.0, which includes etcd2.

# CoreOS on VMware
Based on official documentation : https://coreos.com/os/docs/latest/booting-on-vmware.html

Download the OVA, on your local computer :

    curl -LO http://alpha.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova

Import ova on VMware via the vSphere Client :

    in the menu, click "File > Deploy OVF Template..."
    in the wizard, specify the location of the OVA downloaded earlier
    name your VM
    confirm the settings then click "Finish"

Create a template via vSphere Client :

    right click on the VM and Template > Convert into template

Now you can create -at least- 2 servers based on this template, do this task but don't start it yet.

# Cloud-Config for master node
On the VMware datastore, create a directory and initialize config, example :

    mkdir -p <path to datastore>/cloud-config/master/openstack/latest/ 
    cd <path to datastore>/cloud-config/master/openstack/latest/
    wget https://raw.githubusercontent.com/kubernetes/kubernetes/master/docs/getting-started-guides/coreos/cloud-configs/master.yaml && mv master.yaml user_data

Don't forget to add your ssh_key :
```
vim user_data
users:
  - name: "core"
    groups:
      - "sudo"
      - "docker"
    ssh-authorized-keys:   
      - ssh-rsa AAAA...
```

Because the master need a static ip address,so you need to add the ip config to `user_data`.
```
vim user_data
write-files:
  [...]
  - path: /etc/systemd/network/static.network
    permissions: 0644
    content: |
      [Match]
      Name=ens192  # The network card

      [Network]
      Address=192.1.1.150/24
      Gateway=192.1.1.1
      DNS=10.11.248.114
      DNS=8.8.4.4
  [...]
```

If you can't get the files on VM,you need download files first,and deploy to your `File Server`first.And change the url in the `user_data` to your own file position.
```
Replace `https://github.com/kelseyhightower/setup-network-environment/releases/download/v1.0.0/setup-network-environment` To `<your file url>/setup-network-environment`
Replace `https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-apiserver` To `<your file url>/kube-apiserver`
Replace `https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-controller-manager` To `<your file url>/kube-controller-manager`
Replace `https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-scheduler` To `<your file url>/kube-scheduler`
```

Finaly, replace all "$private_ipv4" pattern with the ip of master node. The only way to perform this is to fix a DHCP lease with the MAC address of your master server. This MAC address can be get on vsphere : right click on VM, network adapter. Here, 10.0.0.1 is the master fixed ip address.

    sed -i 's|$private_ipv4|10.0.0.1|g' user_data

This is the limitation with coreOS and VMware : https://coreos.com/os/docs/latest/booting-on-vmware.html#cloud-config

Last step : create an iso :

    cd <path to datastore>/cloud-config/
    mkisofs -R -V config-2 -o config-master.iso master/
    
    
# Cloud-Config for minion node
On the VMware datastore, create a directory and initialize config, example :

    mkdir -p <path to datastore>/cloud-config/minion/openstack/latest/
    cd <path to datastore>/cloud-config/minion/openstack/latest/
    wget https://raw.githubusercontent.com/kubernetes/kubernetes/master/docs/getting-started-guides/coreos/cloud-configs/node.yaml && mv node.yaml user_data
  
 Don't forget to add your ssh_key :
 
```
vim user_data
users:
  - name: "core"
    groups:
      - "sudo"
      - "docker"
    ssh-authorized-keys:   
      - ssh-rsa AAAA...
```

If you can't get the files on VM,you need download files first,and deploy to your `File Server`first.And change the url in the `user_data` to your own file position.
```
Replace `https://github.com/kelseyhightower/setup-network-environment/releases/download/v1.0.0/setup-network-environment` To `<your file url>/setup-network-environment`
Replace `https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-proxy` To `<your file url>/kube-proxy`
Replace `https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kubelet` To `<your file url>/kubelet`
```

Finaly, replace all "<master-private-ip>" pattern with the ip of master node. (here 10.0.0.1)

    sed -i 's|<master-private-ip>|10.0.0.1|g' user_data

Last step : create an iso :

    cd <path to datastore>/cloud-config/
    mkisofs -R -V config-2 -o config-minion.iso minion/
    
# Start the cluster
On firt VM, mount the config-master.iso with VM properties (CD/DVD reader and "Datastore ISO file"), browse to "<path to datastore>/cloud-config/". Don't foget to set "Connect on Start up".

On second, and all other futher nodes  mount the config-minion.iso.

Start your servers.

**NOTE:**    
In order to build the `flanneld`,the VMs need to pull the images called `quay.io/coreos/flannel`.And if the VMs can't download it,you should get it first,then use the command to load the image.
```
docker load < flanneld-file.tar
```

Ensure all the `service` are running.  
**Master:**`docker`、`etcd2`、`fleet`、`flanneld`、`setup-network-environment`、`kube-apiserver`、`kube-controller-manager`、`kube-scheduler`.   
**Node:**`docker`、`etcd2`、`fleet`、`flanneld`、`setup-network-environment`、`kubelet`、`kube-proxy`.
```
#you may use these command to start/enable your service:
sudo systemctl daemon-reload
sudo systemctl start <service-name>  #start the service
sudo systemctl enable <service-name>  #Ensure service can boot from the start
sudo systemctl status <service-name>
```

# Check 
Check your cluster heatlh : http://10.0.0.1:8080/static/app/#/dashboard/

Check each server :

    ssh core@10.0.0.1
    journalctl -f
    
# Enjoy
You may download the kubernetes client tool:`kubectl`.Use it manage your cluster.

+ get all minion node info.
```
kubectl get nodes
```
+ get all Pods.
```
kubectl get pods
```
+ get all Replication Controllers.
```
kubectl get rc
```
+ get all Replication Services.
```
kubectl get svc
```
# Reference
+ [VMware-coreos-multi-nodes-Kubernetes](https://github.com/xavierbaude/VMware-coreos-multi-nodes-Kubernetes)
+ [kubernetes 0.18.1 安装 & 部署 & 初试](https://segmentfault.com/a/1190000002886795)
+ [Installing Kubernetes Cluster with 3 minions on CentOS 7 to manage pods and services](http://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services)
+ [如何在 CoreOS 集群上搭建 Kubernetes](http://dockerpool.com/article/1422538730)
+ [在CoreOS集群上搭建Kubernetes](http://qiankunli.github.io/2015/01/29/Kubernetes_installation.html)
+ [CoreOS集成Kubernetes核心组件Kubelet](http://dockone.io/article/604)
# Appendix
+ The source of `master.yaml`
```
#cloud-config

---
write-files:
  - path: /etc/conf.d/nfs
    permissions: '0644'
    content: |
      OPTS_RPC_MOUNTD=""
  - path: /opt/bin/wupiao
    permissions: '0755'
    content: |
      #!/bin/bash
      # [w]ait [u]ntil [p]ort [i]s [a]ctually [o]pen
      [ -n "$1" ] && \
        until curl -o /dev/null -sIf http://${1}; do \
          sleep 1 && echo .;
        done;
      exit $?

hostname: master
coreos:
  etcd2:
    name: master
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001
    initial-cluster-token: k8s_etcd
    listen-peer-urls: http://$private_ipv4:2380,http://$private_ipv4:7001
    initial-advertise-peer-urls: http://$private_ipv4:2380
    initial-cluster: master=http://$private_ipv4:2380
    initial-cluster-state: new
  fleet:
    metadata: "role=master"
  units:
    - name: generate-serviceaccount-key.service
      command: start
      content: |
        [Unit]
        Description=Generate service-account key file

        [Service]
        ExecStartPre=-/usr/bin/mkdir -p /opt/bin
        ExecStart=/bin/openssl genrsa -out /opt/bin/kube-serviceaccount.key 2048 2>/dev/null
        RemainAfterExit=yes
        Type=oneshot
    - name: setup-network-environment.service
      command: start
      content: |
        [Unit]
        Description=Setup Network Environment
        Documentation=https://github.com/kelseyhightower/setup-network-environment
        Requires=network-online.target
        After=network-online.target

        [Service]
        ExecStartPre=-/usr/bin/mkdir -p /opt/bin
        ExecStartPre=/usr/bin/curl -L -o /opt/bin/setup-network-environment -z /opt/bin/setup-network-environment https://github.com/kelseyhightower/setup-network-environment/releases/download/v1.0.0/setup-network-environment
        ExecStartPre=/usr/bin/chmod +x /opt/bin/setup-network-environment
        ExecStart=/opt/bin/setup-network-environment
        RemainAfterExit=yes
        Type=oneshot
    - name: fleet.service
      command: start
    - name: flanneld.service
      command: start
      drop-ins:
        - name: 50-network-config.conf
          content: |
            [Unit]
            Requires=etcd2.service
            [Service]
            ExecStartPre=/usr/bin/etcdctl set /coreos.com/network/config '{"Network":"10.244.0.0/16", "Backend": {"Type": "vxlan"}}'
    - name: docker.service
      command: start
    - name: kube-apiserver.service
      command: start
      content: |
        [Unit]
        Description=Kubernetes API Server
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        Requires=setup-network-environment.service etcd2.service generate-serviceaccount-key.service
        After=setup-network-environment.service etcd2.service generate-serviceaccount-key.service

        [Service]
        EnvironmentFile=/etc/network-environment
        ExecStartPre=-/usr/bin/mkdir -p /opt/bin
        ExecStartPre=/usr/bin/curl -L -o /opt/bin/kube-apiserver -z /opt/bin/kube-apiserver https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-apiserver
        ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-apiserver
        ExecStartPre=/opt/bin/wupiao 127.0.0.1:2379/v2/machines
        ExecStart=/opt/bin/kube-apiserver \
        --service-account-key-file=/opt/bin/kube-serviceaccount.key \
        --service-account-lookup=false \
        --admission-control=NamespaceLifecycle,NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota \
        --runtime-config=api/v1 \
        --allow-privileged=true \
        --insecure-bind-address=0.0.0.0 \
        --insecure-port=8080 \
        --kubelet-https=true \
        --secure-port=6443 \
        --service-cluster-ip-range=10.100.0.0/16 \
        --etcd-servers=http://127.0.0.1:2379 \
        --public-address-override=${DEFAULT_IPV4} \
        --logtostderr=true
        Restart=always
        RestartSec=10
    - name: kube-controller-manager.service
      command: start
      content: |
        [Unit]
        Description=Kubernetes Controller Manager
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        Requires=kube-apiserver.service
        After=kube-apiserver.service

        [Service]
        ExecStartPre=/usr/bin/curl -L -o /opt/bin/kube-controller-manager -z /opt/bin/kube-controller-manager https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-controller-manager
        ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-controller-manager
        ExecStart=/opt/bin/kube-controller-manager \
        --service-account-private-key-file=/opt/bin/kube-serviceaccount.key \
        --master=127.0.0.1:8080 \
        --logtostderr=true
        Restart=always
        RestartSec=10
    - name: kube-scheduler.service
      command: start
      content: |
        [Unit]
        Description=Kubernetes Scheduler
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        Requires=kube-apiserver.service
        After=kube-apiserver.service

        [Service]
        ExecStartPre=/usr/bin/curl -L -o /opt/bin/kube-scheduler -z /opt/bin/kube-scheduler https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-scheduler
        ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-scheduler
        ExecStart=/opt/bin/kube-scheduler --master=127.0.0.1:8080
        Restart=always
        RestartSec=10
  update:
    group: alpha
    reboot-strategy: off
```

+ The source of `node.yaml`
```
#cloud-config
write-files:
  - path: /opt/bin/wupiao
    permissions: '0755'
    content: |
      #!/bin/bash
      # [w]ait [u]ntil [p]ort [i]s [a]ctually [o]pen
      [ -n "$1" ] && [ -n "$2" ] && while ! curl --output /dev/null \
        --silent --head --fail \
        http://${1}:${2}; do sleep 1 && echo -n .; done;
      exit $?
coreos:
  etcd2:
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    advertise-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    initial-cluster: master=http://<master-private-ip>:2380
    proxy: on
  fleet:
    metadata: "role=node"
  units:
    - name: fleet.service
      command: start
    - name: flanneld.service
      command: start
    - name: docker.service
      command: start
    - name: setup-network-environment.service
      command: start
      content: |
        [Unit]
        Description=Setup Network Environment
        Documentation=https://github.com/kelseyhightower/setup-network-environment
        Requires=network-online.target
        After=network-online.target

        [Service]
        ExecStartPre=-/usr/bin/mkdir -p /opt/bin
        ExecStartPre=/usr/bin/curl -L -o /opt/bin/setup-network-environment -z /opt/bin/setup-network-environment https://github.com/kelseyhightower/setup-network-environment/releases/download/v1.0.0/setup-network-environment
        ExecStartPre=/usr/bin/chmod +x /opt/bin/setup-network-environment
        ExecStart=/opt/bin/setup-network-environment
        RemainAfterExit=yes
        Type=oneshot
    - name: kube-proxy.service
      command: start
      content: |
        [Unit]
        Description=Kubernetes Proxy
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        Requires=setup-network-environment.service
        After=setup-network-environment.service

        [Service]
        ExecStartPre=/usr/bin/curl -L -o /opt/bin/kube-proxy -z /opt/bin/kube-proxy https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kube-proxy
        ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-proxy
        # wait for kubernetes master to be up and ready
        ExecStartPre=/opt/bin/wupiao <master-private-ip> 8080
        ExecStart=/opt/bin/kube-proxy \
        --master=<master-private-ip>:8080 \
        --logtostderr=true
        Restart=always
        RestartSec=10
    - name: kube-kubelet.service
      command: start
      content: |
        [Unit]
        Description=Kubernetes Kubelet
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        Requires=setup-network-environment.service
        After=setup-network-environment.service

        [Service]
        EnvironmentFile=/etc/network-environment
        ExecStartPre=/usr/bin/curl -L -o /opt/bin/kubelet -z /opt/bin/kubelet https://storage.googleapis.com/kubernetes-release/release/v1.1.2/bin/linux/amd64/kubelet
        ExecStartPre=/usr/bin/chmod +x /opt/bin/kubelet
        # wait for kubernetes master to be up and ready
        ExecStartPre=/opt/bin/wupiao <master-private-ip> 8080
        ExecStart=/opt/bin/kubelet \
        --address=0.0.0.0 \
        --port=10250 \
        --hostname-override=${DEFAULT_IPV4} \
        --api-servers=<master-private-ip>:8080 \
        --allow-privileged=true \
        --logtostderr=true \
        --cadvisor-port=4194 \
        --healthz-bind-address=0.0.0.0 \
        --healthz-port=10248
        Restart=always
        RestartSec=10
  update:
    group: alpha
    reboot-strategy: off
```