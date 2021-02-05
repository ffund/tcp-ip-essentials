## 2.7 ARP exercises

In the exercises on this page, we will see how networked devices use ARP to learn MAC addresses of other devices on the same network segment. 

Each network interface on a host or a router has a MAC address associated with it. This is a fixed address! It does not change even if the interface detaches from one network and attached to a different network.

When a frame is *transmitted* on a network segment, the sender puts the destination's MAC address into the link-layer header of the frame and then sends the
frame into the LAN. When a frame is *received* by a network interface, it checks to see whether the destination MAC address in the frame header matches its own MAC address. If it matches, the enclosed packet will be passed up the protocol stack; if not, the frame is discarded.

Higher layer protocols, however, are only aware of the *global* destination of a packet, which is its network layer address (IP address). Only the link layer, which is concerned with delivery of the packet to the next destination on the *local* network, needs its destination MAC address! When a packet is passed down the protocol stack from higher layers to the link layer, it has a destination IP address but not a MAC address. How does the link layer determine the MAC address for the host with a particular destination IP address?

ARP is used to resolve IP addresses to MAC addresses. Each host and router maintains an ARP table with all known IP address-MAC address associations. When sending a frame, it will first check this table to see if the MAC address for the destination IP address is already known. If the destination MAC address is *not* already in the sending host's ARP table, it will send an ARP request to try and discover the destination MAC address.

### Exercise 4 - ARP

On the "romeo" host, run

```
arp -i eth1 -n
```

to see the entire ARP table for the `eth1` interface (if there are any entries).  (If there are no ARP entries, that's OK.) Observe that if there *are* any ARP entries, all the IP addresses displayed are on the same subnet.

If the "juliet" host (10.10.0.101) is already listed in the ARP table, then delete it with

```
sudo arp -d 10.10.0.101
```

Then, run 


```
arp -i eth1 -n
```

again, and save the ARP table for your lab report.


On "romeo", run

```
sudo tcpdump -i eth1 -w $(hostname -s)-arp.pcap
```

Leave this running. Then, open a second SSH session to "romeo", and in that session, run

```
ping -c 1 10.10.0.101
```

to send an ICMP echo request to 10.10.0.101 ("juliet").

Terminate `tcpdump` with Ctrl+C. 

The `tcpdump` application will have saved a new file named "romeo-arp.pcap" in your home directory on the "romeo" node. You can "play back" a summary of the capture file in the terminal using


```
tcpdump -enX -r $(hostname -s)-arp.pcap
```


Run 

```
arp -i eth1 -n
```

on the "romeo" host to see a new line added to the ARP table. Save the new ARP table for your lab report.

Next, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-no-arp.pcap
```

on "romeo", and in a second terminal on "romeo", run

```
ping -c 1 10.10.0.101
```

again. Terminate `tcpdump` with Ctrl+C. Then "play back" a summary of the capture file in the terminal using

```
tcpdump -enX -r $(hostname -s)-no-arp.pcap
```


Use `scp` to transfer both packet capture files to your laptop. Then, you can open them in Wireshark for further analysis.


**Lab report**: Show the summary `tcpdump` output for both packet captures. In the first case, an ARP request was sent and a reply was received before the ICMP echo request was sent. In the second case, no ARP request was sent before the ICMP echo request. Why? Show evidence from the output of the `arp` commands to support your answer.

**Lab report**: From the first saved `tcpdump` output, answer the following questions:

* What is the target IP address in the ARP request?
* At the MAC layer, what is the destination Ethernet address of the frame carrying the ARP request? Why?
* What is the frame type field in the Ethernet frame?
* Of the four hosts on your network segment, which host sends the ARP reply? Why?

### Exercise 5 - ARP for a non-existent host

On the "romeo" host, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-nonexistent.pcap
```

Then, in a second terminal window on "romeo", run

```
ping -c 1 10.10.0.200
```

Note that there is no host with this IP address in your network configuration.


Wait for it to finish. Terminate `tcpdump` with Ctrl+C. Then "play back" a summary of the capture file in the terminal using

```
tcpdump -enX -r $(hostname -s)-nonexistent.pcap
```

You can also use `scp` to transfer the packet capture to your laptop, and open it in Wireshark.

**Lab report**: Show the summary `tcpdump` output, and use it to answer the following questions: In the previous exercise, after sending an ARP request and receiving a reply, "romeo" sends an ICMP echo request. In this exercise, is an ICMP echo request ever sent? Why or why not?

**Lab report**: Show the summary `tcpdump` output, and use it to answer the following questions: From the `tcpdump` output, describe how the ARP timeout and retransmission were performed. How many attempts were made to resolve a non-existing IP address? How much time separates each attempt?

Once you are done with this part of the lab , proceed to the [next part](2-9-ip-subnet.md)
