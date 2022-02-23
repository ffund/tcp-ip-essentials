## Exercises with a routing table at end host

You may have assumed that a routing table is only relevant when there are routers connecting multiple networks; but routing tables are also used at end hosts to determine how to send packets, even on a single segment!

In this exercise, we will see how a host uses its routing table every time it sends an IP packet - even before ARP is used! We'll also see how the ARP table and routing table together determine what happens to that packet.

We will observe all of the outcomes described in this flow chart of ARP table/routing table interaction:

![](arp-overall.svg)



### Exercise - send via directly connected route

In this exercise, we'll explore the part of the diagram highlighted in pink:

![](arp-direct.svg)


These first three scenarios are a review of the ARP exercises you've done in a previous lab assignment. 

In a previous experiment, we saw that when a host needs to send an IP packet, it uses ARP to resolve the destination IP address to a MAC address. We observed three possible outcomes of this process:

* a host already has the destination IP address in its ARP table. In this case, it will directly send the IP packet with the destination host's MAC address (from the ARP table) in the destination address field of the Layer 2 header.
* a host does _not_ already have the destination IP address in its ARP table, it sends an ARP request to resolve the address, and it receives an ARP reply. Then, it will send the IP packet with the destination host's MAC address (from the ARP reply) in the destination address field of the Layer 2 header.
* a host does _not_ already have the destination IP address in its ARP table, and it sends an ARP request to resolve the address, but does _not_ receive an ARP reply. Then, it will send itself an ICMP Destination Unreachable: Host Unreachable message, indicating that it cannot reach the destination IP address. The IP packet is not sent.

However, these three scenarios only occur if the host _first_ checks its routing table, and determines that the route that matches this destination address is a **directly connected** route.

A **directly connected** route is one where:

* the `G` flag is _not_ set
* there is no gateway specified

When a network interface on a device is configured with an IP address and subnet mask, a directly connected route is *automatically* added to the routing table on that device. This automatic rule applies to all destination addresses in the same subnet as the network interface.

Let's try this now. The IP address and netmask have already been configured on our hosts, but we can set them again, just to learn how. To set the IP address and/or netmask of a given interface on our hosts, the _general_ syntax we will use is:

```
sudo ifconfig INTERFACE IP-ADDRESS netmask NETMASK
```

substituting appropriate values for `INTERFACE` name, `IP-ADDRESS`, and `NETMASK`. 


On juliet, run

```
sudo ifconfig eth1 10.10.0.101 netmask 255.255.255.0
```

to configure the `eth1` interface with the IP address 10.10.0.101 and subnet mask 255.255.255.0. Note that the _network address_, computed by applying the logical AND operation to the IP address and subnet mask, is 10.10.0.0.

Then, run

```
route -n
```

on juliet. You can ignore all of the rules that apply to the control interface `eth0`; identify the directly connected route that applies to the destination 10.10.0.0 with netmask 255.255.255.0, and routes this traffic through the `eth1` interface. This rule matches the address range 10.10.0.0-10.10.0.255. Note that this rule has no `G` flag set and no gateway, i.e. `0.0.0.0` in the gateway field.


The `route` tool is being depracated in favor of the newer and more powerful `ip route`, so we'll also learn how to read its routing table format. Run

```
ip route show dev eth1
```

to see the routing table rules for the `eth1` interface. Note that the rule includes `scope link`; this means that it is for a destination address on the local network (directly connected), not via gateway.

Save the routing table (in either format) for your lab report.

#### Scenario 1


For this exercise, you will need two terminal sessions on the juliet host.

On juliet, run

```
arp -i eth1 -n
```

to see the ARP table for the `eth1` interface. *If* the romeo host (10.10.0.100) is already listed in the ARP table, delete it with

```
sudo arp -d 10.10.0.100
```

and then run


```
arp -i eth1 -n
```

again. When the ARP table is empty, save this output for your lab report.

Then, on juliet, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-direct-resolve-arp.pcap
```

in one terminal, and leave this running. In a second terminal on juliet, run


```
ping -c 1 10.10.0.100
```

to send an ICMP echo request to romeo.

After the reponse is returned, save the `ping` output for your lab report. Then, stop the `tcpdump` and play it back with 

```
tcpdump -enX -r $(hostname -s)-direct-resolve-arp.pcap
```

#### Scenario 2

For this exercise, you will need two terminal sessions on the juliet host.

On juliet, run 


```
arp -i eth1 -n
```

again, and verify that romeo's address is still in the ARP table. Save this output for your lab report.


Then, on juliet, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-direct-table-arp.pcap
```

in one terminal, and leave this running. In a second terminal on juliet, run


```
ping -c 1 10.10.0.100
```

to send an ICMP echo request to romeo.

