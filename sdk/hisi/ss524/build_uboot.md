# 编译uboot
  ### 注意：这一步生成的 u-boot.bin 只是一个中间件，并不是最终在单板上执行的 U-boot 镜像
  ## 1.拷贝配置文件
    cp configs/ss524v100_defconfig .config
  ## 2.配置编译环境
    make ARCH=arm CROSS_COMPILE=arm-mix410-linux- menuconfig
  ## 3.编译uboot
    make ARCH=arm CROSS_COMPILE=arm-mix410-linux- -j 20

# 使用osdrv\tools\pc\uboot_tools\”目录下的配置表格配置
  ## 1.配置DDR存储器
  ## 2.配置管教复用
  保存

# 生成最终uboot镜像
  ## 1.根据表格配置生成reg_info.bin
    方法1.直接点击表格第一页上的Generate reg bin file
    方法2.使用 regbin 工具（参考同级目录下解压的readme）
  ## 2.将生成的 reg_info.bin 复制到 open_source/u-boot/u-boot-2020.01/目录
    cp ../../../osdrv/tools/pc/uboot_tools/reg_info.bin .reg 
    make ARCH=arm CROSS_COMPILE=arm-mix410-linux- u-boot-z.bin
  生成的 u-boot-ss524v100.bin 就是能够在单板上运行的 uboot 镜像


# bootargs
  ## emmc
    CONFIG_USE_BOOTARGS=y
    CONFIG_BOOTARGS="mem=528M console=ttyAMA0,115200 clk_ignore_unused blkdevparts=mmcblk0:1M(u-boot.bin),15M(kernel),128M(mtd),-(data)"
    CONFIG_USE_BOOTCOMMAND=y
    CONFIG_BOOTCOMMAND="mmc read 0x0 0x4a000000 0x800 0x7800;bootm 0x4a000000"

  ## nand
    arch=arm
    baudrate=115200
    board=ss524v100
    board_name=ss524v100
    bootargs=mem=256M console=ttyAMA0,115200 clk_ignore_unused ubi.mtd=2 root=ubi0:ubifs rootfstype=ubifs rw mtdparts=nand:1M(boot),10M(kernel),115M(rootfs.ubifs),2M(logo)
    bootcmd=nand read 0x5a000000 0x7e00000 0x200000;decjpgadv 0 18 0 0x60000000;nand read 0x42000000 0x100000 0xA00000; bootm 0x42000000
    bootdelay=2
    cpu=armv7
    ethact=eth0
    jpeg_addr=0x5a000000
    jpeg_emar_buf=0x5b000000
    jpeg_size=0x200000
    soc=ss524v100
    stderr=serial
    stdin=serial
    stdout=serial
    vendor=vendor
    verify=n
    vobuf=0x60000000
