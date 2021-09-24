## Routing between networks

In these exercises, we will observe how routing principles apply when packets are forwarded by a router from one network segment to the next.

### Remove the default route

In a previous exercise, you removed the default route on the romeo, juliet, hamlet, and ophelia hosts. Now, you will repeat this procedure for router-1, router-2, router-3, and othello.

First, use

```
route -n
```

on the remote host to see the current routing table. For example:

```
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.16.0.1      0.0.0.0         UG    0      0        0 eth0
10.10.0.0       0.0.0.0         255.255.255.0   U     0      0        0 eth1
172.16.0.0      0.0.0.0         255.240.0.0     U     0      0        0 eth0
```

To find the default gateway, look for the line with the destination address 0.0.0.0, then find the value in the Gateway column. Make a note of the default gateway - in my example, it is 172.16.0.1.

Next, find out what network you’re connecting from by running

```
netstat -n  | grep <PORT>
```

where in the command above, you substitute the port number that you use to SSH into this node (which you get from the GENI Portal). For example (with port 26203 as the SSH port), I might run


```
netstat -n  | grep 26203
```

and see the following output:

```

tcp        0     36 172.17.3.4:26203        216.165.95.188:34488    ESTABLISHED
tcp        0      0 172.17.3.4:26203        216.165.95.188:34490    ESTABLISHED
tcp        0      0 172.17.3.4:26203        216.165.95.188:34324    ESTABLISHED
```

From this output, you can find out your own public IP address (as observed by the remote host). (Here, my public IP address is 216.165.95.188.)

Now, add a route to the routing table that is *specific* to the network that you connect from:

```
sudo route add -net <FIRST OCTET OF YOUR IP>.<SECOND OCTET OF YOUR IP>.0.0/16 gw <DEFAULT GW YOU OBSERVED BEFORE>
```

for example:

```
sudo route add -net 216.165.0.0/16 gw 172.16.0.1
```

This will make sure that your SSH connection continues to be routed through the Internet-connected router at the InstaGENI site, even when you delete the default rule.

Once you have done so, you can delete the default gateway route without losing your SSH connection:

```
sudo route del default gw <DEFAULT GW>
```

e.g.

```
sudo route del default gw 172.16.0.1
```

Check your routing table with

```
route -n
```

and make sure there is no default gateway rule (no rule with 0.0.0.0 as the destination). If your routing table looks good, you can continue!

Remember to repeat this step router-1, router-2, router-3, and othello!


**IMPORTANT NOTE**: As a result of the steps above, you may get the following error message whenever you use `sudo` for the remainder of this lab exercise:

```
sudo: unable to resolve host
```

This error is *not* a cause for concern, and you can safely ignore it. But if you want to "fix" it anyway, you can run

```
sudo hostname $(hostname -s)
```

and you'll see the `sudo: unable to resolve host` one last time, but then you won't see it again for later `sudo` commands.

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

Use the `-n` argument to `tcpdump` so that addresses will be shown in dotted decimal notation and not resolved to hostnames, and use `icmp` to filter the traffic so you only capture ICMP traffic. For example:

```
sudo tcpdump -n -i eth1 icmp
```

(if you are capturing on `eth1`).

#### Part 1: No added rules

First, get all the routing table rules for the experiment interfaces. 

On romeo, othello, router-1 and router-2, run


```
route -n
```

Save these outputs for your lab report.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the command and output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.

#### Part 2: Add a route on romeo

Because the routing table on romeo has no entry for othello's subnet, you will get a "Network is unreachable" message in the previous step. Let's add a rule for othello's subnet.

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


Use method A, B, *or* C to add a route on **romeo** that will forward traffic to the **green network** through **router-1**. Save the command and output for your lab report. 


Then, get all the routing table rules for the experiment interfaces. 


Restart the six `tcpdump` processes.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the command and output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.

#### Part 3: Add a route on router-1

