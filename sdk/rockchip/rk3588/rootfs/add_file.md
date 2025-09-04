touch@bestom-Precision-Tower-7910:rk3588$ pwd
/home/touch/projects/rk3588/rk3588_Android12_r12/rk3588_Android12/device/rockchip/rk3588
touch@bestom-Precision-Tower-7910:rk3588$ ls ws73/
btc_cali.bin  plat_soc.ko  wifi_cali.bin  wifi_soc.ko  wow.bin  ws73.bin  ws73_cfg.ini

vi device.mk

# ws73 bin files
PRODUCT_COPY_FILES += \
    device/rockchip/rk3588/ws73/ws73.bin:system/etc/ws73/ws73.bin \
    device/rockchip/rk3588/ws73/wifi_cali.bin:system/etc/ws73/wifi_cali.bin \
    device/rockchip/rk3588/ws73/btc_cali.bin:system/etc/ws73/btc_cali.bin \
    device/rockchip/rk3588/ws73/wow.bin:system/etc/ws73/wow.bin \
    device/rockchip/rk3588/ws73/ws73_cfg.ini:system/etc/ws73_cfg.ini \
    device/rockchip/rk3588/ws73/plat_soc.ko:$(TARGET_COPY_OUT_VENDOR)/modules/plat_soc.ko \
    device/rockchip/rk3588/ws73/wifi_soc.ko:$(TARGET_COPY_OUT_VENDOR)/modules/wifi_soc.ko
