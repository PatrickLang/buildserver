
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
