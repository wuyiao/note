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
