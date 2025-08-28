# kernel
## 修改对应的config
直接打印中找编译命令make LIB_TYPE=musl CHIP=hi3516cv610 DEBUG=1 all对应的config文件：hi3516cv610_debug_defconfig，然后添加

    CONFIG_INITRAMFS_SOURCE="/home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0/smp/a7_linux/source/bsp/pub/rootfs_debug_musl_arm"
    CONFIG_INITRAMFS_ROOT_UID=0
    CONFIG_INITRAMFS_ROOT_GID=0
    CONFIG_BLK_DEV_INITRD=y

单编

    make LIB_TYPE=musl CHIP=hi3516cv610 DEBUG=1 kernel

# 烧录
之前的文件系统不用烧了，这个kernel中有内嵌的
烧录时注意修改对应的大小，因为新的uImage变大了，修改对应长度

# uboot
修改对应配置，烧录是配置长度为5M，现在就命令行修改对应配置验证，无误后再修改uboot源码

    setenv bootcmd 'sf probe 0; sf read 0x41000000 0x100000 0x500000; bootm 0x41000000'
    setenv bootargs 'mem=32m earlycon=pl011,0x11040000 console=ttyAMA0,115200 clk_ignore_unused initcall_debug rw root=/dev/mtdblock3 rootfstype=jffs2 mtdparts=sfc:512K(boot),512K(env),5M(kernel),8M(rootfs)'
    saveenv
config配置

    CONFIG_USE_BOOTARGS=y
    CONFIG_BOOTARGS="mem=32m earlycon=pl011,0x11040000 console=ttyAMA0,115200 clk_ignore_unused initcall_debug rw root=/dev/mtdblock3 rootfstype=jffs2 mtdparts=sfc:512K(boot),512K(env),5M(kernel),8M(rootfs)"
    CONFIG_USE_BOOTCOMMAND=y
    CONFIG_BOOTCOMMAND="sf probe 0; sf read 0x41000000 0x100000 0x500000; bootm 0x41000000"


# 验证
直接到etc下面建个目录，断电重启后看是否还在，断电消失说明配置没问题

# env文件配置
目录：/home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0/smp/a7_linux/source/bsp/tools/pc/uboot_env/env_text/hi3516cv610/nor_env.txt

