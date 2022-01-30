## ARP exercises

In these exercises, we will consider communication between hosts in the same network segment. To put a packet on the network segment, the sending host wraps the packet in a Layer 2 header, which must include the destination MAC address. So the sending host needs to know the receiver’s MAC address before it can try to send the packet. If it doesn’t know the MAC address, it will try to find out using ARP. 


### Exercise - ARP

On the "romeo" host, run

```
arp -i eth1 -n
```

to see the entire ARP table for the `eth1` interface (if there are any entries).  If there are no ARP entries, the output will say

```
arp: in X entries no match found.
```

which is OK! Observe that if there *are* any ARP entries, all the IP addresses displayed are on the same subnet. 

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

> **Note**: If you observe the output of `arp -i eth1 -n` on the "juliet" host, you'll see that a new line is added to the ARP table with romeo's address, even though "juliet" did not send an ARP request to resolve romeo's address! When "juliet" receives and responds to an ARP request for its own address, it will also update its ARP table to include the IP address and MAC address of the host that sent the ARP request. 

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

> **Note**: In your packet capture, depending on the timing of your experiment, you may observe an ARP request and reply *after* the ICMP echo request and response are exchanged. And if you look closely at this unexpected ARP request, you may notice that the destination MAC address is not the broadcast address (as with a "regular" ARP request, when the sender needs to resolve an IP address and does not know the associated MAC address) - this ARP request has a unicast destination MAC address. This type of ARP request is an ARP *poll*. ARP polls can be sent by a host that wants to confirm the validity of an existing entry in their ARP table, for example an entry that might be getting a little bit old.



**Lab report**: Show the summary `tcpdump` output for both packet captures. In the first case, an ARP request was sent and a reply was received before the ICMP echo request was sent. In the second case, no ARP request was sent before the ICMP echo request. Why? Show evidence from the output of the `arp` commands to support your answer.

**Lab report**: From the first saved `tcpdump` output, answer the following questions:

* What is the target IP address in the ARP request?
* At the MAC layer, what is the destination Ethernet address of the frame carrying the ARP request? Why?
* What is the frame type field in the Ethernet frame?
* Of the four hosts on your network segment, which host sends the ARP reply? Why?

### Exercise - ARP for a non-existent host

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
