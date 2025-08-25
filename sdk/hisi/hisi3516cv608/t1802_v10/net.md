# net
    ifconfig eth0 up
    ifconfig eth0 192.168.2.100 netmask 255.255.255.0 up
    route add default gw 192.168.2.1
# telent
    /bin/busybox telnetd -l /bin/sh &
# nfs
    mkdir -p /mnt/disk/nfs
    mount -o nolock 192.168.2.239:/home/disk2/nfs_share /mnt/disk/nfs/
