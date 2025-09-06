使用rk工具调试网口---不要插网线
1.切换到RK3588内置以太网控制器的sysfs设备目录

    cd /sys/devices/platform/fe1c0000.ethernet/
2.启用或配置PHY（物理层芯片）的回环（Loopback）测试模式，获得延时实际值

    echo 1000 > phy_lb_scan
3.配置RGMII（Reduced Gigabit Media Independent Interface）接口的延迟

    echo 0x3c -1 >  rgmii_delayline 
4.启动PHY回环测试或设置回环模式参数

    echo 1000 > phy_lb
5.使用iperf3测试网速

    iperf3 -s
