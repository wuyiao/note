## 生成 64 MB 的 rootfs，rootfs 目录是 rootfs_ubifs，输出前缀叫 rootfs_hi3516cv610_64M：
    chmod +x mk_ubi.sh
    ./mk_ubi.sh 64 rootfs_ubifs rootfs_hi3516cv610_64M
## 生成脚本
    #!/bin/bash
    # =============================================================================
    # mk_ubi.sh - Generate UBIFS/UBI image for Hi3516CV610
    # Usage: ./mk_ubi.sh <size(MB)> <rootfs_dir> <output_prefix>
    # Example: ./mk_ubi.sh 64 rootfs_ubifs rootfs_hi3516cv610_64M
    # =============================================================================
    
    set -e
    
    if [ $# -ne 3 ]; then
        echo "Usage: $0 <size(MB)> <rootfs_dir> <output_prefix>"
        exit 1
    fi
    
    PART_SIZE_MB=$1
    ROOTFS_DIR=$2
    OUTPUT_PREFIX=$3
    
    # ---------------- NAND / UBIFS 参数 ----------------
    PAGESIZE=2048        # NAND page size in bytes
    BLOCKSIZE=131072     # NAND block size in bytes (128KB)
    LEB=$((BLOCKSIZE - PAGESIZE*2))          # LEB size
    PART_SIZE_BYTES=$((PART_SIZE_MB * 1024 * 1024))
    MAX_LEB_CNT=$((PART_SIZE_BYTES / BLOCKSIZE))
    
    UBIIMG="${OUTPUT_PREFIX}.ubiimg"
    UBIIMG_FINAL="${OUTPUT_PREFIX}.ubifs"
    UBICFG="${OUTPUT_PREFIX}.ubicfg"
    
    # ---------------- 检查 rootfs ----------------
    if [ ! -d "$ROOTFS_DIR" ]; then
        echo "Error: rootfs directory $ROOTFS_DIR does not exist!"
        exit 1
    fi
    
    # ---------------- 生成 UBIFS ----------------
    echo ">>> Generating UBIFS image..."
    mkfs.ubifs -F -d "$ROOTFS_DIR" -m $PAGESIZE -e $LEB -c $MAX_LEB_CNT -o "$UBIIMG" -x lzo
    
    # ---------------- 生成 UBINIZE 配置 ----------------
    echo ">>> Creating ubinize.cfg..."
    cat > "$UBICFG" <<EOF
    [ubifs-volumn]
    mode=ubi
    image=$UBIIMG
    vol_id=0
    vol_type=dynamic
    vol_alignment=1
    vol_name=ubifs
    vol_flags=autoresize
    EOF
    
    # ---------------- 生成最终 UBI 镜像 ----------------
    echo ">>> Generating final UBI image..."
    ubinize -o "$UBIIMG_FINAL" -m $PAGESIZE -p $BLOCKSIZE "$UBICFG"
    
    echo ">>> Done! Generated files:"
    echo "  UBIFS image: $UBIIMG"
    echo "  UBI config : $UBICFG"
    echo "  Final UBI  : $UBIIMG_FINAL"


# 原sdk编译
## 原编译打印
    chmod +x /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/hi3516cv610_image_musl/mkubiimg.sh
    # build the pagesize = 2k, blocksize = 128k, part_size = 32M #
    pushd /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/hi3516cv610_image_musl;fakeroot ./mkubiimg.sh hi3516cv610 2k 128k /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/rootfs_musl_arm 32M /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/bin/pc;popd
    /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/hi3516cv610_image_musl /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp
    /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/bin/pc/mkfs.ubifs -F -d /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/rootfs_musl_arm -m 2048 -o rootfs_hi3516cv610_2k_128k_32M.ubiimg -e 126976 -c 256
    
    /home/disk2/sdk/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0_8m/smp/a7_linux/source/bsp/pub/bin/pc/ubinize -o rootfs_hi3516cv610_2k_128k_32M.ubifs -m 2048 -p 131072 rootfs_hi3516cv610_2k_128k_32M.ubicfg
    ubinize: volume size was not specified in section "ubifs-volumn", assume minimum to fit image "rootfs_hi3516cv610_2k_128k_32M.ubiimg"3428352 bytes (3.2 MiB)

## 原编译脚本
    touch@touch-machine:pub$ cat ../../../source/bsp/tools/pc/ubi_sh/mkubiimg.sh
    #!/bin/bash
    
    function usage ()
    {
    	echo "Usage: ${selfname}  Chip Pagesize  Blocksize  Dir  Size  Tool_path Res"
    	echo "  Chip            Chip name. "
    	echo "  Pagesize        NAND page size. 2k/4k/8k."
    	echo "  Blocksize       NAND block size. 128k/256k/1M "
    	echo "  Dir             The directory you want to make ubifs"
    	echo "  Size            This ubifs partition size in NAND. 48M, ... 50M"
    	echo "  UBI Tool        The path of mkfs.ubifs and ubinize"
    	echo "  Res             Reserve ubiimg and ubifs both (1:Yes 0:No(default))"
    	echo ""
    	echo "Example:"
    	echo "  ${selfname} xxx(chip name) 2k 128k bsp/pub/rootfs 50M bsp/pub/bin/pc 0"
    	echo ""
    	exit 0
    }
    ###############################################################################
    
    function run ()
    {
    	local cmd=$1
    	echo "${cmd}"
    	msg=$(eval "${cmd}"); result=$?
    	echo ${msg}
    	[ ${result} == 0 ] || exit ${result}
    }
    ###############################################################################
    
    function hstrtol ()
    {
    	local hstr=$1
    	local zoom=1
    	local result=$(echo "${hstr}" | awk '{printf "%d",$0}')
    
    	if [ "$(echo ${hstr} | grep '[Gg]')" == "${hstr}" ]; then
    		zoom=1073741824
    	elif [ "$(echo ${hstr} | grep '[Mm]')" == "${hstr}" ]; then
    		zoom=1048576
    	elif [ "$(echo ${hstr} | grep '[Kk]')" == "${hstr}" ]; then
    		zoom=1024
    	fi
    
    	echo $((${result} * ${zoom}))
    }
    ###############################################################################
    #echo "-------->               <----------------"
    #echo "--------------->               <---------"
    ###############################################################################
    
    selfname=$(basename $0)
    
    if [ $# != 7 ] && [ $# != 6 ]; then
    	usage;
    fi
    
    hpagesize=${2}
    pagesize=$(hstrtol ${hpagesize})
    hblocksize=${3}
    blocksize=$(hstrtol ${hblocksize})
    rootdir=$(echo $(echo "${4} " | sed 's/\/ //'))
    #rootfs=${rootdir##*/}
    rootfs=rootfs
    hpartsize=${5}
    partsize=$(hstrtol ${hpartsize})
    chip=${1}
    
    if [ ! -d ${rootdir} ]; then
    	echo "Directory ${rootdir} not exist."
    	exit 1;
    fi
    
    LEB=$((${blocksize} - ${pagesize} * 2))
    MAX_LEB_CNT=$((${partsize} / ${blocksize}))
    ###############################################################################
    
    ubiimg=${rootfs}_${chip}_${hpagesize}_${hblocksize}_${hpartsize}.ubiimg
    ubifsimg=${rootfs}_${chip}_${hpagesize}_${hblocksize}_${hpartsize}.ubifs
    ubicfg=${rootfs}_${chip}_${hpagesize}_${hblocksize}_${hpartsize}.ubicfg
    
    MKUBIFS=$(echo $(echo "${6} " | sed 's/\/ //'))/mkfs.ubifs
    MKUBI=$(echo $(echo "${6} " | sed 's/\/ //'))/ubinize
    chmod +x ${MKUBIFS}
    chmod +x ${MKUBI}
    
    run "${MKUBIFS} -F -d ${rootdir} -m ${pagesize} -o ${ubiimg} -e ${LEB} -c ${MAX_LEB_CNT}"
    
    {
    	echo "[ubifs-volumn]"
    	echo "mode=ubi"
    	echo "image=${ubiimg}"
    	echo "vol_id=0"
    	echo "vol_type=dynamic"
    	echo "vol_alignment=1"
    	echo "vol_name=ubifs"
    	echo "vol_flags=autoresize"
    	echo ""
    
    } > ${ubicfg}
    
    run "${MKUBI} -o ${ubifsimg} -m ${pagesize} -p ${blocksize} ${ubicfg}"
    
    
    echo "--------- ${ubifsimg} is prepared !!"
    if [ ! -n "${7}" ] || [ ${7} = 0 ]; then
    	rm -f ${ubiimg} ${ubicfg}
    	exit 1;
    fi
    echo "--------- ${ubiimg} is prepared !!"
    echo "--------- ${ubicfg} is prepared !!"
    touch@touch-machine:pub$ 
