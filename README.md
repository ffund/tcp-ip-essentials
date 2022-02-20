# TCP/IP Essentials: A Lab-Based Approach

This repository includes the exercises in the textbook [TCP/IP Essentials: A Lab-Based Approach](https://www.amazon.com/TCP-IP-Essentials-Lab-Based-Approach/dp/052160124X), adapted to use the GENI testbed rather than an in-house lab.

This version of the lab materials is for the **Spring 2022** semester.

## Table of contents

### Set up your lab account

* [Prepare your workstation](lab0/1-0-prepare-workstation.md)
* [Set up an account on GENI](lab0/1-1-setup-account.md)
* [Reserve a simple network on GENI](lab0/1-2-reserve-and-login.md)
* [Inspect network interfaces](lab0/1-3-network-interfaces.md)
* [Working on remote hosts](lab0/1-4-working-on-remote-hosts.md)
* [Save data and delete resources on GENI](lab0/1-5-delete-resources.md)

### Linux

* [Learning the basics of the Bash shell](lab1/1-1-linux-shell.md)
* [Navigating the filesystem](lab1/1-2-linux-navigating.md)
* [Working with files and directories](lab1/1-3-linux-files-directories.md)
* [Manipulating output of a command](lab1/1-4-linux-manipulate.md)
* [Using `tcpdump` and Wireshark](lab1/1-5-tcpdump-wireshark.md)
* [Loopback interface](lab1/1-x-loopback.md)

### ARP, Bridges 

* [Reserve resources for ARP experiment](lab2/2-reserve-resources)
* [ARP exercises](lab2/2-arp)
* [Operation of a basic Ethernet switch or bridge](https://witestlab.poly.edu/blog/basic-ethernet-switch-operation)
* [A simple bridge experiment](lab3/3-5-simple-bridge.md)

### Spanning tree protocol 
* [Background](lab-stp/stp-background)
* [Reserve resources](lab-stp/stp-reserve)
* [Set up bridge interfaces](lab-stp/stp-setup)
* [Create a broadcast storm](lab-stp/stp-broadcast)
* [Before beginning the spanning tree protocol](lab-stp/stp-id)
* [Observe the spanning tree protocol](lab-stp/stp-configure)
* [Test the loop-free topology](lab-stp/stp-loopfree)
* [Adapt to changes in the topology](lab-stp/stp-change)

### Static routing

* [4.5 A simple router experiment](lab4/el5373-lab4-45.md)

### Dynamic routing

* [4.6 RIP exercises](lab4/el5373-lab4-46.md)
* [4.7 Routing experiments with ICMP](lab4/el5373-lab4-47.md)

### UDP and its applications


* [5.5 Using `iperf3`](lab5/el5373-lab5-55.md)
* [5.6 UDP Exercises with Datagram Sizes](lab5/el5373-lab5-56.md)
* [5.8 Exercises with FTP and TFTP](lab5/el5373-lab5-58.md)
* [UDP as a connectionless transport protocol](lab5/el5373-lab5-5z.md)


### TCP study

* [6.7 Exercises on TCP connection control](lab6/el5373-lab6-67.md)
* [6.8 Exercises on TCP interactive data flow](lab6/el5373-lab6-68.md)
* [6.9 Exercises on TCP bulk data flow](lab6/el5373-lab6-69.md)
* [6.10 Exercises on TCP timers and retransmission](lab6/el5373-lab6-610.md)
* [6.11 Other TCP exercises](lab6/el5373-lab6-611.md)
* Optional extra experiment: [TCP congestion control basics](https://witestlab.poly.edu/blog/tcp-congestion-control-basics/)

### Multicast and realtime service

* [7.4 Simple multicast exercise](lab7/el5373-lab7-74.md)


### The Web, DHCP, NTP and NAT

* [8.7 HTTP exercises](lab8/el5373-lab8-87.md)
* [8.9 NTP exercises](lab8/el5373-lab8-89.md)
* Optional extra experiment: [Basic home gateway services: DHCP, DNS, NAT](https://witestlab.poly.edu/blog/basic-home-gateway-services-dhcp-dns-nat/)

### Network management and security

* [9.9 SNMP exercises](lab9/el5373-lab9-909.md)
* [9.10 Exercises on secure applications](lab9/el5373-lab9-910.md)
* [9.12 Exercises on firewalls](lab9/el5373-lab9-912.md)
* Optional extra experiment: [DNS spoofing on a LAN](https://witestlab.poly.edu/blog/redirect-traffic-to-a-wrong-or-fake-site-with-dns-spoofing-on-a-lan/)
