## Exercise - a simple bridge experiment

For this experiment, we will use the same network from [Operation of a basic Ethernet switch or bridge](https://witestlab.poly.edu/blog/basic-ethernet-switch-operation/). After you have completed that experiment through the section titled "Exercise", you will also run the following:


On *both* romeo and juliet, run

```
sudo tcpdump -i $exp_iface -w $(hostname -s)-bridge.pcap
```

Then, in another terminal tab or window, send echo requests from romeo to juliet:

```
ping -c 3 10.0.0.2
```

After receiving the third echo reply, stop both `tcpdump` processes. You can play back a summary of your packet capture with

```
tcpdump -en -r $(hostname -s)-bridge.pcap
```

on each host, and you can use `scp` to transfer them to your laptop for further analysis. 


Pick a single ICMP request, and find the packet carrying that ICMP request in both packet captures; the one on romeo and the one on juliet. (To make sure it is the same packet, check the ICMP sequence number. It should be the same in both.)

In the packet capture on romeo, you will see what this packet looks like as it traverses the link from romeo to the bridge. In the packet capture on juliet, you will see what this packet looks like as it traverses the link from the bridge to juliet.

**Lab report**: What are the source and destination IP and MAC addresses of a packet that went from romeo to the bridge? Show the annotated screenshot from your `tcpdump` replay on romeo, with the source and destination IP address and source and destination MAC address clearly labeled. Does romeo put the bridge's MAC address or juliet's MAC address in the destination address field of the Ethernet header?

**Lab report**: What are the source and destination IP and MAC addresses of the same packet when it goes from the bridge to juliet? Show the annotated screenshot *of the same packet* from your `tcpdump` replay on juliet, with the source and destination IP address and source and destination MAC address clearly labeled. Does the bridge modify the source or destination MAC address in the Ethernet header?

After completing all this and saving all the output you will need for your lab report, you can delete your resources from this experiment. 
