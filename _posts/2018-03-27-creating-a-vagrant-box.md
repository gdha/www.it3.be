---
layout: post
title: Create a Vagrant Box (of SLES11 SP4)

description: Create a Vagrant Box (of SLES11 SP4)

tags: [terminal, vagrant, SLES, linux, howto, it3 consultants]
author: gratien
---

<strong>Create a Vagrant Box (of SLES11 SP4)</strong>

For our Relax-and-Recover Automated Testing project we needed to provision a SLES11 SP4 box, but we could not find a proper working box on the Vagrant Cloud. Therefore, we decided to create a box ourselves. It seemed to be a process with many hurdles.

As a first step we downloaded the SLES 11 SP4 ISO image from [SuSe](https://www.suse.com/products/server/download/). However, before you can download the ISO image you need to create an account at SuSe. You will receive an email with a subscription key that is required to enable the repositories.

Secondly, spend sufficient time to install all executables and repositories required to update the VM. We tried to install as much as possible we require to setup a client and/or server VM. That makes the VM huge I am afraid, but when the update subscription expires no updates are possible anymore.

As a third step, before creating a vagrant box, we created a user 'vagrant' and made sure that the disk device was not defined with the by-id name (as the name changes when we import the VM via packer - but that is for later), and also remove the `/etc/udev/rules.d/90-persistent-network.rules` file as the MAC addresses will change also after the import (things we learned while trying it out).

So, halt the VM and export it [as described on the page VirtualBox Builder](https://www.packer.io/docs/builders/virtualbox-ovf.html). we saved the ovf and vmdf file in a `$HOME/packer` directory. we also require the [`packer`](https://www.packer.io/downloads.html) executable and save this as `/usr/local/bin/packer`.

The following step is the create a JSON template file describing the box we want to create.


    $ cat sles11sp4.json
    {
      "builders": [{
        "type": "virtualbox-ovf",
        "vm_name": "packer-sles11sp4",
        "source_path": "/home/gdha/packer/sles11sp4.ovf",
        "ssh_username": "{{user `ssh_name`}}",
        "ssh_password": "{{user `ssh_pass`}}",
        "ssh_port": 22,
        "ssh_wait_timeout": "10000s",
        "shutdown_command": "echo '{{user `ssh_name`}}'|sudo -S /sbin/halt -h -p"
      }],
      "post-processors": [{
        "type": "vagrant",
        "compression_level": "{{user `compression_level`}}",
        "output": "sles11sp4-virtualbox.box"
      }],
      "variables": {
        "compression_level": "6",
        "cpus": "1",
        "ssh_timeout": "60m",
        "ssh_name": "vagrant",
        "ssh_pass": "vagrant"
      }
    }
 
The next step is to create the box itself with packer, but to make our lives a bit easier we created a tiny for this task:

    $ cat mkbox.sh 
    vm_description='SLES 11 SP4 box meant for
    Relax-and-Recover Automated Testing
    https://gdha.github.io/rear-automated-testing/'
    
    vm_version='0.0.2'
    
    /usr/local/bin/packer build \
        -var "vm_description=${vm_description}" \
        -var "vm_version=${vm_version}"         \
        "sles11sp4.json"

Every time we need to update the version we just need to edit the `mkbox.sh` script and increase the vm_version variable.

    # ./mkbox.sh 
    virtualbox-ovf output will be in this color.
    
    ==> virtualbox-ovf: Downloading or copying Guest additions
        virtualbox-ovf: Downloading or copying: file:///usr/share/virtualbox/VBoxGuestAdditions.iso
    ==> virtualbox-ovf: Downloading or copying OVF/OVA
        virtualbox-ovf: Downloading or copying: file:///home/gdha/packer/sles11sp4.ovf
    ==> virtualbox-ovf: Importing VM: /home/gdha/packer/sles11sp4.ovf
    ==> virtualbox-ovf: Creating forwarded port mapping for communicator (SSH, WinRM, etc) (host port 3171)
    ==> virtualbox-ovf: Starting the virtual machine...
    ==> virtualbox-ovf: Waiting 10s for boot...
    ==> virtualbox-ovf: Typing the boot command...
    ==> virtualbox-ovf: Waiting for SSH to become available...
    ==> virtualbox-ovf: Connected to SSH!
    ==> virtualbox-ovf: Uploading VirtualBox version info (5.2.8)
    ==> virtualbox-ovf: Uploading VirtualBox guest additions ISO...
    ==> virtualbox-ovf: Gracefully halting virtual machine...
    ==> virtualbox-ovf: Preparing to export machine...
        virtualbox-ovf: Deleting forwarded port mapping for the communicator (SSH, WinRM, etc) (host port 3171)
    ==> virtualbox-ovf: Exporting virtual machine...
        virtualbox-ovf: Executing: export packer-sles11sp4 --output output-virtualbox-ovf/packer-sles11sp4.ovf
    ==> virtualbox-ovf: Deregistering and deleting imported VM...
    ==> virtualbox-ovf: Running post-processor: vagrant
    ==> virtualbox-ovf (vagrant): Creating Vagrant box for 'virtualbox' provider
        virtualbox-ovf (vagrant): Copying from artifact: output-virtualbox-ovf/packer-sles11sp4-disk002.vmdk
        virtualbox-ovf (vagrant): Copying from artifact: output-virtualbox-ovf/packer-sles11sp4.ovf
        virtualbox-ovf (vagrant): Renaming the OVF to box.ovf...
        virtualbox-ovf (vagrant): Compressing: Vagrantfile
        virtualbox-ovf (vagrant): Compressing: box.ovf
        virtualbox-ovf (vagrant): Compressing: metadata.json
        virtualbox-ovf (vagrant): Compressing: packer-sles11sp4-disk002.vmdk
    Build 'virtualbox-ovf' finished.
    
    ==> Builds finished. The artifacts of successful builds are:
    --> virtualbox-ovf: 'virtualbox' provider box: sles11sp4-virtualbox.box

As last step, we need to upload the box to [Vagrant Cloud](https://app.vagrantup.com/). You must have an account and then you can create a release for this box and start the upload. Once done, the box should be available via:

   Vagrant.configure("2") do |config|
     config.vm.box = "gdha/sles11sp4"
     config.vm.box_version = "0.0.2"
   end

