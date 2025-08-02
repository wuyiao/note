# uboot
    cp configs/hi3516cv610_defconfig .config
    make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- menuconfig
    make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- -j 20

# kernel
    make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- menuconfig
    make kernel BOOT_MEDIA=spi LIB_TYPE=musl DEBUG=0 -j
