## uboot
    setenv bootargs 'mem=256M console=ttyAMA0,115200 clk_ignore_unused ubi.mtd=2 root=ubi0:ubifs rootfstype=ubifs rw mtdparts=nand:1M(boot),10M(kernel),110M(mtd),2M(logo),-(data)' 
    setenv bootcmd 'nand read 0x42000000 0x100000 0xA00000; bootm 0x42000000'
    saveenv
## net
    ifconfig eth0 up
    ifconfig eth0 192.168.2.100 netmask 255.255.255.0 up
    route add default gw 192.168.2.1
## nfs
    mkdir -p /mnt/disk/nfs
    mount -o nolock 192.168.2.239:/home/disk2/nfs_share /mnt/disk/nfs/
    
# ubi-tool
## init ubifs
    chmod -R 777 /mnt/disk/nfs/wya/ss524_bin/board_glibc
    cd /mnt/disk/nfs/wya/ss524_bin/board_glibc
    cat /proc/mtd
    ./ubiformat /dev/mtd2
    ./ubiattach /dev/ubi_ctrl -m 2
    ./ubinfo /dev/ubi0
    ./ubimkvol /dev/ubi0 -N ubifs -s 93MiB
    mount -t ubifs /dev/ubi0_0 /mnt
    ubiattach /dev/ubi_ctrl -m 2
## mount ubifs
    mount -t ext4 /dev/mmcblk0p3 /mnt/mtd/
## build ubifs
    
