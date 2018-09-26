## 3.5 A simple bridge experiment

For this experiment, we will deviate slightly from the textbook.

First, carefully read [Operation of a basic Ethernet switch or bridge](https://witestlab.poly.edu/blog/basic-ethernet-switch-operation/) from the beginning, through the section titled "Exercise".

Then, follow the instructions in the "Run my experiment" section of this page to set up the network topology. Annotate the topology diagram from this experiment to show the interface name, MAC address, and IP address on each interface (if it has one). (Make sure it is apparent from your diagram which bridge interface your annotations refer to, as there are four bridge interfaces!) Include this diagram in an appendix to your lab report.

Continue with the "Run my experiment" section up until the subsection titled "Release your resources". (Don't release your resources yet.) 

Scoll down and answer the questions in the "Exercise" subsection for your report.

We will also answer the question posed in the textbook. On node-1 and node-2, run

```
sudo tcpdump -i eth1 -en ip proto 1 -w $(hostname -s)-bridge.pcap
```

Then, in another terminal tab or window, send ten ping requests from node-1 to node-2:

```
ping -v -c 10 10.0.0.2
```

After receiving the tenth echo reply, stop `tcpdump`.

Pick a single ICMP request, and find the packet carrying that ICMP request in both packet captures; the one on node-1 and the one on node-2. (To make sure it is the same packet, check the ICMP sequence number. It should be the same in both.)

In the packet capture on node-1, you will see what this packet looks like as it traverses the link from node-1 to the bridge. In the packet capture on node-2, you will see what this packet looks like as it traverses the link from the bridge to node-2.

**Lab report**: What are the IP and MAC addresses of a packet that went from node-1 to the bridge?

**Lab report**: What are the IP and MAC addresses of a packet that went from the bridge to node-2? 

After completing all this and saving all the output you will need for your lab report, you can delete your resources from this experiment. (The spanning tree experiment will use a different topology.)


