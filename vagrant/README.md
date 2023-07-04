## Vagrant for creating VMs on Virtualbox

Vagrant is a tool for building and managing virtual machine environments in a single workflow. With an easy-to-use workflow and focus on automation

Here Vagrant can be used to create VMs for building cluster for a test.

### Vagrantfile

`Vagrantfile` is to describe the type of machine required for a project, and how to configure and provision these machines.

* VMs: `master` and `worker`
* Box: [`generic/ubuntu2204`](https://app.vagrantup.com/generic/boxes/ubuntu2204)
* VM provider: `virtualbox`
* Network (bridge)
  * `master`: 192.168.11.10 
  * `worker`: 192.168.11.11


### Usage

Navigate `~/homelab/vagrant/` directory which has the `Vagrantfile`.

```
cd ~/homelab/vagrant/
```

Start the VM.

```
vagrant up
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

### __References__

* [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)
* [Install Vagrant](https://developer.hashicorp.com/vagrant/downloads)
* [Multi-Machine](https://developer.hashicorp.com/vagrant/docs/multi-machine)
* [Public Networks](https://developer.hashicorp.com/vagrant/docs/networking/public_network)