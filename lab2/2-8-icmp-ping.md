## 2.8 Exercise with ICMP and Ping

For this experiment, we will reuse the same network as in the previous experiment.

### Exercise 8

On the "romeo" host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-icmp.pcap
```

Leave it running, and in another terminal window on "romeo", run

```
ping -sv 10.10.0.101
```

to test whether the "juliet" host is reachable.

Save the `ping` output and stop the `tcpdump`; transfer the packet capture to your laptop with `scp`.

**Lab report**: What ICMP messages are used by `ping`?

### Exercise 9

For this exercise, you will need to install the `echoping` application on the "romeo" host. Run

```
sudo apt-get update
sudo apt-get install echoping
```

on "romeo" to install this package.

While running

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-wrong-port.pcap
```

in one terminal window on "romeo", open a second window on "romeo" and run


```
echoping -u 10.10.0.101
```

This will send a UDP packet to the "juliet" host on the "echo" port, which is not open by default.

Stop the `tcpdump` and transfer the packet capture to your laptop with `scp`.

**Lab report**: Study the saved ICMP port unreachable message (see Fig. 2.7 in the text book). Why are the first 8 bytes of the original IP datagram payload included in the ICMP message?

On the "juliet" host, run


```
netstat -ln
```

to list listening ports.

**Lab report**: What transport layer protocol (UDP or TCP) and port number did you attempt to contact "juliet" on? Is any service listening on that port? Use your lab output to explain.

### Exercise 10

**Note**: If you make a mistake in this section, you may lose your connection to the remote host. Rebooting the host should restore connectivity, in case this happens. To reboot the hosts in your topology, visit the slice page in the GENI Portal, and click on the "Restart" button. Wait a few minutes for your hosts to come back up before you try to connect again.
 
The aim of this exercise is to learn what happens when you try to send packets to a network that your host is not connected to, and doesn't know how to reach.

We are going to trigger a “network is unreachable” message. This message occurs when there is no route in the host's routing table that describes how to reach a particular destination.

Currently, however, there is a “default gateway” in the routing table that describes how to route any traffic whose destination address is not specifically given by any other rule. (This is why we can access the host over SSH.) To make this exercise work without losing our SSH connection, we need to replace the default rule with one specific to the IP address we are using to connect. Then we'll be able to observe the "destination unreachable" message AND maintain our SSH connection.

I will show you how to do this with an example - to do it yourself, you'll have to substitute the relevant IP addresses and port numbers for _your_ connection in the commands below.
First, use

```
route -n

```

on the "romeo" host to see the current routing table. For example:

```
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.16.0.1      0.0.0.0         UG    0      0        0 eth0
10.10.0.0       0.0.0.0         255.255.255.0   U     0      0        0 eth1
172.16.0.0      0.0.0.0         255.240.0.0     U     0      0        0 eth0
```

Make a note of the default gateway - here, 172.16.0.1.

Next, find out what network you’re connecting from by running

```
netstat -n  | grep <PORT>
```

where in the command above, you substitute the port number that you use to SSH into this node (which you get from the GENI Portal). For example (with port 26203 as the SSH port):

```
tcp        0     36 172.17.3.4:26203        216.165.95.188:34488    ESTABLISHED
tcp        0      0 172.17.3.4:26203        216.165.95.188:34490    ESTABLISHED
tcp        0      0 172.17.3.4:26203        216.165.95.188:34324    ESTABLISHED
```

From this output, you can find out your own public IP address (as observed by the remote host). (Here, it is 216.165.95.188.)

Now, add a route to the routing table specific to the network that you connect from:

```
sudo route add -net <FIRST OCTET OF YOUR IP>.0.0.0/8 gw <DEFAULT GW YOU OBSERVED BEFORE>
```

for example:

```
sudo route add -net 216.0.0.0/8 gw 172.16.0.1
```

Now, you can delete the default gateway route without losing your SSH connection:

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

Run


```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-unreachable.pcap
```

While `tcpdump` is running to capture the ICMP messages, `ping` a host with IP address 10.10.10.100. Save the `ping` output.

When you are finished running this exercise, you can restore the default gateway route with

```
sudo route add default gw <DEFAULT GW>
```

e.g.

```
sudo route add default gw 172.16.0.1
```

**Lab report**: Can you see any traffic sent on the network? Why? Explain what happened from the `ping` output.

**Lab report**: List the different ICMP messages you captured in the exercises in this section. Give the values of the type and code fields.

