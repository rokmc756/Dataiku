## Dataiku Data Science Platform

## Supported Platform and OS
Virtual Machines\
Baremetal\
RHEL and CentOS 9 and Rocky Linux 9.x\


## Prerequisite for ansible host
MacOS or Windows Linux Subsysetm or Many kind of Linux Distributions should have ansible as ansible host.\
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt as well as zypper\


## Prepare ansible host to run KubeFarmer
* MacOS
```
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

* Fedora/CentOS/RHEL, Ubuntu, OpenSUSE
```
$ yum install ansible
$ apt install ansible
$ zypper install ansible
```

## How to Configure ansible-hosts, role/dss/var/main.yml to deploy Dataiku DSS
#### 1) Configure hostname / ip addresses and username to run for ansible-hosts
```yaml
$ vi ansible-hosts-rk9-dss

[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3


[design]
rk9-node01 ansible_ssh_host=192.168.2.191

[deployer]
rk9-node02 ansible_ssh_host=192.168.2.192

[api]
rk9-node03 ansible_ssh_host=192.168.2.193

[automation]
rk9-node04 ansible_ssh_host=192.168.2.194

[govern]
rk9-node05 ansible_ssh_host=192.168.2.195

[postgres]
rk9-node06 ansible_ssh_host=192.168.2.196
```

#### 2) Configure hostname / ip addresses and username to run for ansible-hosts
```yaml
$ vi ansible-hosts-rk9-fm

[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[fm]
rk9-node07 ansible_ssh_host=192.168.2.197
```

#### 3) Configure user/group, version and location to download in group_vars/all.yml
```yaml
$ vi group_vars/all.yml
~~ snip
_dss:
  user: jomoon
  group: jomoon
  domain: "jtest.dataiku.com"
  major_version: "13"
  minor_version: "3"
  patch_version: "2"
  build_version: ""
  base_path: "/home/jomoon"
  bin_type: "tar.gz"
  download: false
  download_url: "https://cdn.downloads.dataiku.com/public/dss"
~~ snip

_postgres:
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
~~ snip
```

## Initialize Linux Host to Create User and SSH Keys and Exchange them among all Hosts
```
$ make hosts r=init s=all

```
## Download Dataiku DSS Software Binaries
```yaml
$ make dss r=upload s=bin
$ make dss r=download s=bin
$ make fm r=upload s=bin
$ make fm r=download s=bin
```

## How to Install and Deploy Dataiku DSS
```yaml
$ make dss r=setup  s=pip
$ make dss r=deploy s=design
$ make dss r=deploy s=deployer
$ make dss r=deploy s=api
$ make dss r=deploy s=automation

$ make postgres r=install s=all
$ make dss r=deploy s=govern

$ make fm r=setup  s=pip
$ make fm r=deploy s=govern

# For at once
$ make dss r=deploy s=all
```

## How to Uninstall and Destroy Dataiku DSS
```yaml
$ make fm r=destroy s=govern

$ make dss r=destroy s=govern
$ make dss r=destroy s=automation
$ make dss r=destroy s=api
$ make dss r=destroy s=deployer
$ make dss r=destroy s=design
$ make dss r=remove s=pip
$ make fm r=remove s=pip

$ make postgres r=install s=all

# For at once
$ make dss r=uninstall s=all
```

## References
### Dataiku
##### Design Node
- https://doc.dataiku.com/dss/latest/installation/custom/initial-install.html#rhel-compatible-distributions
##### Deployer Node
- https://doc.dataiku.com/dss/latest/installation/custom/deployer-node.html
##### API Node
- https://doc.dataiku.com/dss/latest/installation/custom/api-node.html ( It require license )
##### Automation Node
- https://doc.dataiku.com/dss/latest/installation/custom/automation-node.html
#### Goven Node
- https://doc.dataiku.com/dss/latest/installation/custom/govern-node.html
- https://doc.dataiku.com/dss/latest/governance/setup.html on Cloud Stack
#### FM Node
- https://knowledge.dataiku.com/latest/admin-deploying/architecture/reference-fleet-manager.html
### Others
- https://medium.com/@shamimahmed_30466/on-premise-spark-as-a-service-with-dataiku-and-kubernetes-dc26a1af773e
- https://towardsdatascience.com/mlops-w-dataiku-dss-on-kubernetes-505ee9a2e15a
- https://github.com/sudsk/dataiku/blob/main/README.md
- https://github.com/tibfab/dss-at-k8s/blob/master/installation/installation-steps.sh

