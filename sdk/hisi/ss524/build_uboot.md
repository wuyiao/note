# --编译uboot
  ### 注意：这一步生成的 u-boot.bin 只是一个中间件，并不是最终在单板上执行的 U-boot 镜像
  ## 1.拷贝配置文件
    cp configs/ss524v100_defconfig .config
  ## 2.配置编译环境
    make ARCH=arm CROSS_COMPILE=arm-mix410-linux- menuconfig
  ## 3.编译uboot
    make ARCH=arm CROSS_COMPILE=arm-mix410-linux- -j 20

# --使用osdrv\tools\pc\uboot_tools\”目录下的配置表格配置
  ## 1.配置DDR存储器
  ## 2.配置管教复用
  保存

# --生成最终uboot镜像
  ## 1.根据表格配置生成reg_info.bin
    方法1.直接点击表格第一页上的Generate reg bin file
    方法2.使用 regbin 工具（参考同级目录下解压的readme）
  ## 2.将生成的 reg_info.bin 复制到 open_source/u-boot/u-boot-2020.01/目录
    cp osdrv/tools/pc/uboot_tools/reg_info.bin .reg 
    make ARCH=arm CROSS_COMPILE=arm-mix410-linux- u-boot-z.bin
  生成的 u-boot-ss524v100.bin 就是能够在单板上运行的 uboot 镜像
