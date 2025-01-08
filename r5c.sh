#!/bin/sh

for dev in /sys/class/net/eth*; do
    echo "Interface: $dev"
    for q in ${dev}/queues/tx-*; do
        echo "  TX Queue: $q, XPS CPUs: $(cat $q/xps_cpus)"
    done
    for q in ${dev}/queues/rx-*; do
        echo "  RX Queue: $q, RPS CPUs: $(cat $q/rps_cpus)"
    done
done

# Save the output of /proc/interrupts in a variable
interrupts=$(cat /proc/interrupts)

# Extract the numbers associated with eth1-0 and eth2-0 using grep and awk
eth0_0=$(echo "$interrupts" | grep "eth0-0" | awk '{print $1}' | tr -d ':')
eth1_0=$(echo "$interrupts" | grep "eth1-0" | awk '{print $1}' | tr -d ':')

echo "CPU Affinity for ETH0 2.5Gbps LAN is $(cat /proc/irq/"$eth0_0"/smp_affinity)"
echo "CPU Affinity for ETH1 2.5Gbps WAN is $(cat /proc/irq/"$eth1_0"/smp_affinity)"
echo "CPU cores assigned to ETH0 queue rx-0 is: $(cat /sys/class/net/eth0/queues/rx-0/rps_cpus)"
echo "CPU cores assigned to ETH1 queue rx-0 is: $(cat /sys/class/net/eth1/queues/rx-0/rps_cpus)"
echo "CPU cores assigned to PPPoE queue rx-0 is: $(cat /sys/class/net/pppoe-wan/queues/rx-0/rps_cpus)"
