## 2.6 Network interface exercises

For this experiment, we will use a topology with four connected workstations on a single network segment, with IP addresses configured as follows:

* romeo: 10.10.0.100
* juliet: 10.10.0.101
* hamlet: 10.10.0.102
* ophelia: 10.10.0.103

each with a netmask of 255.255.255.0. 

To set up this topology in the GENI Portal, create a slice, click on "Add Resources", and load the RSpec from the following URL: [https://raw.githubusercontent.com/ffund/tcp-ip-essentials/master/lab2/lab2-single-segment-rspec.xml](https://raw.githubusercontent.com/ffund/tcp-ip-essentials/master/lab2/lab2-single-segment-rspec.xml)

Then bind to an InstaGENI site and reserve your resources. Wait for them to become available for login ("turn green" on your canvas) and then SSH into each, using the details given in the GENI Portal.

Before you start, use `ifconfig -a` to capture the network interface configuration of each host in this topology. Draw a diagram of the topology, and label each network interface with its name, IP address, and MAC address. Include this diagram in your lab report.

**Lab report**: Upload your network diagram for this topology.


### Exercise 2 - Loopback interface

In this exercise, you will see how processes *on the same host* can communicate with each other using the loopback interface.

On the "romeo" host, run

```
sudo tcpdump -n -i eth1 icmp
```

and leave it running. Open a second terminal window on "romeo". Run

```
ping -c 3 127.0.0.1
```

from the second window to send three ICMP requests to the address 127.0.0.1.

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.

Next, run

```
sudo tcpdump -n -i eth1 icmp
```

again, and leave it running. On the second terminal window on "romeo", run

```
ping -c 3 10.10.0.100
```

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.

Now, we will repeat these steps, but with the `tcpdump` running on the loopback interface. Run

```
sudo tcpdump -n -i lo icmp
```

on "romeo", and leave it running. On the second terminal window on "romeo", run

```
ping -c 3 127.0.0.1
```

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.

Finally, run

```
sudo tcpdump -n -i lo icmp
```

again, and leave it running, and on the second terminal window on "romeo", run

```
ping -c 3 10.10.0.100
```

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.


**Lab report**: Show the output of the `tcpdump` in each case. Which network interface carries traffic from the host *to itself* when that traffic is sent to the 127.0.0.1 address? Which network interface carries traffic from the host *to itself* when that traffic is sent to the 10.10.0.100 address? Explain how the evidence from the `tcpdump` output supports your answer.

Once you are done with this part of the lab , proceed to the [next part](2-7-arp.md)
