# dart_gphoto2



//https://github.com/angryelectron/libgphoto2-jna/blob/master/src/com/angryelectron/gphoto2/GPhoto2.java
//https://github.com/angryelectron/libgphoto2-jna/blob/master/src/com/angryelectron/gphoto2/GPhoto2.java
//https://github.com/gphoto/libgphoto2/blob/master/examples/sample-tether.c

This package is a port of the java libgphoto-jna project available here: 
https://github.com/angryelectron/libgphoto2-jna/blob/master/src/com/angryelectron/gphoto2/GPhoto2.java


It is very much a work in progress at the moment. 



# Developing
When developing launch this project in a dev container which will allow for building and running in linux. (The only platform really libgphoto2 works on)  You can then launch your linux device with a camera attached and do the following: 

Running this on the devContainer will sync the dart_gphoto folder to the remote device

```
 cd /workspaces/flutter_gphoto
 rsync -av dart_gphoto2 rock@rockpi-4b:/tmp/
 ```


On the remote device you can run tests using a command such as the follownig; 
```
 cd /tmp/dart_gphoto2
 sudo dart test test/dart_gphoto2_test.dart -p vm --plain-name 'A group of tests capture and download'
```
This will run the test on the remote computer. 

# Building LibGPhoto2


# flutter_ffigen

This package provides a wrapper around the libgphoto2 library.  To 


## Building the wrappers

- Clone the libgphoto2 repository to the root of the project (this should already be in the .gitignore file) 
```git clone https://github.com/gphoto/libgphoto2.git ```
- Run the FFIGen to create the bindings file. 
``` dart run ffigen```

!! This does not run on windows (libgphoto2 only runs on linux at the moment anyway)


## Build LIBGPHOTO.SO

To build the libgphoto.so
```
#!/bin/bash 
cd /root/

autoreconf -is  # if using a git clone
./configure PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig${PKG_CONFIG_PATH+":${PKG_CONFIG_PATH}"}" --prefix="$HOME/.local"
make
l
```
This can't be run from insie the workspace as using git clone can cause issues as its on a windows PC and the line endings can cause an issue with the build scripts.

### Copy to folder
```
scp -r D:\development\flutter\camera_control\flutter_gphoto rock@rockpi-4b:/tmp/copy
````


## Device Provider

The device provider should provide a list of devices of a certain kind.  Planned providers are: 
- Camera.Test:  Provides different test cameras which will have different capabilityies and will return different shots based on the number of times you call the shutter.
- Libgphoto2:  Wrapper around the libgphoto2 library for use on linux
- Serial? 
- Bluetooth to camera control device
- Slider : Syrp (https://www.amazon.co.uk/Manfrotto-Control-Motorised-Photography-Accessories/dp/B07SFYJWJY)  
- WIFI Camera Control


### Device Provider Lifecycle


- GetDevices(): Returns the devices available at the moment. 
- AllowCreation: whether to allow creating a new one manually
- StoreDevice(device): 
- MaxCountOfDevices:  the maximum number of devices to allow

//https://docs.flutter.dev/install/manual


## Device

### Device Lifecycle

- Stream Connect(): 
- 


 /usr/bin/mkdir -p '/home/rock/.local/bin'
 /usr/bin/install -c gphoto2-config '/home/rock/.local/bin'
 /usr/bin/mkdir -p '/home/rock/.local/share/doc/libgphoto2'
 /usr/bin/install -c -m 644 AUTHORS COPYING NEWS ABOUT-NLS ChangeLog README.md RELEASE-HOWTO.md README.packaging '/home/rock/.local/share/doc/libgphoto2'
 /usr/bin/mkdir -p '/home/rock/.local/include'
 /usr/bin/mkdir -p '/home/rock/.local/include/gphoto2'
 /usr/bin/install -c -m 644  gphoto2/gphoto2.h gphoto2/gphoto2-abilities-list.h gphoto2/gphoto2-camera.h gphoto2/gphoto2-context.h gphoto2/gphoto2-file.h gphoto2/gphoto2-filesys.h gphoto2/gphoto2-library.h gphoto2/gphoto2-list.h gphoto2/gphoto2-result.h gphoto2/gphoto2-setting.h gphoto2/gphoto2-version.h gphoto2/gphoto2-widget.h '/home/rock/.local/include/gphoto2'
 /usr/bin/mkdir -p '/home/rock/.local/lib/pkgconfig'
 /usr/bin/install -c -m 644 libgphoto2.pc '/home/rock/.local/lib/pkgconfig'
make[2]: Leaving directory '/home/rock/libgphoto2'
make[1]: Leaving directory '/home/rock/libgphoto2'
rock@rockpi-4b:~/libgphoto2$ libgphoto2
-bash: libgphoto2: command not found

 /usr/bin/mkdir -p '/home/rock/.local/share/doc/libgphoto2'
 /usr/bin/install -c -m 644 AUTHORS COPYING NEWS ABOUT-NLS ChangeLog README.md RELEASE-HOWTO.md README.packaging '/home/rock/.local/share/doc/libgphoto2'
 /usr/bin/mkdir -p '/home/rock/.local/include'
 /usr/bin/mkdir -p '/home/rock/.local/include/gphoto2'
 /usr/bin/install -c -m 644  gphoto2/gphoto2.h gphoto2/gphoto2-abilities-list.h gphoto2/gphoto2-camera.h gphoto2/gphoto2-context.h gphoto2/gphoto2-file.h gphoto2/gphoto2-filesys.h gphoto2/gphoto2-library.h gphoto2/gphoto2-list.h gphoto2/gphoto2-result.h gphoto2/gphoto2-setting.h gphoto2/gphoto2-version.h gphoto2/gphoto2-widget.h '/home/rock/.local/include/gphoto2'
 /usr/bin/mkdir -p '/home/rock/.local/lib/pkgconfig'
 /usr/bin/install -c -m 644 libgphoto2.pc '/home/rock/.local/lib/pkgconfig'
make[2]: Leaving directory '/home/rock/libgphoto2'
make[1]: Leaving directory '/home/rock/libgphoto2'
rock@rockpi-4b:~/libgphoto2$ libgphoto2