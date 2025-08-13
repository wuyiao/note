# uboot 代码修改
添加decjpgadv，目的是为了把其他几个命令再打包一下简化操作
## cmd
### cmd_vo.c
## include
### env_default.h
## product/ot_osd/dec/
### jpegd.c
### jpegd.h
### jpegd_entry.c

# uboot 命令行测试
    setenv jpeg_addr 0x5a000000
    setenv jpeg_size 0x200000  
    setenv vobuf 0x60000000  
    setenv jpeg_emar_buf 0x5b000000
    nand read 0x5a000000 0x5b00000 0x200000
    decjpgadv 0 18 0 0x60000000
