## Install [Ansible](http://www.ansible.com/)

Mac OS:
`brew install ansible`

Ubuntu:
`apt-get install ansible`

## Create a jumpbox VM

_Name_: set a VM name, for example "jumpbox"
_Image_: select Ubuntu 14.04 image
_Networks_: Add two networks: private, for example with 192.168.1.0/24 CIDR and 192.168.1.2 jumpbox IP and a public network with a floating IP address

## Provision jumpbox VM

1. Run `ansible-galaxy install rvm_io.rvm1-ruby`
1. Run `cp hosts.example hosts`
1. Open `hosts` file and change x.x.x.x to an jumpbox's public IP
1. Run `ansible-playbook jumpbox-playbook.yml` to provision a VM

## Build a stemcell 

1. ssh to jumpbox: `ssh -i ~/.ssh/id_rsa ubuntu@x.x.x.x`
1. `cd ~/github/bosh`
1. `bundle install`
6. Run `~/bin/build-stemcell`


### Roles
List of roles:

1. `common` performs apt-get update and installs necessary packages.
2. `jumpbox` creates an environment to run BOSH CLI commands, CF CLI and bosh-init.
3. `binaries-builder` is used to build binaries for IBM Power BOSH and CF installations.
4. `stemcell-builder` installs everything that is needed to run stemcell builder of the BOSH project.

