+++
categories = ["coreos","docker"]
date = "2015-12-15T18:10:38+08:00"
description = "在ESXi5上搭建CoreOS集群，用于构建docker集群"
keywords = ["coreos"]
title = "Docker集群系列之－ESXi5.5上搭建CoreOS集群-01"

+++

## 目录
<!-- MarkdownTOC -->

- [前言](#null-link)
- [前置条件](#前置条件)
- [安装CoreOS虚拟机](#安装coreos虚拟机)
    - [Choosing a Channel](#choosing-a-channel)
    - [Deploying with VMware vSphere Client 5.5](#deploying-with-vmware-vsphere-client-55)
- [Cloud-Config](#cloud-config)
    - [需要说明的`discovery`](#需要说明的discovery)
- [Logging in](#logging-in)
- [Adding New Machines](#adding-new-machines)
- [Conclusion](#conclusion)
- [一些有用的CoreOS命令](#一些有用的coreos命令)
- [参考资料](#参考资料)

<!-- /MarkdownTOC -->

## [前言][null-link]
[null-link]: chrome://not-a-link
因为大多数环境都是适配于大公司的云平台，但是也是有折中办法的。CoreOS是一个基于Linux 内核的轻量级操作系统，为了计算机集群的基础设施建设而生，专注于自动化，轻松部署，安全，可靠，规模化。作为一个操作系统，CoreOS 提供了在应用容器内部署应用所需要的基础功能环境以及一系列用于服务发现和配置共享的内建工具。而ESXi专为运行虚拟机、最大限度降低配置要求和简化部署而设计。所以我觉得使用ESXi当作IaaS架构，运行CoreOS集群，这样是可行的。话不多少，开始把。
## 前置条件
+ 安装ESXi机器一台：怎么装自己应该知道把，如果因为驱动原因还需要自己定制安装ISO，见Google。

## 安装CoreOS虚拟机
### Choosing a Channel
CoreOS is released into alpha, beta, and stable channels. Releases to each channel serve as a release-candidate for the next channel. For example, a bug-free alpha release is promoted bit-for-bit to the beta channel.  

The channel is selected based on the URLs below. Simply replace `stable` with `alpha` or `beta` in the URL. Select 1 of these to download the appropriate image. Read the release notes for specific features and bug fixes in each channel.
```
curl -LO http://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova
```
```
curl -LO http://beta.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova
```
```
curl -LO http://alpha.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova
```
### Deploying with VMware vSphere Client 5.5
Use the vSphere Client to deploy the VM as follows:  

1. in the menu, click “File > Deploy OVF Template…”
2. in the wizard, specify the location of the OVA downloaded earlier
3. name your VM
4. choose “thin provision” for the disk format if you want the disk to grow dynamically
5. choose your network settings
6. confirm the settings then click “Finish”

NOTE: Unselect “Power on after deployment” so you have a chance to edit VM settings before powering it up for the first time.

The last step uploads the files to your ESXi datastore and registers your VM. You can now tweak the VM settings, like memory and virtual cores. These instructions were tested to deploy to an ESXi 5.1 host.

Before powering it on, you will have to create a cloud-config.
## Cloud-Config
[Cloud-Config](https://coreos.com/os/docs/latest/cloud-config.html)是CoreOS内比较重要的概念，可以理解为一种配置CoreOS的方式：  

**Providing Cloud-Config with Config-Drive**  
Cloud-config can be specified by via [config-drive](https://github.com/coreos/coreos-cloudinit/blob/master/Documentation/config-drive.md) with the filesystem label `config-2`. This is commonly done through whatever interface allows for attaching CD-ROMs or new drives.

First create a user_data file using the the [cloud-config guide](https://coreos.com/os/docs/latest/cloud-config.html). 
```
#cloud-config
hostname: core-01  #替换成你的命名的主机名
write_files:
    - path: /etc/systemd/network/static.network
      permissions: 0644  #文件权限,无需改
      content: |
        [Match]
        Name=ens192  #网卡名称,如果你的是别的名称,请改回来

        [Network]
        Address=192.1.1.150/24  #网络配置,同时把下面的IP改掉
        Gateway=192.1.1.1
        DNS=10.11.248.114
        DNS=8.8.4.4
coreos:
    etcd2:
        # generate a new token for each unique cluster from https://discovery.etcd.io/new?size=3
        discovery: https://discovery.etcd.io/<token>  #这里在后面详细讲
        # multi-region and multi-cloud deployments need to use 192.1.1.150
        advertise-client-urls: http://192.1.1.150:2379
        initial-advertise-peer-urls: http://192.1.1.150:2380
        # listen on both the official ports and the legacy ports
        # legacy ports can be omitted if your application doesn't depend on them
        listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
        listen-peer-urls: http://192.1.1.150:2380,http://192.1.1.150:7001
    fleet:
        public-ip: 192.1.1.150
        metadata: region=europe #metadata,可自定义
    flannel:
        etcd_prefix: /coreos.com/network2
    locksmith:
        endpoint: 192.1.1.150:4001
    update:
        reboot-strategy: etcd-lock
        group: stable
    units:
        - name: etcd2.service #注意是etcd2,第二版哟
          command: start
        - name: fleet.service
          command: start
users:
  - name: "core"  #改成你的用户名,可不是core
    groups:
      - "sudo"
      - "docker"
    ssh-authorized-keys:   
      - ssh-rsa 替换成你的公钥... 
manage_etc_hosts: localhost
```
Cloud-Config配置信息验证地址[https://coreos.com/validate/](https://coreos.com/validate/).

### 需要说明的`discovery`
　　因为要搭建集群，需要用到服务发现，配置集群的服务发现有两种方式：一种是Static方式，第二种就是Discovery方式了。其中个人不推荐第一种方式，因为每加入一台主机就需要手动配置etcd节点，非常不方便。  
　　第二种Discovery方式是使用远程的服务器辅助服务发现，只需要配置好Discovery的URl就可以自动把新加入的服务器加入集群。其中iscovery服务器可以使用官网提供的，也可以自己搭建(我还没搭建过，这里不介绍了)。
```
curl https://discovery.etcd.io/new?size=3  #控制台或者浏览器执行即可,推荐使用size=1,见下面说明
```
其中有一个`size`参数，讲一下我遇到的问题：  

+ 没有使用size参数结果老是启动不了;  
+ 使用了`size=3`，结果启动主节点，主节点的etcd2就一直等待从节点加入，结果等我去加入它的时候，已经超时了;
+ 使用`size=1`，没有什么要等待了，过一会就自动启动成功了`fleetctl list-machines`也能正常显示。

所以，我可能不知道网上哪些一下子启动3个节点是怎么做到的，还是有待学习。但是这里我也有自己的解决方法，就是使用`size=1`先运行出来一个只有一台主机的集群，果然可以运行。然后使用主节点的`<Token>`再去构建其他节点的`Cloud-config`，然后运行，结果果然它自己就能加入到第一个节点里面。

这里我可能投机取巧了点，但是能运行，也能达到效果就行，哈哈，希望不会有什么bug。

Finally, to create a cloud-config ISO, use the following commands using the user_data file we just created:
```
#wrap up a config named user_data in a config drive image:
mkdir -p /tmp/new-drive/openstack/latest
cp user_data /tmp/new-drive/openstack/latest/user_data
mkisofs -R -V config-2 -o configdrive-01.iso /tmp/new-drive
rm -r /tmp/new-drive

#transform iso file to datastore
#scp configdrive-01.iso root@192.1.1.132:/vmfs/volumes/datastore1/ISO
```
Note that the config-drive standard was originally an OpenStack feature, which is why you’ll see strings containing openstack. This filepath needs to be retained, although CoreOS supports config-drive on all platforms.

Note: The $private_ipv4 and $public_ipv4 substitution variables referenced in other documents are not supported on VMware. You can replace all these variables by the (static) IP of the CoreOS server you’re setting up. For example:
```
coreos:
  etcd2:
    # generate a new token for each unique cluster from https://discovery.etcd.io/new?size=3
    discovery: https://discovery.etcd.io/<token>
    # multi-region and multi-cloud deployments need to use $public_ipv4
    advertise-client-urls: http://$public_ipv4:2379
    initial-advertise-peer-urls: http://$private_ipv4:2380
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380,http://$private_ipv4:7001
```
becomes
```
coreos:
  etcd2:
    # generate a new token for each unique cluster from https://discovery.etcd.io/new?size=3
    discovery: https://discovery.etcd.io/<token>
    # multi-region and multi-cloud deployments need to use $public_ipv4
    advertise-client-urls: http://192.168.0.100:2379
    initial-advertise-peer-urls: http://192.168.0.100:2380
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://192.168.0.100:2380,http://192.168.0.100:7001
```
Attach the ISO to the VM as follows:

1. edit the settings of the CoreOS VM
2. in the dialog, select “CD/DVD drive 1” in the device list
3. select “connect at power on”
4. choose “datastore ISO file” as the device type
5. browse the datastore and select your config drive ISO
6. confirm the changes and click “OK”

NOTE:如果发现ip不对，可查看配置文件，Maybe重启一下也可以解决哟。

## Logging in
可以查看ESXi控制台CoreOS的IP，但是静态的自己已经知道了。  

Now you can login using your SSH key or password set in your cloud-config，可以登录就没必要折腾下步了。
```
ssh core@192.1.1.150
```

Alternatively, if the cloud-config fails to apply you can append coreos.autologin to the kernel parameters on boot, the console won’t prompt for a password. This is handy for debugging.

When GNU GRUB appears at boot, make sure CoreOS default is selected and press e, then add coreos.autologin after `$linux_append`

Before

![之前的启动界面](http://www.holysh1t.net/vgwtest/coreosstuff/grubautologin1.png)

After

![之前的启动界面](http://www.holysh1t.net/vgwtest/coreosstuff/grubautologin2.png)

When coreos.autologin is added, press `CTRL+X` to boot CoreOS with these parameters. Note that the next time autologin will be disabled again as these kernel parameters aren’t persistent.

You can now manually apply the cloud-config by using the following command in the console of CoreOS:
```
sudo /usr/bin/coreos-cloudinit --from-file /media/configdrive/openstack/latest/user_data
```
## Adding New Machines
按照前面所说的，如果需要把其他CoreOS加入集群，只需要把Discovery URL改成原来集群地址即可自动加入了，是不是很方便呀。

If you forgot which discovery URL you used, you may look it up on one of the members of the cluster. Use the following grep command on one of your existing machines:
```
grep DISCOVERY /run/systemd/system/etcd2.service.d/20-cloudinit.conf
```
You will see a line the contains the original discovery URL, like the following:
```
Environment="ETCD_DISCOVERY=https://discovery.etcd.io/575302f03f4fb2db82e81ea2abca55e9"
```
## Conclusion
Your basic CoreOS cluster is set up, and now you can move on to testing with it!

## 一些有用的CoreOS命令
查看当前集群所有machines
```
fleetctl list-machines
```
查看服务运行状态
```
systemctl -l status etcd2  #其中-l参数可选
systemctl -l status fleet
systemctl -l status docker
```
查看服务的运行日志
```
journalctl -u etcd2
```

## 参考资料
+ [CoreOS官网](https://coreos.com/)
+ [在 ESXi5 上部署 CoreOS 集群解决方案](http://www.ibm.com/developerworks/cn/cloud/library/1505_gutb_coreos/)
+ [平台云基石-CoreOS之集群篇](http://www.tuicool.com/m/articles/zyaAbyJ)
+ [Download](http://stable.release.core-os.net/)
+ [Running CoreOS on VMware ESXi 5.1](http://www.holysh1t.net/vgwtest/coreosstuff/coreos-vmware-esxi-setup.html)