After the reponse is returned, save the `ping` output for your lab report. Then, stop the `tcpdump` and play it back with 

```
tcpdump -enX -r $(hostname -s)-direct-table-arp.pcap
```

#### Scenario 3

For this experiment, you will need *three* terminal sessions on the juliet host.

On the juliet host, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-direct-nonexistent.pcap
```

In a second terminal window on juliet, run

```
sudo tcpdump -i lo -w $(hostname -s)-direct-lo-nonexistent.pcap icmp
```

to capture ICMP traffic on the loopback interface (i.e. ICMP messages sent from juliet to itself).

Then, in a third terminal window on juliet, run

```
ping -c 1 10.10.0.200
```

Note that there is no host with this IP address in your network configuration.

Wait for it to finish, then save the `ping` output for your lab report. Terminate both `tcpdump` processes with Ctrl+C. 

Play back a summary of the packet captures using

```
tcpdump -enX -r $(hostname -s)-direct-nonexistent.pcap
```

and 

```
tcpdump -enX -r $(hostname -s)-direct-lo-nonexistent.pcap icmp
```

### Exercise - no matching route

In this exercise, we'll explore the part of the diagram highlighted in pink:

![](arp-none.svg)

The aim of this exercise is to observe what happens when you try to send IP packets to a network that your host doesn't know how to reach. We are going to trigger a "network is unreachable" error message. This message occurs when there is no route in the host's routing table that describes how to reach a particular destination. 


#### Scenario 4

On juliet, run

```
route -n
```

and


```
ip route show dev eth1
```

and save the output for your lab report.  Also run

```
sudo arp -n -i eth1
```

and save the output.

Then, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-no-route.pcap
```

In a second window on juliet, run

```
ping -c 1 10.10.10.200
```

Note that this destination address does not match any rule in the routing table.

Wait for this to finish, then save the `ping` output for your lab report. Then, stop the `tcpdump` with Ctrl+C. Play it back with 

```
tcpdump -enX -r $(hostname -s)-no-route.pcap
```

### Exercise - send via gateway

Finally, we'll explore the part of the diagram highlighted in pink:

![](arp-gateway.svg)

When a host finds that a destination address is _not_ local, but needs to be forwarded by a gateway, it will find out the gateway's MAC address (in the _local_ subnet) to use as the destination address in the MAC header.


#### Scenario 5


For this exercise, you will need two terminal sessions on the juliet host.

On juliet, run

```
arp -i eth1 -n
```

to see the ARP table for the `eth1` interface. *If* the gateway (10.10.0.1) is already listed in the ARP table, delete it with

```
sudo arp -d 10.10.0.1
```

and then run


```
arp -i eth1 -n
```

again. When the ARP table is empty, save this output for your lab report.

Then, on juliet, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-direct-resolve-arp.pcap
```

in one terminal, and leave this running. In a second terminal on juliet, run


```
ping -c 1 10.10.100.1
```

to send an ICMP echo request to the gateway interface that is _not_ in this subnet.

After the reponse is returned, save the `ping` output for your lab report. Then, stop the `tcpdump` and play it back with 

```
tcpdump -enX -r $(hostname -s)-direct-resolve-arp.pcap
```

#### Scenario 6

For this exercise, you will need two terminal sessions on the romeo host.

On romeo, run 


```
arp -i eth1 -n
```

again, and verify that juliet's address is still in the ARP table. Save this output for your lab report.


Then, on romeo, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-direct-table-arp.pcap
```

in one terminal, and leave this running. In a second terminal on juliet, run


```
ping -c 1 10.10.0.100
```

to send an ICMP echo request to romeo.

After the reponse is returned, save the `ping` output for your lab report. Then, stop the `tcpdump` and play it back with 

```
tcpdump -enX -r $(hostname -s)-direct-table-arp.pcap
```

#### Scenario 7

For this experiment, you will need *three* terminal sessions on the romeo host.

On the romeo host, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-direct-nonexistent.pcap
```

In a second terminal window on romeo, run

```
sudo tcpdump -i lo -w $(hostname -s)-direct-lo-nonexistent.pcap icmp
```

to capture ICMP traffic on the loopback interface (i.e. ICMP messages sent from romeo to itself).

Then, in a third terminal window on romeo, run

```
ping -c 1 10.10.0.200
```

Note that there is no host with this IP address in your network configuration.

Wait for it to finish, then save the `ping` output for your lab report. Terminate both `tcpdump` processes with Ctrl+C. 

Play back a summary of the packet captures using

```
tcpdump -enX -r $(hostname -s)-direct-nonexistent.pcap
```

and 

```
tcpdump -enX -r $(hostname -s)-direct-lo-nonexistent.pcap icmp
```