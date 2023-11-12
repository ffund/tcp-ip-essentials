## Simple multicast exercise

First, we will set up the resources. 

On each of the hosts and the router, we will install `smcroute`, a package that:

* on the router: acts as a simple software router that will allow us to configure static routes for multicast addresses,
* on the hosts: allows us to join or leave a multicast group. 

Run:

```
sudo apt update
sudo apt -y install smcroute
```

On the router, run 

```
sudo smcroutectl show
```

to see currently configured multicast routes - initially, there are none.

We will add a static route for the multicast group we will use throughout this section, 230.11.111.10. 

First, use `ip addr` to check which interface on the router is connected to the 10.10.1.0/24 subnet, and which is connected to the 10.10.2.0/24 subnet. Then, run

```
sudo smcroutectl add IFACE1 224.0.0.0/4 IFACE2
```

substituting the correct interface names - the name of the interface connected to the 10.10.1.0/24 subnet for `IFACE1`, and the name of the interface connected to 10.10.2.0/24 subnet for `IFACE2`. This says: "for any packet received on interface `IFACE1` with destination address in the multicast address range, forward to `IFACE2`. (Note that this simple routing daemon will forward _all_ multicast traffic matching this rule, even if no hosts in the 10.10.2.0/24 subnet are subscribed to the multicast group. A more sophisticated router using PIM and IGMP will be able to selectively forward traffic only when needed.)

Use

```
sudo smcroutectl show
```

to see the multicast routing table again.



Recent Linux kernels are set up so that they will _not_ respond to ICMP messages addressed to a broadcast or multicast address. To change this setting, on each host *and* on the router, run

```
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
```

Before you start, use `ip addr` to capture the network interface configuration of each host in this topology. 


### Exercise - Add a multicast route 

The process for configuring a static multicast route on an end host is very similar to configurating a static unicast route.

On each of the four hosts - romeo, juliet, hamlet, and ophelia - use 

```
ip route show dev eth1
```

to display the routing table. If there is no entry for the 224.0.0.0/4 subnet, provide a default route for multicast traffic, by:

```
sudo ip route add 224.0.0.0/4 dev eth1
```

verify it with 


```
ip route show dev eth1
```

and save the new routing table.


### Exercise - Default multicast group membership

On each of the four hosts - romeo, juliet, hamlet, and ophelia - run 

```
ip maddr show dev eth1
```

to show the multicast groups the host is a member of on its `eth1` interface. 

**Lab report**: How many IPv4 multicast groups did each experiment interface belong to on the experiment interface, `eth1`? Refer to the [list of multicast group IDs registered with IANA](https://www.iana.org/assignments/multicast-addresses/multicast-addresses.xhtml). Is the multicast group that these hosts belong to a special "well-known" group? What is it used for? Explain the purpose of this specific multicast group, *in your own words*.


### Exercise - MAC addresses for multicast, broadcast, and unicast addresses

In this exercise, we will see how MAC addresses are derived for different types of destination addresses - multicast, broadcast, and unicast.

(Note: in this exercise, we are not at all concerned with which hosts *reply* to the ICMP echo messages - in many cases, there will be no reply. The purpose of this exercise is to look at the destination MAC addresses in the ICMP echo *request* headers.)

Run

```
sudo tcpdump -i eth1 -w simple-multicast-mac-$(hostname -s).pcap
```

on romeo to capture all packets. Then, we will generate a few multicast, broadcast, and unicast frames. 

In a second terminal on romeo, run

```
ping -I eth1 -c 3 230.11.111.10
```

to generate a multicast frame. Notice that this address gets mapped to the multicast route we added on romeo earlier, but no host is a member of this multicast group. Therefore, you will not get any echo replies, but you can still see the echo requests in your `tcpdump` output. 

Next, run

```
ping -I eth1 -c 3 232.139.111.10
```

to generate a multicast frame with a different group address.


Now, we will repeat with broadcast addresses. Run

```
ping -I eth1 -c 3 -b 10.10.1.255
```

to send a broadcast frame to the directed broadcast address.

and then, run

```
ping -I eth1 -c 3 -b 255.255.255.255
```

to send a broadcast frame to the limited broadcast address.

Finally, run

```
ping -I eth1 -c 3 10.10.1.101
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
sudo ip addr add 10.10.1.101/16 dev eth1
sudo ip addr del 10.10.1.101/24 dev eth1
```


Note that with this change, juliet can still reach hosts on the 10.10.1.0/24 subnet. However, the directed broadcast address that juliet will respond to has changed.

On juliet, hamlet, and ophelia, run

```
sudo tcpdump -i eth1 -nv
```

and leave these running.

Then, on romeo, execute

```
ping -c 3 -I eth1 224.0.0.1
```

Examine the output to see which hosts reply. Save this output for your lab report. Also save the output in the `tcpdump` sessions.


Then, on romeo, ping the directed broadcast address for the 10.10.1.0/24 subnet, using

```
ping -c 3 -b 10.10.1.255
```

Examine the output to see which hosts reply. Save this output for your lab report. Also save the output in the `tcpdump` sessions.

Use Ctrl+C to stop the `tcpdump`.

Undo the configuration change on juliet:

```
sudo ip addr add 10.10.1.101/24 dev eth1
sudo ip addr del 10.10.1.101/16 dev eth1
```

**Lab report**: Which hosts replied when the multicast address was pinged, and why? Which hosts replied when the broadcast address was pinged, and why? Explain.



### Exercise - Receiving traffic for a multicast group


In this exercise, we will add multicast group memberships on some hosts, and see how this changes their response to ICMP echo requests for that multicast group.


Open two SSH sessions on the router, and use them to capture traffic on *both* router interfaces. In one session, run

```
sudo tcpdump -i eth1 -w simple-multicast-eth1-group-$(hostname -s).pcap
```

and in the other, run

```
sudo tcpdump -i eth2 -w simple-multicast-eth2-group-$(hostname -s).pcap
```

On each of the four hosts, run

```
ip maddr show dev eth1
```

and save the output. 

Then, run

```
sudo smcroutectl join eth1 230.11.111.10
```


on juliet _only_, and verify with

```
ip maddr show dev eth1
```

Save the output.

Now, on romeo, run

```
ping -I eth1 -c 3 230.11.111.10 -t 2
```

and save the output.

Leave juliet still subscribed to the multicast group, but also run 

```
sudo smcroutectl join eth1 230.11.111.10
```

on hamlet.  On romeo, run

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.

Leave juliet and hamlet still subscribed to the multicast group, but also run 

```
sudo smcroutectl join eth1 230.11.111.10
```

on ophelia.  On romeo, run

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.

Then, on juliet, hamlet, and ophelia, run


```
sudo smcroutectl leave eth1 230.11.111.10
```
 
 and on romeo, run 

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.


**Lab report**: Explain which hosts responded to the `ping` in each instance, and why. 

**Lab report**: Show the output of `ip maddr show dev eth1` on juliet, before and after you used `smcroutectl join`. What IPv4 multicast groups is juliet a member of in each case? Explain.
