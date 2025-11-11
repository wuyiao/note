## build

make ARCH=arm CROSS_COMPILE=arm-v01c02-linux-musleabi- LIB_TYPE=musl CHIP=hi3516cv608 BOOT_MEDIA=spi_nand DEBUG=1 all

## uboot

CONFIG_USE_BOOTARGS=y
CONFIG_BOOTARGS="bootargs=mem=32m console=ttyAMA0,115200 clk_ignore_unused root=ubi0:ubifs rootfstype=ubifs rw ubi.mtd=3 mtdparts=nand:512K(boot),512K(env),6M(kernel),121M(rootfs)"
CONFIG_USE_BOOTCOMMAND=y
CONFIG_BOOTCOMMAND="nand read 0x41000000 0x100000 0x600000; bootm 0x41000000"

### Y:\sdk\wya\hi3516cv608\Hi3516CV610_SDK_V1.0.2.0\open_source\u-boot\u-boot-2022.07\drivers\mtd\nand\raw\fmc100\fmc_spi_nand_ids.c

    /* GD 3.3v GD5F1GQ5REYIG 1Gbit */
    {
      .name      = "GD5F1GM7UEYIGR",
      .id        = {0xc8, 0x91},
      .id_len    = _2B,
      .chipsize  = _128M,
      .erasesize = _128K,
      .pagesize  = _2K,
      .oobsize   = _128B,
      .badblock_pos = BBP_FIRST_PAGE,
      .read      = {
        &read_std(1, INFINITE, 24),
        &read_fast(1, INFINITE, 133),
        &read_dual(1, INFINITE, 133),
        &read_dual_addr(1, INFINITE, 104),
        &read_quad(1, INFINITE, 133),
        &read_quad_addr(2, INFINITE, 104),
        0
      },
      .write     = {
        &write_std(0, 256, 133),
        &write_quad(0, 256, 133),
        0
      },
      .erase     = {
        &erase_sector_128k(0, _128K, 104),
        0
      },
      .driver    = &spi_driver_general,
    },

## kernel

Y:\sdk\wya\hi3516cv608\Hi3516CV610_SDK_V1.0.2.0\open_source\linux\linux-5.10.y\drivers\mtd\nand\fmc100\fmc_spi_nand_ids.c

	/* GD 3.3v GD5F1GQ5REYIG 1Gbit */
	{
		.name      = "GD5F1GM7UEYIGR",
		.id        = {0xc8, 0x91},
		.id_len    = 2,
		.chipsize  = _128M,
		.erasesize = _128K,
		.pagesize  = _2K,
		.oobsize   = 128,
		.badblock_pos = BBP_FIRST_PAGE,
		.read      = {
			&read_std(1, INFINITE, 24),
			&read_fast(1, INFINITE, 133),
			&read_dual(1, INFINITE, 133),
			&read_dual_addr(1, INFINITE, 104),
			&read_quad(1, INFINITE, 133),
			&read_quad_addr(2, INFINITE, 104),
			0
		},
		.write     = {
			&write_std(0, 256, 133),
			&write_quad(0, 256, 133),
			0
		},
		.erase     = {
			&erase_sector_128k(0, _128K, 133),
			0
		},
		.driver    = &spi_driver_general,
	},


