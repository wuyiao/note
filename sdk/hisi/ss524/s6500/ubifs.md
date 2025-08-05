## uboot
    setenv bootargs 'mem=256M console=ttyAMA0,115200 clk_ignore_unused ubi.mtd=2 root=ubi0:ubifs rootfstype=ubifs rw mtdparts=nand:1M(boot),10M(kernel),100M(mtd),2M(logo),-(data)' 
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
    ./ubimkvol /dev/ubi0 -N ubifs -s 100MiB
    mkdir -p /mnt/mtd
    ./mount -t ubifs /dev/ubi0_0 /mnt/mtd
???如果此时直接重启的话，会发现 /dev/ubi0 都不见了，得执行 ubiattach /dev/ubi_ctrl -m 2 绑定分区，才有 /dev/ubi0，可以修改启动参数，来自动绑定
启动到uboot，修改 bootars
下一次开机之后，就不需要格式化分区，创建卷这些步骤了，只需要挂载
## mount ubifs
    mount -t ext4 /dev/mmcblk0p3 /mnt/mtd/
## build ubifs
    
