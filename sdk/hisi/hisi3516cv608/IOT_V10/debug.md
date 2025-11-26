# net
    ifconfig eth0 up
    ifconfig eth0 192.168.2.100 netmask 255.255.255.0 up
    route add default gw 192.168.2.1
# telent
    /bin/busybox telnetd -l /bin/sh &
# ubuntu 
    sudo vi /etc/exports 
        /home/disk2/nfs_share/wya/t1802  *(rw,sync,no_subtree_check,no_root_squash)
    sudo exportfs -ra
    showmount -e
# nfs
    mkdir -p /mnt/disk/nfs
    mount -t nfs -o vers=3,proto=tcp,nolock 192.168.2.239:/home/disk2/nfs_share/wya/iot_v10 /mnt/disk/nfs/
# ch9434
## cat /dev/ttyWCH0
    stty -F /dev/ttyWCH0 9600
    echo -e "\x41\x42\x43" > /dev/ttyWCH0
