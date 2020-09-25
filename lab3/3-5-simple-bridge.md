## 3.5 A simple bridge experiment

For this experiment, we will use the same network from [Operation of a basic Ethernet switch or bridge](https://witestlab.poly.edu/blog/basic-ethernet-switch-operation/). After you have completed that experiment through the section titled "Exercise", you will also run the following:


On *both* node-1 and node-2, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-bridge.pcap
```

Then, in another terminal tab or window, send echo requests from node-1 to node-2:

```
ping -c 3 10.0.0.2
```

After receiving the third echo reply, stop both `tcpdump` processes. You can play back a summary of your packet capture with

```
tcpdump -en -r $(hostname -s)-bridge.pcap
```

on each host, and you can use `scp` to transfer them to your laptop for further analysis. 


Pick a single ICMP request, and find the packet carrying that ICMP request in both packet captures; the one on node-1 and the one on node-2. (To make sure it is the same packet, check the ICMP sequence number. It should be the same in both.)

In the packet capture on node-1, you will see what this packet looks like as it traverses the link from node-1 to the bridge. In the packet capture on node-2, you will see what this packet looks like as it traverses the link from the bridge to node-2.

**Lab report**: What are the sou IP and MAC addresses of a packet that went from node-1 to the bridge? Show the annotated screenshot from your `tcpdump` replay on node-1, with the source and destination IP address and source and destination MAC address clearly labeled. Does node-1 put the bridge's MAC address or node-2's MAC address in the destination address field of the Ethernet header?

**Lab report**: What are the IP and MAC addresses of a packet that went from the bridge to node-2? Show the annotated screenshot *of the same packet* from your `tcpdump` replay on node-2, with the source and destination IP address and source and destination MAC address clearly labeled. Does the bridge modify the source or destination MAC address in the Ethernet header?

After completing all this and saving all the output you will need for your lab report, you can delete your resources from this experiment. (The spanning tree experiment will use a different topology.)


