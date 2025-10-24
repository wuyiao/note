path:Y:\sdk\wya\hi3516cv610\Hi3516CV610_SDK_V1.0.2.0\smp\a7_linux\source\mpp\cbb\isp\user\sensor\hi3516cv610

初始化序列的表中
{0x320e,0x0a},
{0x320f,0x8c},

a8c的十进制是2700
对应的cmos.h中修改对应的值
#define SC835HAI_VMAX_VAL_LINEAR 2700    
