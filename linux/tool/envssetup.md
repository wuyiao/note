source /home/disk2/user/cxj/envsetup.sh

    function hmm() {
        local T=$(gettop)
        local A=""
        local i
        for i in `cat $T/envsetup.sh | sed -n "/^[[:blank:]]*function /s/function \([a-z_0-9]*\).*/\1/p" | sort | uniq`; do
    	{
          A="$A $i"
    	}
        done
        echo $A
    }
    
    function getusername()
    {
    	echo cxj
    }
    
    function gettop()
    {
    	echo /home/disk2/user/$(getusername)
    }
    
    function croot()
    {
    	cd $(gettop)
    }
    
    function get_ss528_e2fsprogs()
    {
    	echo $(get_ss528_sdk_path)/open_source/e2fsprogs
    }
    
    function ss528_mk_ext4_mtd()
    {
    	if [ "$#" -ne 2 ]; then
            echo "Usage: my_function <param1> <param2>"
            return 
        fi
    	
    	dd if=/dev/zero of=$2 bs=512 count=262144
    	
    	$(get_ss528_e2fsprogs)/out/pc/sbin/mkfs.ext4 $2
    	$(get_ss528_e2fsprogs)/out/pc/contrib/populate-extfs.sh $1 $2
    }
    
    function source_envsetup()
    {
    	source $(gettop)/envsetup.sh
    }
    
    function get_ss528_sdk_path()
    {
    	echo /home/disk2/sdk/ss528v100/SS528V100R001C02SPC011/SS528V100_SDK_V2.0.1.1
    }
    
    function get_ss528_uboot_path()
    {
    	echo $(get_ss528_sdk_path)/open_source/u-boot/u-boot-2020.01-liudh
    }
    
    function css528_sdk()
    {
    	cd $(get_ss528_sdk_path)
    }
    
    function css528_uboot()
    {
    	cd $(get_ss528_uboot_path)
    }
    
    function ss528_uboot_menuconfig()
    {
    	make ARCH=arm CROSS_COMPILE=aarch64-mix210-linux- menuconfig
    }
    
    function ss528_build_uboot()
    {
    	make ARCH=arm CROSS_COMPILE=aarch64-mix210-linux- -j20
    }
    
    function ss528_generate_uboot()
    {
    	make ARCH=arm CROSS_COMPILE=aarch64-mix210-linux- u-boot-z.bin
    }
    
    function get_ss528_kernel_path()
    {
    	echo $(get_ss528_sdk_path)/open_source/linux/linux-4.19.y-liudh
    }
    
    function css528_kernel()
    {
    	cd $(get_ss528_kernel_path)
    }
    
    function ss528_kernel_menuconfig()
    {
    	make ARCH=arm64 CROSS_COMPILE=aarch64-mix210-linux- menuconfig
    }
    
    function ss528_build_kernel()
    {
    	make ARCH=arm64 CROSS_COMPILE=aarch64-mix210-linux- uImage -j20
    }
    
    function ss528_generate_kernel()
    {
    	cd $(get_ss528_sdk_path)/open_source/trusted-firmware-a/trusted-firmware-a-2.2/
    	./mk_ss528v100_liudh.sh
    	cd -
    }
    
    function css528_busybox()
    {
    	cd $(get_ss528_sdk_path)/open_source/busybox/busybox-1.31.1
    }
    
    function ss528_busybox_menuconfig()
    {
    	make menuconfig
    }
    
    function ss528_build_busybox()
    {
    	make -j8
    	make install
    }
    
    function cp_ss528_kernel_uboot_bin()
    {
    	mkdir $(get_ss528_sdk_path)/out
    	cp $(get_ss528_uboot_path)/u-boot-ss528v100.bin $(get_ss528_sdk_path)/out/ -rf
    	cp $(get_ss528_sdk_path)/open_source/trusted-firmware-a/trusted-firmware-a-2.2/build/ss528v100/release/fip.bin $(get_ss528_sdk_path)/out/uImage_ss528v100_initramfs -rf
    }
    
    
    
    
    function get_ss524_e2fsprogs()
    {
    	echo $(get_ss524_sdk_path)/open_source/e2fsprogs
    }
    
    function ss524_mk_ext4_mtd()
    {
    	if [ "$#" -ne 2 ]; then
            echo "Usage: my_function <param1> <param2>"
            return 
        fi
    	
    	dd if=/dev/zero of=$2 bs=512 count=262144
    	
    	$(get_ss524_e2fsprogs)/out/pc/sbin/mkfs.ext4 $2
    	$(get_ss524_e2fsprogs)/out/pc/contrib/populate-extfs.sh $1 $2
    }
    
    function get_ss524_sdk_path()
    {
    	echo /home/disk2/sdk/ss524v100/SS524V100_SDK_V2.0.1.1
    }
    
    function get_ss524_uboot_path()
    {
    	echo $(get_ss524_sdk_path)/open_source/u-boot/u-boot-2020.01-liudh
    }
    
    function css524_sdk()
    {
    	cd $(get_ss524_sdk_path)
    }
    
    function css524_uboot()
    {
    	cd $(get_ss524_uboot_path)
    }
    
    function ss524_uboot_menuconfig()
    {
    	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- menuconfig
    }
    
    function ss524_build_uboot()
    {
    	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- -j20
    }
    
    function ss524_generate_uboot()
    {
    	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- u-boot-z.bin
    }
    
    function get_ss524_kernel_path()
    {
    	echo $(get_ss524_sdk_path)/open_source/linux/linux-4.19.y-liudh
    }
    
    function css524_kernel()
    {
    	cd $(get_ss524_kernel_path)
    }
    
    function ss524_kernel_menuconfig()
    {
    	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- menuconfig
    }
    
    function ss524_build_kernel()
    {
    	make ARCH=arm CROSS_COMPILE=arm-mix410-linux- uImage -j20
    }
    
    
    function css524_busybox()
    {
    	cd $(get_ss524_sdk_path)/open_source/busybox/busybox-1.31.1
    }
    
    function ss524_busybox_menuconfig()
    {
    	make menuconfig
    }
    
    function ss524_build_busybox()
    {
    	make -j8
    	make install
    }
    
    function cp_ss524_kernel_uboot_bin()
    {
    	cp $(get_ss524_uboot_path)/u-boot-ss524v100.bin $(get_ss524_sdk_path)/out/ -rf
    	cp $(get_ss524_kernel_path)/arch/arm/boot/uImage $(get_ss524_sdk_path)/out/uImage_ss524v100_initramfs -rf
    }
    
    
    
    function jgrep()
    {
        find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f -name "*\.java" \
            -exec grep --color -n "$@" {} +
    }
    
    function cgrep()
    {
        find . -name .repo -prune -o \
    		-name .git -prune -o \
    		-name out -prune -o \
    		-type f \( \
    		-name '*.c' -o \
    		-name '*.cc' -o \
    		-name '*.cpp' -o \
    		-name '*.h' -o \
    		-name '*.hpp' \) \
            -exec grep --color -n "$@" {} +
    }
    
    function grep2()
    {
        find . -name .repo -prune -o \
    		-name .git -prune -o \
    		-name out -prune -o \
    		-name .svn -prune -o \
    		-type f \( -name '*' \) \
            -exec grep --color -n "$@" {} +
    }
    
    function targz()
    {
    	tar -zcf $@
    }
    
    function strip_ss528()
    {
    	aarch64-mix210-linux-strip -g --strip-unneeded "$@"
    }
    
    function strip_ss524()
    {
    	arm-mix410-linux-strip -g --strip-unneeded "$@"
    }
    
    function addr2line()
    {
    	$(gettop)/arm-linux-androideabi-addr2line -C -f -e "$1" "$2" 
    }
    
    function addr2line64()
    {
    	$(gettop)/aarch64-linux-android-addr2line -C -f -e "$1" "$2" 
    }

