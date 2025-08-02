# sdk
### 将下载好的linux版本压缩包放在SDK版本包中的open_source/linux/目录下
    https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.10.221.tar.gz 
### 将 mtdutils-2.1.4.tar.bz2 压缩包下载到 open_source/mtd-utils/ 目录
    https://infraroot.at/pub/mtd/mtd-utils-2.1.4.tar.bz2
    
## uboot
    cp configs/hi3516cv610_defconfig .config
    make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- menuconfig
    make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- -j 20

## kernel
    make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- menuconfig
    make kernel BOOT_MEDIA=spi LIB_TYPE=musl DEBUG=0 -j

## 整编
    在 smp/a7_linux/source/bsp 目录下执行 make 命令整编小系统镜像:
    make all
    默认编译参数为:
    make LIB_TYPE=musl CHIP=hi3516cv610 DEBUG=0 all
    编译参数说明：
    a. BOOT_MEDIA默认选择spi启动方式编译，可选择emmc启动方式编译,即
    BOOT_MEDIA=emmc；
    b. LIB_TYPE默认为musl编译，即LIB_TYPE=musl；
    c. CHIP默认为hi3516cv610，可选择hi3516cv610或hi3516cv608 编译，即
    CHIP=hi3516cv610或hi3516cv608；
    d. DEBUG默认为DEBUG=0，表示编译 release 版本系统镜像。可选择为
    DEBUG=1，即编译debug版本系统镜像。
