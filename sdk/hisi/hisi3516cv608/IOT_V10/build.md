### 
    ifconfig usb0 192.168.7.1 netmask 255.255.255.0 up
###
    ifconfig usb0 192.168.7.2 netmask 255.255.255.0 up
## nc dd命令测试大概网速
### 接收端
    nc -l -p 9999 | dd of=/dev/null bs=1M 2>&1 | tail -1
### 发送端 10G 
    dd if=/dev/zero bs=1M count=10000 | nc 192.168.7.2 9999
### 发送端返回值示例
    10485760000 bytes (9.8GB) copied, 364.445980 seconds, 27.4MB/s
