
This branch contains files needed to build a windows compilation environment for the Mixxx project.

* [Setup the build environment](http://www.mixxx.org/wiki/doku.php/compiling_on_windows)
* [Build Installer package](http://www.mixxx.org/wiki/doku.php/build_windows_installer)



## In progress - using premade Windows 10 dev VM

I'm trying to get this premade VHD to work for building Mixxx: https://developer.microsoft.com/en-us/windows/downloads/virtual-machines . It works for a few months with no product key, so it may be a good option for simple builds & testing.

Work needed:

- [ ] Script to add missing prerequisites
  - [ ] Python 2.7, pip, scons
  - [ ] Perl
  - [ ] CMake for > 2.3
- [ ] Add VS2017 C++ tools to VS2019 install, and update scripts to accept them
- [ ] Test updating Windows SDK version to 18362 to avoid extra downloads. Verify the build still works on Windows 7. If 7 and the latest 10 are ok, we're probably good to go


## In progress - using Vagrant to build in a Windows Server 2019 VM

### Software needed

This has been tested with Windows 10 using Hyper-V, and Linux using libvirt+qemu+kvm.

- [Packer](https://www.packer.io)
- [Vagrant](https://www.vagrantup.com)
  - If you want to use KVM, be sure to install the [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt#installation) plugin.

### Getting ready 

1. Clone https://github.com/StefanScherer/packer-windows
1. First, get the Windows Server 2019 trial ISO at: https://www.microsoft.com/evalcenter/evaluate-windows-server-2019, and save it in the iso/ folder
1. Build `windows_2019.json` using one of the included scripts as an example. You may need to update the ISO filename or SHA as Microsoft updates it every few months. Be sure to override the vars `iso_url` and `disk_size`
  - Example with QEmu+KVM: `packer build --only=qemu --var disk_size=140000 --var iso_url=./iso/17763.379.190312-0539.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso --var virtio_win_iso=./iso/virtio-win.iso windows_2019.json`
      - Be sure to use the latest virtio-win.iso from [fedora](https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html) since it's compatible with the latest Windows releases.
  - Example with Hyper-V: `packer.exe build --only=hyperv-iso --var disk_size=140000 --var iso_url=./iso/17763.379.190312-0539.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso windows_2019.json`
1. Import the box
  - libvirt: `vagrant box add --provider=libvirt --name=WindowsServer2019 ./windows_2019_libvirt.box`
  - Hyper-V: **TODO**


> Note: If you built with a disk that's <140 GB, then installing VS2019 tools may fail during `vagrant up`. Here's a workaround:
>
> On a Hyper-V host
```powershell
vagrant halt
Resize-VHD '.\.vagrant\machines\winbuild\hyperv\Virtual Hard Disks\WindowsServer2019.vhdx' -SizeBytes 160Gb
vagrant up
```
>
>In the VM:

```powershell
Resize-Partition -DriveLetter c -Size (Get-Partition -DriveLetter c | Get-PartitionSupportedSize).SizeMax
```
>

Then back on the host, resume with `vagrant provision`

### Using it

`vagrant provision` will install all the needed tools using the scripts included in this repo. Once it's provisioned, use `vagrant up` and `vagrant halt` to start & stop it cleanly. If it gets in a bad state `vagrant destroy` then `vagrant provision` again.