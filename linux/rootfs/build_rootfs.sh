# 修改rootfs大小
# 进入 rootfs 所在目录
cd ./rootfs_busybox

# 计算需要的 ext4 镜像大小（单位：块）
SIZE=$(du -s -B1 . | cut -f1)
BUFFER=$((SIZE / 5))  # 增加20%
TOTAL=$((SIZE + BUFFER))

# 转为以 M 为单位向上取整
TOTAL_MB=$(((TOTAL + 1024 * 1024 - 1) / (1024 * 1024)))

echo "实际内容大小为 $SIZE 字节，推荐镜像大小为 $TOTAL_MB MB"

# 创建 ext4 镜像
cd ..
dd if=/dev/zero of=rootfs.ext4 bs=1M count=$TOTAL_MB
mkfs.ext4 rootfs.ext4

# 拷贝文件进去
mkdir -p ./tmp/mnt_rootfs
sudo mount -o loop rootfs.ext4 ./tmp/mnt_rootfs
sudo cp -a rootfs_busybox/* ./tmp/mnt_rootfs/
sudo umount ./tmp/mnt_rootfs
