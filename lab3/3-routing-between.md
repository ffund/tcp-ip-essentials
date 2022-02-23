## Exercises with static routing between networks

In these exercises, we will observe how routing principles apply when packets are forwarded by a router from one network segment to the next.

### Exercise - static routes for forwarding between networks

In this exercise, we will focus on routing traffic between two hosts in different network segments: romeo and othello. You will need to open:

* two terminal windows on the romeo host
* three terminal windows on router-1
* three terminal windows on router-2
* two terminal windows on the othello host

Reserve four terminal windows - one on each host - for running interactive commands. Then, the remaining terminal windows will be used to observe network traffic with `tcpdump`. Arrange the six terminal windows in order and run a `tcpdump` on

1. the experiment interface of romeo (on the red network)
2. the interface of router-1 that is on the red network
3. the interface of router-1 that is on the blue network
4. the interface of router-2 that is on the blue network
5. the interface of router-2 that is on the green network
6. the interface of othello that is on the green network

(Use the `ifconfig` output to identify which interface is on which network, for hosts and routers that have more than one interface.)

Use the `-n` argument to `tcpdump` so that addresses will be shown in dotted decimal notation and not resolved to hostnames, and use `icmp` to filter the traffic so you only capture ICMP traffic. For example:

```
sudo tcpdump -n -i eth1 icmp
```

(if you are capturing on `eth1`).

#### Part 1: No added rules

First, get all the routing table rules. On romeo, othello, router-1 and router-2, run

```
route -n
```

Save these outputs for your lab report.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.

#### Part 2: Add a route on romeo

Because the routing table on romeo has no entry for othello's subnet, you will get a "Network is unreachable" message in the previous step. Let's add a rule for othello's subnet.

---

There are two Linux utilities that are widely used to add static routes: `route` and `ip`. The `route` utility is a bit simpler to use, and is older. The `ip` utility is newer and more powerful. I will show you how to use both of these to add a static route.


**Method A**: For the `route` command, the syntax is as follows, but you will have to **substitute the correct values** for all of the words in capital letters:

```
sudo route add -net NETADDR netmask NETMASK gw GW dev IFACE
```

where,

* in place of `NETADDR` you should put the network address of the subnet that you want to add a route for,
* in place of `NETMASK` you should put the netmask of the subnet that you want to add a route for,
* in place of `GW`, you should put the IP address of the router that is in the *same* subnet as the host that you're running this command on,
* in place of `IFACE` you should put the name of the experiment interface that traffic following this rule should go through (e.g. `eth1`, `eth2`, etc.).

This rule says that: "All traffic for destinations in the network defined by `NETADDR` and `NETMASK` should be forwarded to `GW` (a "local" address) through `IFACE`."

**Method B**: Note that instead of the `netmask` notation, you can alternatively use prefix length notation:


```
sudo route add -net NETADDR/PREFIX gw GW dev IFACE
```

where,

* in place of `NETADDR` you should put the network address of the subnet that you want to add a route for,
* in place of `PREFIX` you should put the prefix length of the subnet that you want to add a route for,
* in place of `GW`, you should put the IP address of the router that is in the *same* subnet as the host that you're running this command on,
* in place of `IFACE` you should put the name of the experiment interface that traffic following this rule should go through (e.g. `eth1`, `eth2`, etc.).

This rule says that: "All traffic for destination addresses where the first `PREFIX` bits match `NETADDR` should be forwarded to `GW` (a "local" address) through `IFACE`."

**Method C**: Alternatively, you can use the `ip` command as follows:

```
sudo ip route add NETADDR/PREFIX via GW dev IFACE
```

---

Use method A, B, *or* C to add a route on **romeo** that will forward traffic to the **green network** through **router-1**. Save the command and output for your lab report. 

Then, get all the routing table rules. On romeo, othello, router-1 and router-2, run


```
route -n
```

(you should see the new rule you added on romeo!) Save these outputs for your lab report.

Restart the six `tcpdump` processes.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.

#### Part 3: Add a route on router-1

After adding a rule on **romeo**, you should see that the ICMP echo request is forwarded to **router-1**. However, **router-1** has no rule in its routing table that applies to the destination address, so it sends an ICMP Destination Net Unreachable message back to **romeo**.

Use method A, B, *or* C to add a route on **router-1** that will forward traffic to the **green network** through **router-2**. Save the command and output for your lab report. 

Then, get all the routing table rules. On romeo, othello, router-1 and router-2, run

```
route -n
```

(you should see the new rule you added on router-1!) Save these outputs for your lab report.

Restart the six `tcpdump` processes.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the command d output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.

### Part 4: set up the reverse path

After following the previous steps, you should see that the ICMP echo request from romeo arrives at othello via router-1 and router-2. However, othello does not respond because it has no route to romeo! You will need to set up the *reverse* path from othello to romeo in a similar way.

Use method A, B, *or* C to add a route on **othello** that will forward traffic to the **red network** through **router-2**. Save the command and output for your lab report. 

Use method A, B, *or* C to add a route on **router-2** that will forward traffic to the **red network** through **router-1**. Save the command and output for your lab report. 

Then, get all the routing table rules. On romeo, othello, router-1 and router-2, run


```
route -n
```

and note the two new rules you added. Save these outputs for your lab report.


Restart the six `tcpdump` processes.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the command and output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.


**Lab report**: For each of the four parts of this experiment,

