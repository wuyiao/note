# uboot 代码修改
添加decjpgadv，目的是为了把其他几个命令再打包一下简化操作
## cmd/cmd_vo.c
    #define CFG_MAXARGS_DECJPGADV 5
    extern int jpeg_decode_ex(unsigned int format,unsigned int *width, unsigned int *height,unsigned int *stride);
    
    static int do_jpgdadv(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
    {
        int ret;
        if (argc < 5)
        {
            printf("Insufficient parameter!\n");
            printf ("Usage:\n%s\n", cmdtp->usage);
            return -1;
        }
            
    #if 0
        if (argc < 4)
        {
            printf("Insufficient parameter!\n");
            printf ("Usage:\n%s\n", cmdtp->usage);
            return -1;
        }
    #else
    #ifdef	CONFIG_SYS_LONGHELP
        printf ("you should first set:\n%s\n", cmdtp->help);
    #endif
    #endif
    
        ret = load_jpeg();
        if (0 != ret)
        {
            printf("load jpeg err. \n");
            //todo return 0 or ret?
            return 0;
        }
    
        unsigned int width = 0, height = 0,stride = 0;
        jpeg_decode_ex(0,&width, &height,&stride);
    
        unsigned int dev, intftype, sync;
    
        dev  = (unsigned int)simple_strtoul(argv[1], NULL, 10);
        intftype = (unsigned int)simple_strtoul(argv[2], NULL, 10);
            
        if(width == 720 && height == 576)
            sync = OT_VO_OUT_PAL;
        else if(width == 720 && height == 480)
            sync = OT_VO_OUT_NTSC;
        else if(width == 960 && height == 576)
            sync = OT_VO_OUT_960H_PAL;
        else if(width == 960 && height == 480)
            sync = OT_VO_OUT_960H_NTSC;
        else if(width == 1280 && height == 720)
            sync = OT_VO_OUT_720P60;
        else if(width == 1920 && height == 1080)
            sync = OT_VO_OUT_1080P60;
        else if(width == 800 && height == 600)
            sync = OT_VO_OUT_800x600_60;
        else if(width == 1024 && height == 768)
            sync = OT_VO_OUT_1024x768_60;
        else if(width == 1280 && height == 1024)
            sync = OT_VO_OUT_1280x1024_60;
        else if(width == 1366 && height == 768)
            sync = OT_VO_OUT_1366x768_60;
        else if(width == 1440 && height == 900)
            sync = OT_VO_OUT_1440x900_60;
        else if(width == 1280 && height == 800)
            sync = OT_VO_OUT_1280x800_60;
        else if(width == 1600 && height == 1200)
            sync = OT_VO_OUT_1600x1200_60;
        else if(width == 1680 && height == 1050)
            sync = OT_VO_OUT_1680x1050_60;
        else if(width == 1920 && height == 1200)
            sync = OT_VO_OUT_1920x1200_60;
        else if(width == 640 && height == 480)
            sync = OT_VO_OUT_640x480_60;
        else if(width == 1920 && height == 2160)
            sync = OT_VO_OUT_1920x2160_30;
        else if(width == 2560 && height == 1440)
            sync = OT_VO_OUT_2560x1440_30;
        else if(width == 2560 && height == 1600)
            sync = OT_VO_OUT_2560x1600_60;
        else if(width == 3840 && height == 2160)
            sync = OT_VO_OUT_3840x2160_30;
        else
        {
            printf("nonsupport width height %d %d\n", width, height);
            return -1;
        }
    
        if (dev > 2 || sync >= OT_VO_OUT_BUTT)
        {
            printf("Invalid parameter!\n");
            return -1;
        }
    
        ret = start_vo(dev, intftype, sync);
        if (ret != 0) {
            printf(INSUFFICIENT_PARAM_STR);
            return -1;
        }
    
    #if CONFIG_OT_HDMI_SUPPORT
        do_start_hdmi(intftype, sync);
    #endif
    
    #if CONFIG_OT_MIPI_TX_SUPPORT
        do_start_mipi_tx(intftype, sync);
    #endif
    
        vo_set_interface_type(dev, intftype);
    
        printf("dev %u opened!\n", dev);
    
    
        unsigned int layer, strd, x, y, w, h;
        unsigned long addr;
        ot_rect layer_rect;
        unsigned long layer_tmp, addr_tmp, strd_tmp, x_tmp, y_tmp, width_tmp, height_tmp;
    
        strict_strtoul(argv[3], CMD_VO_ARGS_BASE10, &layer_tmp);  /* 3rd arg */
        strict_strtoul(argv[4], CMD_VO_ARGS_BASE16, &addr_tmp);
        strd = width;
        layer_rect.x = 0;
        layer_rect.y = 0;
        layer_rect.width = width;
        layer_rect.height = height;
        layer = (unsigned int)layer_tmp;
        addr = addr_tmp;
    
        printf("addr:%lu\n",addr);
        ret = start_videolayer(layer, addr, strd, layer_rect);
        if (ret != 0) {
            printf(INSUFFICIENT_PARAM_STR);
            return -1;
        }
    
        printf("decode jpeg!\n");
    
        return 0;
    }
    
    
    
    U_BOOT_CMD(
        decjpgadv,    CFG_MAXARGS_DECJPGADV,	1,  do_jpgdadv,
        "jpgd   - decode jpeg picture.\n",
        "\t- setenv jpeg_addr 0x--------\n"
        "\t- setenv jpeg_size 0x--------\n"
        "\t- setenv vobuf     0x--------\n"
        );
## include/env_default.h
    #ifdef LOGO_JPEG_ADDR
    	"jpeg_addr="	__stringify(LOGO_JPEG_ADDR)	"\0"
    #endif
    
    #ifdef LOGO_JPEG_EMAR_BUF
    	"jpeg_emar_buf="	__stringify(LOGO_JPEG_EMAR_BUF)	"\0"
    #endif
    
    #ifdef LOGO_JPEG_SIZE
    	"jpeg_size="	__stringify(LOGO_JPEG_SIZE)	"\0"
    #endif
    
    #ifdef LOGO_VOBUF
    	"vobuf="	__stringify(LOGO_VOBUF)	"\0"
    #endif

## product/ot_osd/dec/jpegd.c-jpegd.h-jpegd_entry.c
### jpegd.c
    void jpegd_finish_decoding_ex(jpegd_handle handle,unsigned int *width, unsigned int *height,unsigned int *stride)
    {
        unsigned int int_statue;
        unsigned int cnt = 0;
        motion_jpeg_obj *jpegd_hld_ctx = (motion_jpeg_obj *)handle;
    
        while (1) {
            udelay(10); /* 10 delay time */
            int_statue = jpegd_read_int(0);
            if (int_statue & 0x1f) {
                break;
            }
            if (cnt++ > 2000) { /* 2000:Maximum decoding time */
                ot_trace("jpeg decode over time\n");
                break;
            }
        }
    
        jpegd_read_regs(handle, (s_jpgd_regs_type *)JPEGD_REGS_ADDR);
        if (jpegd_hld_ctx->vpu_status.int_dec_finish == 0) {
            printf("hardware decoding error!\n");
        } else {
            if (jpegd_hld_ctx->vpu_config.out_yuv != TD_TRUE) {
                printf("hardware decoding success! %ux%u, stride %u.\n",
                       jpegd_hld_ctx->frame.y_width, jpegd_hld_ctx->frame.y_height, jpegd_hld_ctx->vpu_config.rgb_stride);
                if (width != NULL)
                {
                    *width = jpegd_hld_ctx->frame.y_width;
                }
    
                if (height != NULL)
                {
                    *height = jpegd_hld_ctx->frame.y_height;
                }
    
                if (stride != NULL)
                {
                    *stride = jpegd_hld_ctx->vpu_config.rgb_stride;
                }
    
            } else {
                printf("hardware decoding success! %ux%u, stride %u.\n",
                       jpegd_hld_ctx->frame.y_width, jpegd_hld_ctx->frame.y_height, jpegd_hld_ctx->vpu_config.y_stride);
    
                if (width != NULL)
                {
                    *width = jpegd_hld_ctx->frame.y_width;
                }
    
                if (height != NULL)
                {
                    *height = jpegd_hld_ctx->frame.y_height;
                }
    
                if (stride != NULL)
                {
                    *stride = jpegd_hld_ctx->vpu_config.y_stride;
                }
            }
            
        }
    
        jpegd_clear_int(0);
        jpegd_reset_select(0, TD_TRUE);
    
        return;
    }
### jpegd.h
    void jpegd_finish_decoding_ex(jpegd_handle handle,unsigned int *width, unsigned int *height,unsigned int *stride);
### jpegd_entry.c
    int jpeg_decode_ex(unsigned int format,unsigned int *width, unsigned int *height,unsigned int *stride)
    {
        jpegd_handle handle = TD_NULL;
        int ret;
    
        g_output_format = format;
        if (dcache_status()) {
            flush_dcache_range(g_ot_logo, g_ot_logo + g_jpeg_size);
        }
    
        handle = jpegd_get_handle();
        if (handle == TD_NULL) {
            printf("handle is invalid!");
            return -1;
        }
        ret = jpegd_start_decoding(handle);
        if (ret != TD_SUCCESS) {
            printf("decoding error!");
            return -1;
        }
    
        jpegd_finish_decoding_ex(handle,width,height,stride);
    
        return 0;
    }
# uboot 命令行测试
    setenv jpeg_addr 0x5a000000
    setenv jpeg_size 0x200000  
    setenv vobuf 0x60000000  
    setenv jpeg_emar_buf 0x5b000000
    nand read 0x5a000000 0x5b00000 0x200000
    decjpgadv 0 18 0 0x60000000
