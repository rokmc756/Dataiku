## WHat is this Dataiku Repository
The Dataiku Repository is Ansible Playbook to Deploy Dataiku DSS and PostgreSQL on Baremetal, Virtual Machines and Cloud Infrastructure.
The intention of this playbook is to deploy Dataiku DSS Cluster quickly in order to reproduce or simulate issues.

## What is Dataiku DSS?
Dataiku DSS is a data science platform of French origin. It stands out historically for its very packaged and integrated character.
This puts it within the reach of both experienced and novice data scientists. It allows you to create a model in a few clicks,
while industrializing the entire processing chain as a backdrop: collection, preparation of data, etc.

Dataiku DSS (for Dataiku Data Science Studio) is the name of Dataiku’s AI platform.

## Dataiku DSS Archiecture
![alt text](https://raw.githubusercontent.com/rokmc756/dataiku/main/roles/dss/images/nodes-definition.png)


## What are the features of Dataiku?
The Dataiku platform has around 90 functionalities that can be grouped into several major areas:

- Integration : The platform integrates with Hadoop, Spark, but also with cloud services AWS, Azure, Google Cloud. In total, the platform is equipped with more than 25 connectors.
- Plug-ins : A gallery of more than 100 plugins allows you to benefit from third-party applications in many areas: translation, NLG, weather, recommendation engine, import/export of data…
- Data preparation / data ops : A graphical console handles data preparation. Time series and geospatial data are supported. More than 90 prepackaged data transformers are available.
- Development : Dataiku supports Jupyter notebooks, Python, R, Scala, SQL, Hive, Pig, Impala languages. It supports PySpark, SparkR and SparkSQL.
- Machine Learning : The platform includes a machine learning automation engine (auto ML), a visualization console for training deep neural networks, support for Scikit-learn and XGBoost, etc.
- Collaboration : Dataiku integrates project management, chat, wiki, versioning (via Git)…
- Governance : The platform offers a model monitoring and auditing console, as well as a feature store.
- The MLOps : Dataiku handles model deployment. It supports Kubernetes architectures as well as Kubernetes as a Service offerings from AWS, Azure and Google Cloud.
- Data Visualization. A statistical visualization interface is complemented by 25 data visualization charts to identify relationships and insights within datasets.

## Supported Platform and OS
Virtual Machines\
Baremetal\
RHEL and CentOS 9 and Rocky Linux 9.x


## Prerequisite for ansible host
MacOS or Windows Linux Subsysetm or Many kind of Linux Distributions should have ansible as ansible host.\
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt as well as zypper


## Prepare ansible host to run this Ansible Playbook
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

## How to Configure Inventory and Variables
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

[fm]
rk9-node07 ansible_ssh_host=192.168.2.197

```

#### 2) Configure user/group, version and location to download in group_vars/all.yml
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

## How to deploy Dataiku DSS
### 1) Initialize Linux Host to Create User and SSH Keys and Exchange them among all Hosts
```
$ make hosts r=init s=all

```
### 2) Download Dataiku DSS Software Binaries into Ansible File Directory
```yaml
$ make download
```

### 3) Upload Dataiku DSS Software Binaries into all Hosts
```yaml
$ make dss r=upload s=bin
```

### 4) How to Install and Deploy Dataiku DSS
```yaml
$ make dss r=setup  s=pip
$ make dss r=deploy s=design
$ make dss r=deploy s=deployer
$ make dss r=deploy s=api
$ make dss r=deploy s=automation

$ make postgres r=install s=all
$ make dss r=deploy s=govern
$ make dss r=deploy s=fm
```

### 5) How to Uninstall and Destroy Dataiku DSS
```yaml
$ make dss r=destroy s=fm
$ make dss r=destroy s=govern
$ make postgres r=uninstall s=all

$ make dss r=destroy s=automation
$ make dss r=destroy s=api
$ make dss r=destroy s=deployer
$ make dss r=destroy s=design
$ make dss r=remove s=pip
```

## References
- https://doc.dataiku.com/dss/latest/installation/custom/initial-install.html#rhel-compatible-distributions
- https://doc.dataiku.com/dss/latest/installation/custom/deployer-node.html
- https://doc.dataiku.com/dss/latest/installation/custom/api-node.html ( It require license )
- https://doc.dataiku.com/dss/latest/installation/custom/automation-node.html
- https://doc.dataiku.com/dss/latest/installation/custom/govern-node.html
- https://doc.dataiku.com/dss/latest/governance/setup.html on Cloud Stack
- https://knowledge.dataiku.com/latest/admin-deploying/architecture/reference-fleet-manager.html
- https://medium.com/@shamimahmed_30466/on-premise-spark-as-a-service-with-dataiku-and-kubernetes-dc26a1af773e
- https://towardsdatascience.com/mlops-w-dataiku-dss-on-kubernetes-505ee9a2e15a
- https://github.com/sudsk/dataiku/blob/main/README.md
- https://github.com/tibfab/dss-at-k8s/blob/master/installation/installation-steps.sh

