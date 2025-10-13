# 先解压缩解包
    tar -zxvf Hi3516CV610_SDK_V1.0.2.0.tgz
    ./sdk.unpack 
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
修改hi3516cv610_debug_defconfig

    make kernel BOOT_MEDIA=spi LIB_TYPE=musl DEBUG=1 -j

## 整编
    在 smp/a7_linux/source/bsp 目录下执行 make 命令整编小系统镜像:
    make all
    
    make LIB_TYPE=musl CHIP=hi3516cv610 DEBUG=1 all
    编译参数说明：
    a. BOOT_MEDIA默认选择spi启动方式编译，可选择emmc启动方式编译,即
    BOOT_MEDIA=emmc； 
    b. LIB_TYPE默认为musl编译，即LIB_TYPE=musl；
    c. CHIP默认为hi3516cv610，可选择hi3516cv610或hi3516cv608 编译，即
    CHIP=hi3516cv610或hi3516cv608；
    d. DEBUG默认为DEBUG=0，表示编译 release 版本系统镜像。可选择为
    DEBUG=1，即编译debug版本系统镜像。

## 010
    (1)编译整个bsp目录：
            make all
            默认编译:
            make LIB_TYPE=musl CHIP=hi3516cv610 DEBUG=0 all
    
            编译参数说明：
            1)BOOT_MEDIA默认选择spi启动方式编译，可选择emmc启动方式编译,即BOOT_MEDIA=emmc；若使用
    release版本的nand介质，需要传入BOOT_MEDIA=spi_nand。
            2)LIB_TYPE默认为musl编译。
            3)CHIP默认为hi3516cv610，可选择hi3516cv610或hi3516cv608编译,即CHIP=hi3516cv610。
            4)DEBUG默认为DEBUG=0，表示编译 release 版本系统镜像。可选择为DEBUG=1，即编译debug版本
    系统镜像。
            5)bsp/pub目录下文件即为所编译小系统镜像
    
    (2)清除整个bsp目录的编译文件：
            make  clean
    
    (3)彻底清除整个bsp目录的编译中间文件：
            make distclean
    
    (4)单独编译kernel image：
            make kernel

