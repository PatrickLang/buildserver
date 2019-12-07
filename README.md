
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


## In progress - using Vagrant and Windows Server 2019

### Getting ready

1. Clone https://github.com/StefanScherer/packer-windows
1. First, get the Windows Server 2019 trial ISO at: https://www.microsoft.com/evalcenter/evaluate-windows-server-2019, and save it in the iso/ folder
1. Build `windows_2019_docker.json` using one of the included scripts as an example. You may need to update the ISO filename or SHA as Microsoft updates it every few months.

**Temporary workaround - resize disk to >100 GB**

On a Hyper-V host

```powershell
vagrant halt
Resize-VHD '.\.vagrant\machines\winbuild\hyperv\Virtual Hard Disks\WindowsServer2019Docker.vhdx' -SizeBytes 120Gb
vagrant up
```

In the VM

```powershell
Resize-Partition -DriveLetter c -Size (Get-Partition -DriveLetter c | Get-PartitionSupportedSize).SizeMax
```

Then back on the host, resume with `vagrant provision`

### Using it

`vagrant provision` will install all the needed tools using the scripts included in this repo. Once it's provisioned, use `vagrant up` and `vagrant halt` to start & stop it cleanly. If it gets in a bad state `vagrant destroy` then `vagrant provision` again.