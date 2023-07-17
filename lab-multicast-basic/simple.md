## Simple multicast exercise

First, we will set up the resources. We want to make sure that packets destined to the multicast address will be accepted by the NIC of the router. On the router, run:

```
sudo ip maddr add 01:00:5e:0b:6f:0a dev EXPIFACE1
sudo ip maddr add 01:00:5e:0b:6f:0a dev EXPIFACE2
```

Note that the MAC multicast address 01:00:5e:0b:6f:0a in the commands is mapped from the IP multicast address 230.11.111.10, which we will use in this experiment.

Also, on the router, we will install a simple multicast router that accepts static routes. Run:

```
sudo apt-get update
sudo apt-get -y install smcroute
```

We will add a route for the multicast group we will use throughout this section, 230.11.111.10. First, use `ip addr` to check which interface on the router is connected to the 10.10.1.0/24 subnet, and which is connected to the 10.10.2.0/24 subnet. Then, run

```
sudo smcroute -a IFACE1 10.10.1.100 230.11.111.10 IFACE2
```

substituting the correct interface names - the name of the interface connected to the 10.10.1.0/24 subnet for `IFACE1`, and the name of the interface connected to 10.10.2.0/24 subnet for `IFACE2`. 

This will add a multicast route so that traffic from "romeo" (10.10.1.100) to 230.11.111.10 will be forwarded to `IFACE2`. (Note that this simple routing daemon will forward _all_ multicast traffic matching this rule, even if no hosts in the 10.10.2.0/24 subnet are subscribed to the multicast group. A more sophisticated router using PIM and IGMP will be able to selectively forward traffic only when needed.)

Recent Linux kernels are set up so that they will _not_ respond to ICMP messages addressed to a broadcast or multicast address. To change this setting, on each host *and* on the router, run

```
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
```

Before you start, use `ip addr` to capture the network interface configuration of each host in this topology. 


### Exercise - Add a multicast route 

The process for configuring a static multicast route on an end host is very similar to configurating a static unicast route.

On each of the four hosts - romeo, juliet, hamlet, and ophelia - execute 

```
ip route
```

to display the routing table. If there is no entry for the 224.0.0.0/4 subnet, provide a default route for multicast traffic, by:

```
sudo ip route add 224.0.0.0/4 dev EXPIFACE1
```

and save the new routing table.


### Exercise - Default multicast group membership

On each of the four hosts - romeo, juliet, hamlet, and ophelia - execute 

```
ip maddr
```

to show the multicast groups the host is a member of. 

