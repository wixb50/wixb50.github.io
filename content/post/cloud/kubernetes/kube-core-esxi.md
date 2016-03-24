+++
categories = ["coreos","kubernetes","docker"]
date = "2015-12-30T19:10:38+08:00"
description = "在ESXi5上搭建基于CoreOS的kubernetes集群"
keywords = ["docker"]
title = "Docker集群系列之－ESXi5.5上搭建基于CoreOS的kubernetes集群"

+++

# 目录

<!-- MarkdownTOC -->

- [Introduction](#introduction)
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


# Introduction
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
    fleetctl list-machines
    # and
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
+ The [source](https://gist.github.com/anonymous/553e448c0f8ce9a23120) of `master.yaml`
+ The [source](https://gist.github.com/anonymous/ce88bdc1f6368c0b1589) of `node.yaml`