work_iperf.bat通过adb把iperf3和libiperf.so发到主板上
服务端iperf3 -s
应用端iperf3.exe -c 192.168.2.2 -t 60 -i 10
