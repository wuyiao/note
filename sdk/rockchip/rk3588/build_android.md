# 系统固件编译
## 安卓系统源码
### 1.3588 有两套安卓系统源码，r10  和  r12 ，这两个版本都是Android12，目前代码已经都迁移到 r12，只是有些项目还未编译验证。下面标红的分支是已经编译验证过的系统


    r10: /home/touch/projects/rk3588/rk3588_Android12/
    r12: /home/touch/projects/rk3588/rk3588_Android12_r12/rk3588_Android12/

    

3588 的项目有多个，怎么区分，目前的做法是，内核创建了分支，除了测试用的分支，基本一个分支对应一个版型，而且分支的名字按照板子上的丝印来。安卓系统怎么区分项目，在安卓源码目录下创建了 custom/project_compile.sh 定义项目所需的环境变量，修改编译脚本，根据这些环境变量来决定编译行为，安卓系统基本上就不分板子的前后迭代版本，比如S8500V20和S8500V33，都是用S8500来替代。

3588 安卓r12，内核分支
touch@bestom-Precision-Tower-7910:kernel-5.10$ git branch #以下标红的分支是主要用的分支
  IR88PS02_hh-rkr12
  IR88PS02_hh-rkr12-bak
  IR88PS02_hh-rkr12-hdmirx-zhihui-test
  RK3588_MB-new-rkr10
  RK3588_MB-new-rkr10-rk628-test
  S10_V10_rkr12
  S301_V10
  S301_V10_rkr12
  S302_V20_rkr12
  S800A_V1_rkr12
  S800A_V2_rkr12
  S80A_V20_QUECTEL_4_5G_rkr12
  S80A_V20_rkr12
  S8500-new-rkr10
  S8500-rkr12
  S8500-test
  S8500_V2-rkr10
  S8500_V2-rkr12
  S8500_V3-rkr12
  S8500_V31-rkr12
  S8500_V33-rkr12
* T50_V1-rkr12
  T9_V10-rkr12
  iDste-REC-V2_rkr12
  master
  master-rkr10
  master-rkr12
  master-rkr12-test

怎么编译出一个系统镜像：
1.1编译内核，比如编译 S8500V33 或者 S8500V35
目录 /home/touch/projects/rk3588/rk3588_Android12_r12/rk3588_Android12/kernel-5.10
git checkout S8500_V33-rkr12


    export PATH=../prebuilts/clang/host/linux-x86/clang-r416183b/bin:$PATH
    alias msk='make CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1'
    msk ARCH=arm64 rockchip_defconfig android-11.config pcie_wifi.config
    msk ARCH=arm64 BOOT_IMG=../rockdev/Image-rk3588_s/boot.img rk3588-evb4-lp4-v10.img -j12
目录下会生成boot.img，这就是内核镜像，如果板子已经有跑系统的情况下，源码只修改了内核部分，则烧录boot.img就可以，也不需要下一步编译系统。

1.2编译系统，回到kernel-5.10的上一级目录，然后执行以下命令

    source build/envsetup.sh
    vi custom/project_compile.sh #修改这个脚本，把里面Project变量赋值为 S8500
    source custom/project_compile.sh
    lunch 52
    make installclean # 这个步骤不是必须的，如果上一次编译的时候也是8500这个项目，就不需要
    ./mk_kernel.sh # 编译安卓和内核
    ./my_build.sh -u # 打包成一个镜像

补充：带4g或5g模块的项目稍微麻烦，3588平台，目前 S80A，S302都带有这类模块，

编译 S80A 4G 的步骤
第一步打开 custom/project_compile.sh 
Project=S80A_V10 # 修改 Project 变量的值为 S80A_V10
#按照下面这种修改
if [ "$Project" = S80A_V10 ]; then
    declare -x WITH_4G_FUNCTION="1"
    declare -x MODEM_4G_NAME="MEIG" # 4G 模块用的是美格的
    #declare -x MODEM_4G_NAME="QUECTEL"
    #declare -x SUPPORT_5G="1"
    declare -x PROJECT_NAME="S80A_V10"
    declare -x ISEE_MTD_PATH_NAME="isee_mtd_S80A"
fi
第二步进入到内核目录，切换到S80A对应4g模块的分支，git checkout S80A_V20_rkr12，接下来按照上述1.1  1.2 小节的步骤编译系统镜像

编译 S80A 5G 的步骤
第一步打开 custom/project_compile.sh
Project=S80A_V10 # 修改 Project 变量的值为 S80A_V10
#按照下面这种修改
if [ "$Project" = S80A_V10 ]; then
    declare -x WITH_4G_FUNCTION="1"
    #declare -x MODEM_4G_NAME="MEIG"
    declare -x MODEM_4G_NAME="QUECTEL" #5G模块用的是移远的 
    declare -x SUPPORT_5G="1"
    declare -x PROJECT_NAME="S80A_V10"
    declare -x ISEE_MTD_PATH_NAME="isee_mtd_S80A"
fi
第二步进入到内核目录，切换到S80A对应4g模块的分支，git checkout S80A_V20_QUECTEL_4_5G_rkr12
如果之前编译过美格4g模块，需要删除相关的驱动.o文件，然后再编译内核
rm drivers/meigdrv/GobiNet/*.o
rm drivers/meigdrv/ncm/*.o
第三步，回到安卓目录，编译后者拷贝5G模块需要的库
source build/envsetup.sh
source custom/project_compile.sh
lunch 52
make installclean
./mk_kernel.sh
mmm  hardware/interfaces/radio/1.5/   # 编译库
mmm  hardware/interfaces/radio/config/1.2/
把目录 E:\数据手册\5G_RM500U\android\微信群提供\libril\64 下的 libril.so 复制到目录
Z:\projects\rk3588\rk3588_Android12_r12\rk3588_Android12\out\target\product\rk3588_s\vendor\lib64  # Z 盘是3588系统源码所在服务器共享给windows的samba目录
目录 E:\数据手册\5G_RM500U\android\微信群提供\libril\32 下的 libril.so 复制到目录
Z:\projects\rk3588\rk3588_Android12_r12\rk3588_Android12\out\target\product\rk3588_s\vendor\lib
./mk_kernel.sh # 再次编译系统，把上面的库打包的系统
./my_build.sh -u
2.3568安卓源码
/home/touch/projects/rk3568/rk3568_Android11

和3588一样，3568的源码也是用分支来区分项目。具体分支对应情况已经在《驱动移交跟踪表》说明

编译步骤，比如编译s7500V33的系统固件
1.1切换分支
cd /home/touch/projects/rk3568/rk3568_Android11
.repo/repo/repo checkout S7500A
1.2进入内核目录编译
cd kernel
git checkout S7500A-V33-B2 # 7500有不同的迭代版本，内核有细致的分支，但系统分支都是S7500A
make ARCH=arm64 rockchip_defconfig android-11.config
make ARCH=arm64 BOOT_IMG=../rockdev/Image-rk3568_r/boot.img rk3568-evb1-ddr4-v10.img -j24
1.3回到安卓目录，编译系统以及生成固件
cd ../
source build/envsetup.sh
vi custom/project_compile.sh #修改这个脚本，把里面Project变量赋值为 S7500_V33
source custom/project_compile.sh
lunch 55
make installclean # 这个步骤不是必须的，如果上一次编译的时候也是7500这个项目，就不需要
./mk_kernel.sh # 编译安卓和内核
./my_build.sh -u # 打包成一个镜像固件


