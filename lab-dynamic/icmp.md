## Routing experiments with ICMP

In this section, we will explore the various ways in which routers use ICMP.

### Prep - set up gateway on each host

While the routers can learn new routes using RIP, the workstations will not. You will have to add a route on each workstation so that it can reach other workstations outside its own subnet, by going through a local router.

On romeo, set up router-1 as the gateway for the entire 10.10.0.0/16 subnet:

```
sudo route add -net 10.10.0.0 netmask 255.255.0.0 gw 10.10.61.1
```

On hamlet, set up router-2 as the gateway for the entire 10.10.0.0/16 subnet:

```
sudo route add -net 10.10.0.0 netmask 255.255.0.0 gw 10.10.62.2
```

On othello, set up router-3 as the gateway for the entire 10.10.0.0/16 subnet:

```
sudo route add -net 10.10.0.0 netmask 255.255.0.0 gw 10.10.63.3
```

On petruchio, set up router-4 as the gateway for the entire 10.10.0.0/16 subnet:

```
sudo route add -net 10.10.0.0 netmask 255.255.0.0 gw 10.10.64.4
```


### Exercise - traceroute

On one terminal on romeo and on othello, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-traceroute.pcap
```

Then, in a second terminal on romeo, run

```
traceroute -n 10.10.63.100
```

and save the output. Then, stop the `tcpdump` processes with Ctrl+C.

Play back the messages you captured with

```
sudo tcpdump -r $(hostname -s)-traceroute.pcap -env
```

**Lab report**: From the tcpdump output, explain how the multi-hop route was found using `traceroute`. Explain the sequence of messages used. What header field does romeo set in order to trigger the desired response?


### Exercise - ICMP redirect

With the configuration of our hosts, every host should be able to reach every other host. However, it will not necessarily use the shortest path. For example, the shortest path from romeo to petruchio would be romeo 🡒 router-4 🡒 petruchio. But, because romeo uses router-1 as its gateway to the other subnets, it will send traffic to petruchio using a longer path: romeo 🡒 router-1 🡒 router-4 🡒 petruchio.

In this section, we will see how routers can use an ICMP redirect message to inform hosts of a better route, in the scenario described above. An ICMP redirect message may be sent by a router if it receives a packet:

* from a host on a network it is directly connected to (not via another gateway),
* and, it determines from its routing table that the gateway through which the packet should be forwarded (according to the destination address) is also on this directly connected network.

The router will still forward the packet toward its destination, even when it also sends an ICMP redirect to the source.

First, on romeo, run

```
ip route get 10.10.64.100
```

and save the output.


On romeo, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-redirect-1.pcap
```

Then, `ping` from "romeo" to "petruchio". On "romeo", run

```
ping 10.10.64.100
```

After capturing an ICMP redirect message, save the `ping` output and stop the ping. Then, stop the `tcpdump` process with Ctrl+C.

On "romeo", run

```
traceroute -n 10.10.64.100
```

and save the output. 

By default, our workstations will not apply the routes suggested by the ICMP redirect message. To enable that feature, run

```
sudo sysctl -w net.ipv4.conf.all.accept_redirects=1
```

on "romeo". Restart the `tcpdump` process, but write to a new file, with

```
sudo tcpdump -i eth1 -w $(hostname -s)-redirect-2.pcap
```

Then, run 

```
ping 10.10.64.100
```

again on romeo until you see an ICMP redirect. Stop the ping. Then, stop the `tcpdump` processes with Ctrl+C. 

Run

```
traceroute -n 10.10.64.100
```

and save the output.

Run 

```
ip route get 10.10.64.100
```

again on romeo, and save the output.

Stop the `tcpdump`, and play back the ICMP messages on romeo with

```
sudo tcpdump -r romeo-redirect-2.pcap -env icmp
```


**Lab report**: Show the `traceroute` output and the output of `ip route get 10.10.64.100` before and after the ICMP redirect instruction was applied, and explain the change. Also show the ICMP redirect message. Who sent this message? Under what conditions will this message be sent?



### Exercise - Destination unreachable, network unreachable

In a previous exercise, we observed what happens when a host tries to send a message to an address for which it has no relevant routing rule. Now, we'll see what happens when a host tries to send a message to an address for which *the router* has no relevant routing rule. Under those circumstances, the router may send an ICMP Destination Unreachable message to let the host know that it has no route for this destination.

First, though, we need to make some changes to the router configuration. Open a new SSH session to router-1. Currently, there is a “default gateway” rule in the routing table that describes how to route *all* traffic whose destination address is not specifically given by any other rule. When there is a "default gateway" rule, we will never observe a Destination Unreachable message, since this route applies to every destination. To observe the Destination Unreachable message, we will need to remove the default gateway rule.

However, if we just remove the default gateway rule, we'll lose access to the remote host over SSH, since the SSH connection between you and the remote host is routed using that default gateway rule.

To make this exercise work without losing our SSH connection, we need to replace the default rule with more specific rules that will allow us to maintain our SSH connection.

I have prepared a script to do this automatically - to download and run it, on router-1, use

```
wget -O - https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/scripts/delete-default-route.sh | bash
```

Then, run

```
route -n
```

and make sure there is no default gateway rule (no rule with 0.0.0.0 as the destination). If your routing table looks good, you can continue! Save this routing table for your lab report.


Once the default gateway rule has been removed on router-1, open two terminals on the romeo host.


In one terminal on romeo, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-icmp-dest-net-unreachable.pcap
```

In the second terminal on romeo, run

```
ping -c 3 10.10.66.1
```

to send a message to a network for which the gateway does not have a route. Note the response. 

Stop the `tcpdump` with Ctrl+C, and play back the captured packets with


```
tcpdump -r $(hostname -s)-icmp-dest-net-unreachable.pcap -env
```

You can also transfer the file capture to your laptop with `scp`, so that you can open it in Wireshark.

Note the contents of the ICMP destination unreachable message that you captured. Check the source IP address - who sent this message?


**Lab report**: Show the ICMP destination unreachable, network unreachable message. Who sent this message? Under what conditions will this message be sent?

### Exercise - Destination unreachable, host unreachable

In a previous exercise, we observed what happens when a host tries to send a message to a host that does not reply to ARP requests (for example, because there is no such host on the network). Now, we'll see what happens when a host tries to send a message to an address for which *the last router* does not receive an ARP reply for the destination address. Under those circumstances, the router may send an ICMP Destination Unreachable message to let the source host know that the destination host is unreachable.

In one terminal on romeo, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-icmp-dest-host-unreachable.pcap
```

Also, on hamlet, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-icmp-dest-host-unreachable.pcap
```

In the second terminal on romeo, run

```
ping -c 3 10.10.62.120
```

to send a message to a host that does not exist. Note the response. 

Stop the `tcpdump` with Ctrl+C, and play back the captured packets with

```
tcpdump -r $(hostname -s)-icmp-dest-host-unreachable.pcap -env
```

on each host. You can also transfer the file captures to your laptop with `scp`, so that you can open it in Wireshark.

Note the contents of the ICMP destination unreachable message that you captured. Check the source IP address - who sent this message?

**Lab report**: Show the ICMP destination unreachable, host unreachable message. Who sent this message? Under what conditions will this message be sent?
