## Simple multicast exercise

For this experiment, we will use a topology with four hosts and one router, and IP addresses as follows:

* romeo - 10.10.1.100
* juliet - 10.10.1.101
* hamlet - 10.10.1.102
* ophelia - 10.10.2.103
* router - 10.10.1.1 and 10.10.2.1

with netmask 255.255.255.0. 

To set up this topology in the GENI Portal, create a slice, click on "Add Resources", and load the RSpec from the following URL: [https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/rspecs/four-hosts-one-router.xml](https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/rspecs/four-hosts-one-router.xml)

Refer to the [monitor website](https://fedmon.fed4fire.eu/overview/instageni) to identify an InstaGENI site that has many "free VMs" available. Then bind to an InstaGENI site and reserve your resources. Wait for them to become available for login ("turn green" on your canvas) and then SSH into each, using the details given in the GENI Portal.

Next, we will set up these resources. On the router, we will install a simple multicast router that accepts static routes. Run:

```
sudo apt-get update
sudo apt-get -y install smcroute
```

Then start it with

```
sudo smcroute -d
```

Finally, we will add a route for the multicast group we will use throughout this section, 230.11.111.10. First, use `ifconfig` to check which interface on the router is connected to the 10.10.1.0/24 subnet, and which is connected to the 10.10.2.0/24 subnet. Then, run

```
sudo smcroute -a IFACE1 10.10.1.100 230.11.111.10 IFACE2
```

substituting the correct interface names - the name of the interface connected to the 10.10.1.0/24 subnet for `IFACE1`, and the name of the interface connected to 10.10.2.0/24 subnet for `IFACE2`. 

This will add a multicast route so that traffic from "romeo" (10.10.1.100) to 230.11.111.10 will be forwarded to `IFACE2`. (Note that this simple routing daemon will forward _all_ multicast traffic matching this rule, even if no hosts in the 10.10.2.0/24 subnet are subscribed to the multicast group. A more sophisticated router using PIM and IGMP will be able to selectively forward traffic only when needed.)

Recent Linux kernels are set up so that they will _not_ respond to ICMP messages addressed to a broadcast or multicast address. To change this setting, on each host *and* on the router, run

```
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
```

Before you start, use `ifconfig -a` to capture the network interface configuration of each host in this topology. 


### Exercise - Add a multicast route 

The process for configuring a static multicast route on an end host is very similar to configurating a static unicast route.

On each of the four hosts - romeo, juliet, hamlet, and ophelia - execute 

```
route -n
```

to display the routing table. If there is no entry for the 224.0.0.0/4 subnet, provide a default route for multicast traffic, by:

```
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev eth1
```

and save the new routing table.


### Exercise - Default multicast group membership

On each of the four hosts - romeo, juliet, hamlet, and ophelia - execute 

```
netstat -g -n
```

to show the multicast groups the host is a member of. 

**Lab report**: How many IPv4 multicast groups did each experiment interface belong to on the experiment interface, `eth1`? Refer to the [list of multicast group IDs registered with IANA](https://www.iana.org/assignments/multicast-addresses/multicast-addresses.xhtml). Is the multicast group that these hosts belong to a special "well-known" group? What is it used for? Explain the purpose of this specific multicast group, *in your own words*.


### Exercise - MAC addresses for multicast, broadcast, and unicast addresses

In this exercise, we will see how MAC addresses are derived for different types of destination addresses - multicast, broadcast, and unicast.

(Note: in this exercise, we are not at all concerned with which hosts *reply* to the ICMP echo messages. The purpose of this exercise is to look at the destination MAC addresses in the ICMP echo *request* headers.)

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

First, we will send an ICMP echo request to two multicast addresses and observe the result. Then, we will send to two broadcast addresses and observe the result.

On juliet, temporarily change the netmask of the experiment interface from 255.255.255.0 to 255.255.0.0, with

```
sudo ifconfig eth1 netmask 255.255.0.0
```

Note that with this change, juliet can still reach hosts on the 10.10.1.0/24 subnet. However, the directed broadcast address that juliet will respond to has changed. You can verify this by finding the `broadcast` value in the output of `ifconfig eth1`.

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

On romeo, ping a different multicast address, with

```
ping -c 3 -I eth1 230.11.111.10
```

Examine the output to see which hosts reply. Save this output for your lab report. Also save the output in the `tcpdump` sessions.


On romeo, ping the directed broadcast address for the 10.10.1.0/24 subnet, using

```
ping -c 3 -b 10.10.1.255
```

Examine the output to see which hosts reply. Save this output for your lab report. Also save the output in the `tcpdump` sessions.


On romeo, ping the limited broadcast address, using

```
ping -c 3 -b 255.255.255.255
```

Examine the output to see which hosts reply. Save this output for your lab report. Also save the output in the `tcpdump` sessions.

Use Ctrl+C to stop the `tcpdump`.

**Lab report**: Which hosts replied when the multicast address was pinged in each case, and why? Which hosts replied when the broadcast address was pinged in each case, and why? Explain.



### Exercise - number of multicast frames

On each of "juliet", "ophelia", "hamlet", and "romeo", execute 

```
route -n
```

to display the routing table. If there is no entry for the multicast address range, provide a default route for multicast traffic, by:

```
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev eth1
```

Then, start `iperf` listening on a multicast address on "juliet", "ophelia", and "hamlet":

```
iperf -s -B 230.11.111.10 -u -i 1
```

Open two SSH sessions on the router, and use them to capture traffic on *both* router interfaces. In one session, run

```
sudo tcpdump -i eth1 -w simple-multicast-eth1-5-$(hostname -s).pcap
```

and in the other, run

```
sudo tcpdump -i eth2 -w simple-multicast-eth2-5-$(hostname -s).pcap
```


Then, on "romeo", run

```
iperf -c 230.11.111.10 -u -l 500 -n 5000 -T 2
```

to send 10 datagrams to the multicast address 230.11.111.10, with TTL of 2 (so that packets may traverse the router).

Use Ctrl+C to stop the `tcpdump`, and transfer the packet captures to your laptop.

**Lab report**: On the 10.10.1.0/24 LAN, how many hosts received the datagrams sent by `iperf`? On the 10.10.2.0/24 LAN, how many hosts received the datagrams sent by `iperf`? Did the sending host send a *copy* of each datagram for each host that received the datagrams, or did it send a single instance of each datagram?



### Exercise - Receiving traffic for a multicast group

Open two SSH sessions on the router, and use them to capture traffic on *both* router interfaces. In one session, run

```
sudo tcpdump -i eth1 -w simple-multicast-eth1-6-$(hostname -s).pcap
```

and in the other, run

```
sudo tcpdump -i eth2 -w simple-multicast-eth2-6-$(hostname -s).pcap
```

On each of the four hosts, run

```
netstat -g -n 
```

and save the output. 

Then, run

```
iperf -s -B 230.11.111.10 -u
```

on "juliet" _only_, and **stop** any running `iperf` instances on other hosts. 


Open a second SSH session on "juliet" and run

```
netstat -g -n 
```

Save the output.

Now, on "romeo", run

```
ping -I eth1 -c 3 230.11.111.10 -t 2
```

and save the output.

Leave the `iperf` server running on "juliet", but also run 

```
iperf -s -B 230.11.111.10 -u
```

on "hamlet".  On "romeo", run

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.

Next, leave the `iperf` servers running on "juliet" and "hamlet", but also run 

```
iperf -s -B 230.11.111.10 -u
```

on "ophelia".  On "romeo", run

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.

Then terminate all `iperf` servers with Ctrl+C, and on "romeo", run 

```
ping -c 3 230.11.111.10 -t 2
```

and save the output.


**Lab report**: Explain which hosts responded to the `ping` in each instance, and why. 

**Lab report**: Show the output of `netstat -g -n` on juliet, before and after you started the `iperf` server. What IPv4 multicast groups is juliet a member of in each case? Explain.
