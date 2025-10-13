## make rootfs.ubi
    sudo chown -R 1000:1000 rootfs_ubifs/
    sudo chmod -R 755 rootfs_ubifs/
    
    mkfs.ubifs -r rootfs_ubifs -m 2048 -e 126976 -c 980 -o rootfs.ubifs -F
    
    ubinize -o rootfs.ubi -m 2048 -p 128KiB -s 2048 ubinize.cfg

## ubinize.cfg
    [ubifs]
    mode=ubi
    image=rootfs.ubifs
    vol_id=0
    vol_type=dynamic
    vol_name=rootfs
    vol_flags=autoresize
