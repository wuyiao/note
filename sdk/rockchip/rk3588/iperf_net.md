# work_iperf.bat通过adb把iperf3和libiperf.so发到主板上
服务端

    iperf3 -s
应用端

    ./iperf3.exe -c 192.168.2.2 -t 60 -i 10
    ./iperf3.exe -c 192.168.2.137 -u -b 1G -t 60 -i 10 