After adding a rule on **romeo**, you should see that the ICMP echo request is forwarded to **router-1**. However, **router-1** has no rule in its routing table that applies to the destination address, so it sends an ICMP Destination Net Unreachable message back to **romeo**.

Use method A, B, *or* C to add a route on **router-1** that will forward traffic to the **green network** through **router-2**. Save the command and output for your lab report. 

Then, get all the routing table rules for the experiment interfaces. 


On romeo, othello, router-1 and router-2, run


```
route -n
```

(you should see the new rule you added on router-1!) Save these outputs for your lab report.

Restart the six `tcpdump` processes.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the command and output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.

### Part 4: set up the reverse path

After following the previous steps, you should see that the ICMP echo request from romeo arrives at othello via router-1 and router-2. However, othello does not respond because it has no route to romeo! You will need to set up the *reverse* path in a similar way.

Use method A, B, *or* C to add a route on **othello** that will forward traffic to the **red network** through **router-2**. Save the command and output for your lab report. 

Use method A, B, *or* C to add a route on **router-2** that will forward traffic to the **red network** through **router-1**. Save the command and output for your lab report. 

Then, get all the routing table rules for the experiment interfaces. 


On romeo, othello, router-1 and router-2, run


```
route -n
```

(you should see the new rule you added on router-1!) Save these outputs for your lab report.


Restart the six `tcpdump` processes.

On romeo, run

```
ping -c 5 10.10.1.104
```

to send an ICMP echo request to othello. Save the command and output for your lab report.

Stop the `tcpdump` processes and save the output for your lab report.


**Lab report**: For each of the four parts of this experiment,

* Show the route(s) that you added (if any)
* Show the routing table on romeo, othello, router-1, and router-2 at each stage. Annotate these: underline or draw a circle/box around the route(s) that you added in this part.
* Show the `tcpdump` output on each network interface. Which network segment did an ICMP echo request appear on? Which network segment did an ICMP echo response appear on?

### Exercise - packet headers


Start a `tcpdump` on romeo and othello with

```
sudo tcpdump -i eth1 -w $(hostname -s)-static-headers.pcap

sudo tcpdump -en -v -i eth1 icmp
```

and on router-1 and router-2, run

```
sudo tcpdump -i eth1 -w $(hostname -s)-1-static-headers.pcap
```

in one terminal window and

```
sudo tcpdump -i eth2 -w $(hostname -s)-2-static-headers.pcap
```

in a second terminal window.

Then, on romeo, send an ICMP echo request to othello with 

```
ping -c 1 10.10.1.104
```

Observe the response. Stop the `tcpdump` processes. You can transfer them to your laptop with `scp`, or you can play them back on the remote host with

```
tcpdump -r $(hostname -s)-static-headers.pcap -nev
```

or on the routers with 

```
tcpdump -r $(hostname -s)-1-static-headers.pcap -nev
```

and 

```
tcpdump -r $(hostname -s)-2-static-headers.pcap -nev
```

**Lab report**: When a packet forwarded by a router, explain how the source and destination Ethernet addresses were changed. Use evidence from your packet capture and from the `ifconfig` output on each host to support your answers.

* What are the source and destination addresses in the IP and Ethernet headers of an ICMP echo request packet that went from the "romeo" machine to router-1? Which network interface on which host/router do these addresses belong to?
* What are the source and destination addresses in the IP and Ethernet headers of an ICMP echo request packet that went from router-1 to router-2? Which network interface on which host/router do these addresses belong to?
* What are the source and destination addresses in the IP and Ethernet headers of an ICMP echo request packet that went from router-2 to othello? Which network interface on which host/router do these addresses belong to?

Answer the same questions, but now for the echo _reply_ that was returned from the remote host.

In a previous lesson, you answered a similar question for traffic traversing a bridge. Compare the behavior of the bridge in last week's experiment (with respect to the packet headers) to the behavior of the router in this week's experiment.

**Lab report**: Also examine the TTL field in the IP header. What happens to the value in this field when a packet is forwarded by a router?

