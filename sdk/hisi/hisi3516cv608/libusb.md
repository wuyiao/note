## 
    git clone https://github.com/libusb/libusb.git
## 
    ./autogen.sh --disable-udev
## 
    CC=/home/disk2/sdk/wya/hi3516cv608/gcc-20250305-arm-v01c02-linux-musleabi/arm-v01c02-linux-musleabi-gcc/bin/arm-v01c02-linux-musleabi-gcc

##
    ./configure --host=arm-v01c02-linux-musleabi --disable-udev --prefix=/home/disk2/user/wya/hi3516cv608/libusb/libusb_out
