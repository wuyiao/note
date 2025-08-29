单编，不要整编，整编会自动生成新的rootfs把旧的删掉

1.osdrv 顶层 Makefile 使用说明
本目录下的编译脚本支持 arm-mix410-linux 工具链，arm-mix410-linux 对应glibc库。
具体命令如下(以ss524v100举例)

(1)编译整个osdrv目录：
	make all
    可以传如下参数：
    a, BOOT_MEDIA:spi(default) or emmc
    b, CHIP:ss524v100(default) or ss522v100 or ss615v100
    c, 如果客户想要更换u-boot表格文件, 可以使用TARGET_XLSM=*.xlsm来指定所需要的u-boot表格文件

示例：	make BOOT_MEDIA=emmc all
	生成文件保存在osdrv/pub/...

(2)清除整个osdrv目录的编译文件：
	make clean

(3)彻底清除整个osdrv目录的编译文件，除清除编译文件外，还删除已编译好的镜像：
	make distclean

(4)单独编译kernel：
	待进入内核源代码目录后，执行以下操作

	cp arch/arm/configs/ss524v100_defconfig .config
    (emmc启动时执行如下操作：cp arch/arm/configs/ss524v100_emmc_defconfig  .config)
	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- menuconfig
	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- uImage

(5)单独编译模块：
	待进入内核源代码目录后，执行以下操作

	cp arch/arm/configs/ss524v100_defconfig  .config
    (emmc启动时执行如下操作：cp arch/arm/configs/ss524v100_emmc_defconfig  .config)
	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- menuconfig
	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- modules

(6)单独编译uboot：
	注意：发布包默认按照DMEB板的配置发布，如果客户单板和DEMB板不一致，需要根据客户自己的单板环境修改uboot表格才能使用，否则可能导致uboot无法启动或者其他问题。

    待进入boot源代码目录后，执行以下操作
	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- ss524v100_defconfig
	(emmc启动时执行如下操作：make ARCH=arm CROSS_COMPILE=arm-mix410-linux- ss524v100_emmc_defconfig)
	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- menuconfig
	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- -j 20

    Windowns下进入到osdrv/tools/pc/uboot_tools/目录下打开对应单板的Excel文件,在main标签中点击"Generate reg bin file"按钮,生成reg_info.bin即为对应平台的表格文件。
    从osdrv/tools/pc/uboot_tools目录拷贝reg_info.bin到boot源代码目录,重命名为.reg
    cp ../../../osdrv/tools/pc/uboot_tools/reg_info.bin .reg

    make ARCH=arm CROSS_COMPILE=arm-mix410-linux- u-boot-z.bin

    在uboot根目录下生成的u-boot-ss524v100.bin即为可用的u-boot镜像

(7)制作文件系统镜像：
在osdrv/pub/中有已经编译好的文件系统，因此无需再重复编译文件系统，只需要根据单板上flash的规格型号制作文件系统镜像即可。

	SPI NOR Flash使用jffs2格式的镜像，制作jffs2镜像时，需要用到SPI NOR Flash的块大小。这些信息会在uboot启动时
	会打印出来。建议使用时先直接运行mkfs.jffs2工具，根据打印信息填写相关参数。
	下面以块大小为64KB为例：
	osdrv/pub/bin/pc/mkfs.jffs2 -d osdrv/pub/rootfs_glibc -l -e 0x10000 -o osdrv/pub/rootfs_glibc_64k.jffs2

	Nand Flash使用UBI文件系统，在osdrv/tools/pc/ubi_sh下提供mkubiimg.sh工具用于制作UBI文件系统，需要用到Nand
	Flash的pagesize、blocksize和UBIFS分区的大小。
	以2KB pagesize, 128KB blocksize和UBI文件系统分区大小32MB为例：
	mkubiimg.sh ss524v100 2k 128k osdrv/pub/rootfs 32M osdrv/pub/bin/pc

	osdrv/pub/rootfs是根文件系统文件夹目录
	osdrv/pub/bin/pc是制作UBI文件系统镜像的工具目录
	生成的rootfs_ss524v100_2k_128k_32M.ubifs，就是最终用于烧写的UBI文件系统镜像。

	emmc 使用ext4格式的镜像：以96MB镜像为例：
	dd if=/dev/zero of=osdrv/pub/rootfs_ss524v100_96M.ext4 bs=512 count=196608
	备注:(196608 = 96 *1024 * 1024 / 512)
	./osdrv/pub/bin/pc/mkfs.ext4 osdrv/pub/rootfs_ss524v100_96M.ext4
	cd open_source/e2fsprogs/out/pc/contrib
	./populate-extfs.sh ../../../../../osdrv/pub/rootfs_glibc ../../../../../osdrv/pub/rootfs_ss524v100_96M.ext4

2.注意事项
(1)在windows下复制源码包时，linux下的可执行文件可能变为非可执行文件，导致无法编译使用；u-boot或内核下编译后，会有很多符号链接文件，在windows下复制这些源码包, 会使源码包变的巨大，因为linux下的符号链接文件变为windows下实实在在的文件，因此源码包膨胀。因此使用时请注意不要在windows下复制源代码包。
(2)编译板端软件
    a.此芯片具有浮点运算单元和neon。文件系统中的库是采用兼容软浮点调用接口的硬浮点和neon编译而成，因此请用户注意，所有此芯片板端代码编译时需要在Makefile里面添加选项-mcpu=cortex-a7、-mfloat-abi=softfp和-mfpu=neon-vfpv4。
如：
对于A7：
    CFLAGS += -mcpu=cortex-a7 -mfloat-abi=softfp -mfpu=neon-vfpv4 -fno-aggressive-loop-optimizations
    CXXFlAGS +=-mcpu=cortex-a7 -mfloat-abi=softfp -mfpu=neon-vfpv4 -fno-aggressive-loop-optimizations
其中CXXFlAGS中的XX根据用户Makefile中所使用宏的具体名称来确定，e.g:CPPFLAGS。