**Lab report**: How many IPv4 multicast groups did each experiment interface belong to on the experiment interface, `EXPIFACE1`? Refer to the [list of multicast group IDs registered with IANA](https://www.iana.org/assignments/multicast-addresses/multicast-addresses.xhtml). Is the multicast group that these hosts belong to a special "well-known" group? What is it used for? Explain the purpose of this specific multicast group, *in your own words*.


### Exercise - MAC addresses for multicast, broadcast, and unicast addresses

In this exercise, we will see how MAC addresses are derived for different types of destination addresses - multicast, broadcast, and unicast.

(Note: in this exercise, we are not at all concerned with which hosts *reply* to the ICMP echo messages. The purpose of this exercise is to look at the destination MAC addresses in the ICMP echo *request* headers.)

Run

```
sudo tcpdump -i EXPIFACE1 -w simple-multicast-mac-$(hostname -s).pcap
```

on romeo to capture all packets. Then, we will generate a few multicast, broadcast, and unicast frames. 

In a second terminal on romeo, run

```
ping -I EXPIFACE1 -c 3 230.11.111.10
```

to generate a multicast frame. Notice that this address gets mapped to the multicast route we added on romeo earlier, but no host is a member of this multicast group. Therefore, you will not get any echo replies, but you can still see the echo requests in your `tcpdump` output. 

Next, run

```
ping -I EXPIFACE1 -c 3 232.139.111.10
```

to generate a multicast frame with a different group address.


Now, we will repeat with broadcast addresses. Run

```
ping -I EXPIFACE1 -c 3 -b 10.10.1.255
```

to send a broadcast frame to the directed broadcast address.

and then, run

```
ping -I EXPIFACE1 -c 3 -b 255.255.255.255
```

to send a broadcast frame to the limited broadcast address.

Finally, run

```
ping -I EXPIFACE1 -c 3 10.10.1.101
```

to send a unicast frame to juliet's address.


Use Ctrl+C to stop the `tcpdump`, and transfer the file to your laptop. Or, you can play it back with

```
tcpdump -env -r simple-multicast-mac-$(hostname -s).pcap
```

**Lab report**: Compare destination MAC addresses of the different types of ICMP echo request frames you captured. Explain how the destination MAC address field is used in each case.

**Lab report**: Use the frames with a multicast destination address to explain how a multicast group address is mapped to a multicast MAC address. For the two multicast frames captured, do they have the same destination MAC address? Why?


### Exercise - Multicast and broadcast ping

In this exercise, we will try to understand in more detail:

1. under what conditions multicast and broadcast packets are forwarded by routers, and
2. under what conditions a host will respond to an ICMP echo request

First, we will send an ICMP echo request to a multicast address and observe the result. Then, we will send to a broadcast address and observe the result.

On juliet, temporarily change the netmask of the experiment interface from 255.255.255.0 to 255.255.0.0, with

```
sudo ip addr add 10.10.1.101/16 dev EXPIFACE1
sudo ip addr del 10.10.1.101/24 dev EXPIFACE1
```

Note that with this change, juliet can still reach hosts on the 10.10.1.0/24 subnet. However, the directed broadcast address that juliet will respond to has changed.

On juliet, hamlet, and ophelia, run

```
sudo tcpdump -i EXPIFACE1 -nv
```

and leave these running.

Then, on romeo, execute

```
ping -c 3 -I EXPIFACE1 224.0.0.1
```

Examine the output to see which hosts reply. Save this output for your lab report. Also save the output in the `tcpdump` sessions.


Then, on romeo, ping the directed broadcast address for the 10.10.1.0/24 subnet, using

```
ping -c 3 -b 10.10.1.255
```

Examine the output to see which hosts reply. Save this output for your lab report. Also save the output in the `tcpdump` sessions.

Use Ctrl+C to stop the `tcpdump`.

**Lab report**: Which hosts replied when the multicast address was pinged in each case, and why? Which hosts replied when the broadcast address was pinged in each case, and why? Explain.




### Exercise - Receiving traffic for a multicast group


In this exercise, we will add multicast group memberships on some hosts, and see how this changes their response to ICMP echo requests for that multicast group.

First, undo the configuration change on juliet:

```
sudo ip addr add 10.10.1.101/24 dev EXPIFACE1
sudo ip addr del 10.10.1.101/16 dev EXPIFACE1
```

and also on juliet, add back the multicast route:

```
sudo ip route add 224.0.0.0/4 dev EXPIFACE1
```


Open two SSH sessions on the router, and use them to capture traffic on *both* router interfaces. In one session, run

```
sudo tcpdump -i EXPIFACE1 -w simple-multicast-EXPIFACE1-group-$(hostname -s).pcap
```

and in the other, run

```
sudo tcpdump -i EXPIFACE2 -w simple-multicast-EXPIFACE2-group-$(hostname -s).pcap
```

On each of the four hosts, run

```
ip maddr
```

and save the output. 

Then, run

```
iperf -s -B 230.11.111.10 -u
```

on juliet _only_, and **stop** any running `iperf` instances on other hosts. 


Open a second SSH session on juliet and run

```
ip maddr
```

Save the output.

Now, on romeo, run

```
ping -I EXPIFACE1 -c 3 230.11.111.10 -t 2
```

and save the output.

Leave the `iperf` server running on juliet, but also run 

```
iperf -s -B 230.11.111.10 -u
```

on hamlet.  On romeo, run

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.

Next, leave the `iperf` servers running on juliet and hamlet, but also run 

```
iperf -s -B 230.11.111.10 -u
```

on ophelia.  On romeo, run

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.

Then terminate all `iperf` servers with Ctrl+C, and on romeo, run 

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.


**Lab report**: Explain which hosts responded to the `ping` in each instance, and why. 

**Lab report**: Show the output of `ip maddr` on juliet, before and after you started the `iperf` server. What IPv4 multicast groups is juliet a member of in each case? Explain.
