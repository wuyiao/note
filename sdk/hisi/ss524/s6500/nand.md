    setenv bootargs 'mem=256M console=ttyAMA0,115200 clk_ignore_unused ubi.mtd=2 root=ubi0:ubifs rootfstype=ubifs rw mtdparts=nand:1M(boot),10M(kernel),64M(rootfs),2M(logo),-(data)' 
    setenv bootcmd 'nand read 0x42000000 0x100000 0xA00000; bootm 0x42000000'
    saveenv
