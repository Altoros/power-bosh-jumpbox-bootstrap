## Install [Ansible](http://www.ansible.com/)

The recommended ansible version is 1.9.1 (install from [PyPI](https://pypi.python.org/pypi/ansible/1.9.1)). The earlier versions may come with [this bug](https://github.com/rvm/rvm1-ansible/issues/44).

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

### Roles

List of roles included in this project:

1. `gccgo` is used to install gccgo (version 5.1 by default), at this moment works only for power 8.
1. `common` performs apt-get update and installs all necessary packages, creates ~/github folder and installs direnv, installs gccgo and RVM with Ruby 2.1.4, installs BOSH with all necessary gems; all roles that are applied to hosts dependes on it; depends on `gccgo` and `rvm_io.rvm1-ruby`.
1. `jumpbox` creates an environment to run BOSH CLI commands, CF CLI and bosh-init; depends on `common`.
1. `binaries-builder` is used to build binaries for IBM Power BOSH and CF installations.
1. `stemcell-builder` installs everything that is needed to run stemcell builder of the BOSH project.


## Build a stemcell

You can create a separate instance just to build stemcell. You need to use __m1.large__ instance type to build stemcells.

To build a stemcell you'll need to use `stamcell-builder` host role. In order to do it update `hosts` file: uncomment section with `stemcell-builder` host and replace `x.x.x.x` with an instance you've created.

1. ssh to a stemcell builder instance: `ssh -i ~/.ssh/id_rsa ubuntu@x.x.x.x`
1. `cd ~/stemcell-builder`
1. `gem install bundler && bundle install`
1. Run `bundle exec ./bin/build-stemcell` (if any errors occurs, try to run commands from this script manually)


## Build MicroBOSH release

You can create a separate instance just to build stemcell.

To build a stemcell you'll need to use `binaries-builder` host role. In order to do it update `hosts` file: uncomment section with `binaries-builder` host and replace `x.x.x.x` with an instance you've created.

1. ssh to a stemcell builder instance: `ssh -i ~/.ssh/id_rsa ubuntu@x.x.x.x`.
1. `cd ~/binaries-builder`
1. `sudo ./bosh-release-binaries.sh` (if any errors occurs, try to run commands from this script manually)
1. `cd ~/bosh/release`
1. `bosh create release --with-tarball --force`, a path to the tarball you'll need to use will be in an output of this command.

## Build MicroBOSH release

To build a stemcell you'll need to use `binaries-builder` host role.

1. ssh to a stemcell builder instance: `ssh -i ~/.ssh/id_rsa ubuntu@x.x.x.x`.
1. `cd ~/binaries-builder`
1. `sudo ./cf-release-binaries.sh` (if any errors occurs, try to run commands from this script manually)
1. `cd ~/cf-release`
1. `bosh create release --with-tarball --force`, a path to the tarball you'll need to use will be in an output of this command. (if you'll get errors with network connection, just re-run this command to restart blobs upload).

## Build CF release

Almost the same process with MicroBOSH release. 

1. You need to install nokogiri 1.6.2.1 and eventmachine 1.0.7, 1.0.3 before. This is done because of strange bug in pre_packaging script ((see for details)[https://github.com/altoros/cf-release/blob/chkp-3-without-cc/packages/warden/pre_packaging#L21-L26]).
1. be sure `rvm` binary is available.

## Contacts

If you have any questions, write to Alexander Lomov (alexander.lomov@altoros.com) or Lev Berman (lev.berman@altoros.com).
