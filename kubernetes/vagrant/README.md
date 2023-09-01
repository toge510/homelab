## Vagrant for creating VMs on Virtualbox

Vagrant is a tool for building and managing virtual machine environments in a single workflow. With an easy-to-use workflow and focus on automation

Here Vagrant can be used to create VMs for building cluster and so on.

### Vagrantfile

`Vagrantfile` is to describe the type of machine required for a project, and how to configure and provision these machines.

* VMs: `master`, `worker`, `worker2`,`worker3`
* Box: [`generic/ubuntu2204`](https://app.vagrantup.com/generic/boxes/ubuntu2204) and `ubuntu/focal64`
* VM provider: `virtualbox`
* Network (bridge)
  * `master`: 192.168.11.10 
  * `worker`: 192.168.11.11
  * `worker2`: 192.168.11.12
  * `worker3`: 192.168.11.13
* Extra storage: 10GB per node


### Usage

Start the VM.

```
VAGRANT_EXPERIMENTAL=disks vagrant up
```

Check status of VMs.

```
vagrant status
```

Connect to the VM.

```
vagrant ssh <name>
```

### Commands

* `vagrant up`: Start the VM
* `vagrant ssh`: Connect to the VM
* `vagrant halt`: Shut down the VM
* `vagrant destroy`: Terminate the VM

### _References_

* [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)
* [Install Vagrant](https://developer.hashicorp.com/vagrant/downloads)
* [Multi-Machine](https://developer.hashicorp.com/vagrant/docs/multi-machine)
* [Public Networks](https://developer.hashicorp.com/vagrant/docs/networking/public_network)
* [VAGRANT_EXPERIMENTAL="disks"](https://developer.hashicorp.com/vagrant/docs/disks/virtualbox/usage)