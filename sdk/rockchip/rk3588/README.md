# 迁移过来的sdk解压后报错解决方法
## 编译内核报错
报错原因为生成dtb文件错误，实际为缺少lz4库：

    sudo tee /etc/apt/sources.list > /dev/null <<'EOF'
    deb http://archive.ubuntu.com/ubuntu focal main universe multiverse restricted
    deb http://archive.ubuntu.com/ubuntu focal-updates main universe multiverse restricted
    deb http://archive.ubuntu.com/ubuntu focal-security main universe multiverse restricted
    EOF


    sudo apt update
    sudo apt install lz4

## 编译文件系统报错

    make: Leaving directory '/home/disk2/sdk/rk3588/rk3588_linux/buildroot'
    you need to install 'unbuffer' (from package expect or expect-dev)
    Failed to build /home/disk2/sdk/rk3588/rk3588_linux/buildroot/output/rockchip_rk3588/.config:
    tail: cannot open '/home/disk2/sdk/rk3588/rk3588_linux/.buildroot/br.log' for reading: No such file or directory
    Command exited with non-zero status 1
    you take 0:01.49 to build buildroot
    ERROR: Running build_buildroot failed!
    ERROR: exit code 1 from line 913:
        /usr/bin/time -f "you take %E to build buildroot" $COMMON_DIR/mk-buildroot.sh $RK_CFG_BUILDROOT $DST_DIR



    sudo apt update
    sudo apt install expect

tar -cvf - rk3568_Android11/ | pigz -p 32 > rk3568_Android11.tar.gz