* Show the route(s) that you added (if any). 
* Show the routing table on romeo, othello, router-1, and router-2 at each stage. On which hosts and routers is there a rule that matches destination addresses in the **green network**?  On which hosts and routers is there a rule that matches destination addresses in the **red network**? 
* Show the `tcpdump` output on each network interface. On which network interfaces did you see the ICMP echo *request* in the `tcpdump` output? On which network interfaces did you see the ICMP echo *reply* in the `tcpdump` output?

### Exercise - packet headers

On romeo, othello, router-1, and router-2, run

```
ifconfig
```

and save the output for your lab report.


Start a `tcpdump` on romeo with

```
sudo tcpdump -i eth1 -w $(hostname -s)-static-headers.pcap icmp
```

and on othello, router-1, and router-2, with

```
sudo tcpdump -i eth1 -w $(hostname -s)-1-static-headers.pcap icmp
```

in one terminal window and

```
sudo tcpdump -i eth2 -w $(hostname -s)-2-static-headers.pcap icmp
```

in a second terminal window.

Then, on romeo, send an ICMP echo request to othello with 

```
ping -c 1 10.10.1.104
```

Observe the response. Stop the `tcpdump` processes. You can transfer the packet captures to your laptop with `scp`, or you can play them back on the remote host with

```
tcpdump -r $(hostname -s)-static-headers.pcap -nev
```

on romeo, or on othello and the routers with 

```
tcpdump -r $(hostname -s)-1-static-headers.pcap -nev
```

and 

```
tcpdump -r $(hostname -s)-2-static-headers.pcap -nev
```


**Lab report**: When a packet is forwarded by a router, explain how the source and destination Ethernet addresses were changed. Use evidence from your packet captures and from the `ifconfig` output on each host to support your answers.

* What are the source and destination addresses in the IP and Ethernet headers of an ICMP echo request packet that went from the "romeo" machine to router-1? Which network interface on which host/router do these addresses belong to?
* What are the source and destination addresses in the IP and Ethernet headers of an ICMP echo request packet that went from router-1 to router-2? Which network interface on which host/router do these addresses belong to?
* What are the source and destination addresses in the IP and Ethernet headers of an ICMP echo request packet that went from router-2 to othello? Which network interface on which host/router do these addresses belong to?

Answer the same questions, but now for the echo _reply_ that was returned from the remote host.

In a previous lesson, you answered a similar question for traffic traversing a bridge. Compare the behavior of the bridge in last week's experiment (with respect to the packet headers) to the behavior of the router in this week's experiment.

**Lab report**: For the ICMP echo request, find the TTL value in the IP header on each network segment: red, blue, and green. What happens to the value in this field when a packet is forwarded by a router? Why?


### Exercise - longest prefix matching

In the previous exercise, you added a rule to the routing table on router-1 that matches all destination addresses in the green network (10.10.1.0/24), and that uses router-2 as the next hop. (This rule should still be in router-1's routing table!)

Now, we will add more routes so that multiple rules in router-1's routing table match the destination address 10.10.1.104, and we'll see which rule is actually applied.

First, let's make sure that router-3 can also forward packets to the destination address 10.10.1.104. Add a rule on router-3 that uses othello's interface on the **purple network** as the next hop toward the green network:

```
sudo route add -net 10.10.1.0/24 gw 10.10.2.104
```

#### Part 1: 10.10.0.0/16

Add the following rule on router-1:

```
sudo route add -net 10.10.0.0/16 gw 10.10.100.3
```

This rule says that for all destination addresses matching 10.10.0.0/16, use router-3 as the next hop. Note that this rule matches othello's address, 10.10.1.104!

On router-1, run

```
route -n
```

and save the output. Note that there are now *two* rules that match othello's address, 10.10.1.104. One rule says to use router-2 as the next hop and one rule says to use router-3 as the next hop.

Start a `tcpdump` on both interfaces of router-2 and on both interfaces of router-3:

```
sudo tcpdump -env -i eth1 icmp
```

and

```
sudo tcpdump -env -i eth2 icmp
```

Make sure you know which `tcpdump` shows the interface on the **blue network** and which shows the interface on the **green network** or the **purple network**.

Now, on romeo, ping othello:

```
ping -c 1 10.10.1.104
```

Stop the `tcpdump` processes and save the output for your lab report.


#### Part 2: 10.10.1.96/28

Add the following rule on router-1:

```
sudo route add -net 10.10.1.96/28 gw 10.10.100.3
```

This rule says that for all destination addresses matching 10.10.1.96/28, use router-3 as the next hop. Note that this rule also matches othello's address, 10.10.1.104!

On router-1, run

```
route -n
```

and save the output. Note that there are now *three* rules that match othello's address, 10.10.1.104. 

Start a `tcpdump` on both interfaces of router-2 and on both interfaces of router-3:

```
sudo tcpdump -env -i eth1 icmp
```

and

```
sudo tcpdump -env -i eth2 icmp
```

Make sure you know which `tcpdump` shows the interface on the **blue network** and which shows the interface on the **green network** or the **purple network**.

Now, on romeo, ping othello:

```
ping -c 1 10.10.1.104
```

Stop the `tcpdump` processes and save the output for your lab report.

**Lab report**: Use your `tcpdump` output to answer the following questions about Part 1 and Part 2 of this exercise:

* In your `tcpdump` output from interfaces on the **blue network**, note the ICMP echo *request* packet's destination MAC address - is it router-2's MAC address or router-3's MAC address? 
* In your `tcpdump` output from the **green network**, can you see the ICMP echo *request* packet - was it forwarded to othello by router-2? Or do you see it on the **purple network**, because it was forwarded to othello by router-3? 
* Which of the rules in router-1's routing table matches the destination address 10.10.1.104? Which one rule was applied in this case, and why?