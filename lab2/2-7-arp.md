## 2.7 ARP exercises

For this experiment, we will reuse the same network as in the previous experiment. 

### Exercise 4

On the "romeo" host, run

```
arp -i eth1 -n
```

to see the entire ARP table for the `eth1` interface (if there are any entries). Observe that all the IP addresses displayed are on the same subnet.

We will generate an ARP request for the "juliet" host. If the "juliet" host (10.10.0.101) is already listed in the ARP table, then delete it with

```
arp -d 10.10.0.101
```

Save the ARP table for your lab report. (If there are no ARP entries, that's OK.)

On "romeo", run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-arp.pcap
```

Leave this running. Then, open a second SSH session to "romeo", and in that session, run

```
ping -c 3 10.10.0.101
```
OA
Then, terminate the `tcpdump` application with Ctrl+C.

The `tcpdump` application will have saved a new file named "romeo-arp.pcap" in your home directory on the "romeo" node. Use `scp` to transfer this file to your laptop. Then, use [Wireshark](https://www.wireshark.org/download.html) to open this file and observe the first few lines of the packet trace to see how ARP is used to resolve an IP address.

Run 

```
arp -i eth1 -n
```

on the "romeo" host to see a new line added to the ARP table. Save the new ARP table for your lab report.

**Lab report**: From the saved `tcpdump` output, explain how ARP operates. Also answer the following questions:

* What is the target IP address in the ARP request?
* At the MAC layer, what is the destination Ethernet address of the frame carrying the ARP request?
* What is the frame type field in the Ethernet frame?
* Who sends the ARP reply?

### Exercise 5

On the "romeo" host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-nonexistent.pcap
```

Then, in a second terminal window on "romeo", run

```
telnet 10.10.0.200
```

Note that there is no host with this IP address in your network configuration.

After `telnet` gives up, stop the `tcpdump` with Ctrl+C. Use `scp` to transfer the new packet capture to your laptop, and open it in Wireshark.

**Lab report**: From the `tcpdump` output, describe how the ARP timeout and retransmission were performed. 

**Lab report**: How many attempts were made to resolve a non-existing IP address?

### Exercise 7

A host can also send a "gratuitous ARP" to make other hosts in the network aware of its IP address and MAC address. This has several uses: for detecting duplicate IP addresses on a network, for updating MAC address tables on the network after a device change (e.g. change from a faulty network interface card to a backup NIC on the same device), and generally to notify hosts about MAC address/IP address mappings in advance so they don't have to ask.

We will generate a gratuitous ARP as follows. First, we need to configure our hosts to accept gratuitous ARPs for all addresses. On each host in your topology ("romeo", "juliet", "hamlet", and "ophelia"), run

```
sudo sysctl -w net.ipv4.conf.all.arp_accept=1
```

Then, check the ARP table entries for each host to see if it has an entry for "hamlet". If any hosts ("romeo", "juliet", or "ophelia") have an entry for hamlet, delete it. Then check the ARP tables again and save a copy of each one.

On romeo, start a tcpdump running to capture packets:

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-gratuitous.pcap
```

Then, on "hamlet", send four gratuitous ARP messages on the network with

```
sudo arping -c 4 -U 10.10.0.102 -I eth1
```

Then stop the `tcpdump` with Ctrl+C and transfer the file to your laptop with `scp`. Open it in Wireshark to inspect the captured data.

Use

```
arp -i eth1 -n
```

to view and save the ARP table entries on the other three hosts ("romeo, juliet, or ophelia). 

**Lab report**: What is the purpose gratuitous ARP?

**Lab report**: Include a screenshot from Wireshark showing the ARP header of a gratuitous ARP. List the sender IP address, target IP address, sender MAC address, and target MAC address of the gratuitous ARP that you showed.

**Lab report**: Is there a reply to the gratuitous ARP? Why or why not?



