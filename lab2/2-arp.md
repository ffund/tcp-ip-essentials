## ARP exercises

In these exercises, we will consider communication between hosts in the same network segment. To put a packet on the network segment, the sending host wraps the packet in a Layer 2 header, which must include the destination MAC address. The sending host needs to know the receiver’s MAC address before it can try to send the packet. If it doesn’t know the MAC address, it will try to find out using ARP. 


### Exercise - ARP

On each host, run

```
arp -i eth1 -n
```

to see the entire ARP table for the `eth1` interface (if there are any entries).  If there are no ARP entries, the output will say

```
arp: in X entries no match found.
```

which is OK! Observe that if there *are* any ARP entries, all the IP addresses displayed are on the same network segment. 

*If* the "juliet" host (10.10.0.101) is already listed in an ARP table, then delete it with

```
sudo arp -d 10.10.0.101
```

Then, run 


```
arp -i eth1 -n
```

again, and save the ARP tables from each host for your lab report.


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

Run 

```
arp -i eth1 -n
```

each host, again. Save the new ARP tables for your lab report.


The `tcpdump` application will have saved a new file named "romeo-arp.pcap" in your home directory on the "romeo" node. You can "play back" a summary of the capture file in the terminal using


```
tcpdump -enX -r $(hostname -s)-arp.pcap
```


> **Note**: You'll see that a new line is added to juliet's ARP table with romeo's address, even though "juliet" did not send an ARP request to resolve romeo's address! When "juliet" receives and responds to an ARP request for its own address, it will also update its ARP table to include the IP address and MAC address of the host that _sent_ the ARP request. 

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


**Lab report**: When an ARP request and ARP reply appear on a network segment, which hosts on the network segment will add the *target MAC address of the ARP request* to their ARP table? Which hosts on the network segment will add the *source MAC address of the ARP request* to their ARP table? Use the ARP tables you captured to explain your answer.

### Exercise - ARP for a non-existent host

For this experiment, you will need *three* terminal windows on the "romeo" host.

On the "romeo" host, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-eth1-nonexistent.pcap
```

In a second terminal window on "romeo", run

```
sudo tcpdump -i lo -w $(hostname -s)-lo-nonexistent.pcap icmp
```

to capture ICMP traffic on the loopback interface (i.e. ICMP messages sent from romeo to itself).

Then, in a third terminal window on "romeo", run

```
ping -c 1 10.10.0.200
```

Note that there is no host with this IP address in your network configuration.


Wait for it to finish. Terminate both `tcpdump` processes with Ctrl+C. 


The message "Destination Host Unreachable" in the `ping` output reflects that an ICMP message of type `Destination Unreachable` with code `Host Unreachable` was received! This message is sent by the host *to itself* when it cannot resolve an IP address (e.g. due to ARP timeout). 

"Play back" a summary of the loopback capture file in the terminal using

```
tcpdump -enX -r $(hostname -s)-lo-nonexistent.pcap
```

Observe this message in the loopback interface capture.

Also, "play back" a summary of the Ethernet capture file in the terminal using

```
tcpdump -enX -r $(hostname -s)-eth1-nonexistent.pcap
```

You can also use `scp` to transfer the packet captures to your laptop, and open them in Wireshark to see these packets in more detail.


**Lab report**: Show the summary `tcpdump` output from the Ethernet interface, and use it to answer the following questions: 

* In the previous exercise, after sending an ARP request and receiving a reply, "romeo" sends an ICMP echo request. In this exercise, is an ICMP echo request ever sent? Why or why not?
* From the `tcpdump` output, describe how the ARP timeout and retransmission were performed. How many attempts were made to resolve a non-existing IP address? How much time separates each attempt?

**Lab report**: Show the ICMP message you captured on the loopback interface, and answer these questions:

* What is the value of the **type** field and the **code** field in the ICMP message?