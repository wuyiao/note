cp configs/hi3516cv610_defconfig .config

make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- -j 20

cp ../../gzip/bin/gzip arch/arm/cpu/armv7/hi3516cv610/hw_compressed/ -rf

chmod +x arch/arm/cpu/armv7/hi3516cv610/hw_compressed/gzip

make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- u-boot-z.bin


--------------------------------------------------------------------------------------------------


cd /home/disk2/sdk/wya/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0/smp/a7_linux/source/bsp/components/gsl

make clean

make CHIP=hi3516cv610

cd ../..

cp ../../../../open_source/u-boot/u-boot-2022.07/u-boot-hi3516cv610.bin ./tools/pc/image_tool/input/u-boot-original.bin

cp tools/pc/boot_tools/reg_info.bin ./tools/pc/image_tool/input

cd tools/pc/image_tool

python oem/oem_quick_build.py


/home/disk2/sdk/wya/hi3516cv610/Hi3516CV610_SDK_V1.0.2.0/smp/a7_linux/source/bsp/tools/pc/image_tool/image/oem
目录下生成--->boot_image.bin
