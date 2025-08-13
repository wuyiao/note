## toolplatform
  ![Alt Text](https://github.com/wuyiao/note/blob/master/sdk/hisi/ss524/s6500/image/toolplatform.png)

    mkdir -p /mnt/mtd && mount -t ubifs /dev/ubi0_0 /mnt/mtd

只执行上面步骤就行

---下面为新板子手动测试过程
## uboot
    setenv bootargs 'mem=256M console=ttyAMA0,115200 clk_ignore_unused ubi.mtd=2 root=ubi0:ubifs rootfstype=ubifs rw mtdparts=nand:1M(boot),10M(kernel),80M(rootfs.ubifs),2M(logo),-(data)' 
    setenv bootcmd 'nand read 0x42000000 0x100000 0xA00000; bootm 0x42000000'
    saveenv
## net
    ifconfig eth0 up
    ifconfig eth0 192.168.2.100 netmask 255.255.255.0 up
    route add default gw 192.168.2.1
## nfs
    mkdir -p /mnt/disk/nfs
    mount -o nolock 192.168.2.239:/home/disk2/nfs_share /mnt/disk/nfs/
## init ubifs
    chmod -R 777 /mnt/disk/nfs/wya/ss524_bin/board_glibc
    cd /mnt/disk/nfs/wya/ss524_bin/board_glibc
    cat /proc/mtd
    ./ubiformat /dev/mtd2
    ./ubiattach /dev/ubi_ctrl -m 2
    ./ubinfo /dev/ubi0
    ./ubimkvol /dev/ubi0 -N ubifs -s 74MiB
## make rootfs.ubi
    sudo chown -R 1000:1000 rootfs_ubifs/
    sudo chmod -R 755 rootfs_ubifs/
    mkfs.ubifs -r rootfs_ubifs -m 2048 -e 126976 -c 920 -o rootfs.ubifs
    ubinize -o rootfs.ubi -m 2048 -p 128KiB -s 2048 ubinize.cfg
    cp rootfs.ubi /home/disk2/nfs_share/wya/ss524_bin/board_glibc/
## writer rootfs.ubi
    ./ubidetach -m 2
    ./ubiformat /dev/mtd2 -y
    ./ubiformat /dev/mtd2 -f rootfs.ubi -y
    ./ubiattach /dev/ubi_ctrl -m 2
## mount ubifs
    mkdir -p /mnt/mtd && mount -t ubifs /dev/ubi0_0 /mnt/mtd
    
    
