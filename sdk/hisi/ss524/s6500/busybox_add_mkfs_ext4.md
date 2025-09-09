查看busybox是否已经包含mke2fs了
busybox --list | grep mke2fs
然后执行命令
ln -s busybox mke2fs
ln -s mke2fs mkfs.ext2
ln -s mke2fs mkfs.ext3
ln -s mke2fs mkfs.ext4
