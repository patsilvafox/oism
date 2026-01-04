# Multicast Traffic Testing

## Flow 1

### Sender - HostA1

    Source:
        iperf -c 239.0.10.101 -u -b 250K -T 100 -t 3600 -i 1
        
    Receiver:
        iperf -s -u -B 239.0.10.101 -i 1

## Flow 2

### Sender - HostA2

    Source:
        iperf -c 239.0.20.101 -u -b 250K -T 100 -t 3600 -i 1
        
    Receiver:
        iperf -s -u -B 239.0.20.101 -i 1

## Flow 3

### Sender HostA3

    Source:
        iperf -c 239.0.30.101 -u -b 250K -T 100 -t 3600 -i 1
        
    Receiver:
        iperf -s -u -B 239.0.30.101 -i 1

## Flow 4

### Sender PD1-H1

    Source:
        iperf -c 239.201.10.101 -u -b 250K -T 100 -t 3600 -i 1
        
    Receiver:
        iperf -s -u -B 239.201.10.101 -i 1

## Flow 5

### Sender PD1-H3

    Source:
        iperf -c 239.201.30.101 -u -b 250K -T 100 -t 3600 -i 1
        
    Receiver:
        iperf -s -u -B 239.201.30.101 -i 1
