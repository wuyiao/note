    # printenv 
    arch=arm
    baudrate=115200
    board=hi3516cv610
    board_name=hi3516cv610
    bootargs=mem=32m earlycon=pl011,0x11040000 console=ttyAMA0,115200 clk_ignore_unused initcall_debug rw root=/dev/mtdblock3 rootfstype=jffs2 mtdparts=sfc:512K(boot),512K(env),5M(kernel),8M(rootfs)
    bootcmd=sf probe 0; sf read 0x41000000 0x100000 0x500000; bootm 0x41000000
    bootdelay=2
    cpu=armv7
    ethact=eth0
    fdt_high=0xffffffff
    soc=hi3516cv610
    stderr=serial
    stdin=serial
    stdout=serial
    vendor=hisilicon
    verify=n
    
    Environment size: 474/262140 bytes
    # 
