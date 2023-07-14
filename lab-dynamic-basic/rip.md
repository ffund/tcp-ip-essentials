## RIP exercises

In this section, we will examine the operation of RIP.

### Exercise - Set up RIP

The virtual routers in our experiment are running FRR, a software router that includes a shell interface similar to the Cisco IOS interface. Open the shell interface on each router with:

```
export VTYSH_PAGER=more
sudo vtysh
```

(If you get an error message `sudo: vtysh: command not found` or `Exiting: failed to connect to any daemons` at this point, the configuration script hasn't finished running! Wait a few minutes for it to finish.)

In the FRR shell, run

```
show ip route
```

to see what routes are currently configured on each router. Save this output.

Using this shell interface, we can configure the routers to use the RIP protocol.

First, enter Global Configuration mode in each router:


```
configure terminal
```

The prompt should change (to include a `(config)` at the end), indicating that you are now in configuration mode.

Then, type

```
router rip
```

to enable RIP. Finally, you need to associate one or more networks to the RIP routing process. Run

```
network 10.10.0.0/16
```

so that all addresses from 10.10.0.0-10.10.255.255 will be enabled for RIP. (Note: this syntax is slightly different in FRR then in Cisco IOS.) Then run `exit` twice, until you are back in the regular FRR shell (not in config mode).

RIPv2 multicasts its routing table every 30 seconds to the multicast IP address 224.0.0.9. Use `tcpdump` to capture these messages on each network segment for about a minute or two. On romeo, run

```
sudo tcpdump -en -i $(ip route get 10.10.61.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net61-rip.pcap
```

On hamlet, run

```
sudo tcpdump -en -i $(ip route get 10.10.62.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net62-rip.pcap
```

On othello, run

```
sudo tcpdump -en -i $(ip route get 10.10.63.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net63-rip.pcap
```

On petruchio, run

```
sudo tcpdump -en -i $(ip route get 10.10.64.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net64-rip.pcap
```

Then, run

```
show ip route
```

in the FRR shell on each router, to see the new routes, and save the output. 


Also see RIP-specific information in the FRR shell on each router with 

```
show ip rip
```

Note that the "Metric" column here shows the hop count to each destination network. Save all outputs.

After a few minutes, you can stop the `tcpdump` processes on the workstations with Ctrl+C. Transfer these to your laptop with `scp`, or play them back with `tcpdump` using:

```
sudo tcpdump -r $(hostname -s)-NET-rip.pcap -env
```

where `NET` in the filename should be replaced by the name of the network segment accordingly.

**Lab report**: Show the RIP messages received by router-4. Using these RIP messages, draw the distance table and the routing table at router-4, assuming that number of hops is used as the metric. Compare to the output of `show ip rip` and `show ip route` at router-4.

### Exercise - RIP response to link failure

In this exercise, we will examine how RIP reponds to link failures. We will bring down the interface on router-1 that connects to the LAN with router-2 and hamlet, and we will observe how the routing tables adapt to the change in the topology. Then, we will bring this interface back up, and observe the changes again.

First, on any router, run

```
show ip rip status
```

in the FRR shell, and save the output. Make a note of two important timer values: how often each router sends updates, and after how long without an update a route is removed from the routing table (the *timeout* value).

Start `tcpdump` on each of the four workstations. On romeo, run

```
sudo tcpdump -i $(ip route get 10.10.61.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net61-rip-failure.pcap
```

On hamlet, run

```
sudo tcpdump -i $(ip route get 10.10.62.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net62-rip-failure.pcap
```

On othello, run

```
sudo tcpdump -i $(ip route get 10.10.63.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net63-rip-failure.pcap
```

On petruchio, run

```
sudo tcpdump -i $(ip route get 10.10.64.0 | grep -oP "(?<=dev )[^ ]+") -w $(hostname -s)-net64-rip-failure.pcap
```

Let these run during this exercise.


On each of the routers, in the FRR shell, run

```
show ip rip
```

to see the current RIP database. Save the output.

On router-1, idenfity the name of the interface that has the address 10.10.62.1. (You can refer to your previous `ip addr` output, or you can use the `show ip route` output in the FRR shell, and look for the name of the interface that is directly connected to the 10.10.62.0/24 subnet.) This is the interface that connects Router 1 to the network segment that Router 2 is on. You will use this interface name in the following commands. 

Then, on Router 1, use the FRR shell to bring down this interface. Run

```
configure terminal
interface IFACE
shutdown
```

(substitute `IFACE` with the name of the interface with address 10.10.62.1). Then, run `exit` twice to return to the regular FRR shell.

Run

```
show ip rip
```

again in the FRR shell on each router. You may see some transient routing rules with a metric of 16; in RIPv2, the maximum hop count is 15, and 16 is considered an "infinite" hop count, i.e. an unreachable network.


Keep running


```
show ip rip
```

on each router. For any routers that still have a route via 10.10.62.1, note the "Time" column in the output. You should see the timer slowly running out, until eventually the route is removed.

Once there are no more routes via 10.10.62.1 on any of the routers, get the final routing tables on all four routers with 

```
show ip rip
```

and save the output. Then, in the FRR shell on Router 1, run

```
configure terminal
interface IFACE
no shutdown
```

(substitute `IFACE` with the name of the interface with address 10.10.62.1) to bring back up the disabled interface. Also, run `exit` twice until you return to the regular FRR shell.

Again, run


```
show ip rip
```

on all four routers. Keep checking until the original routes have been restored, and then save the final


```
show ip rip
```

output.

Wait at least one more minute. Then, use Ctrl+C to stop the `tcpdump` processes, and retrieve them from the workstations with `scp`. You can also play back these packet captures with


```
tcpdump -r $(hostname -s)-NET-rip-failure.pcap -env
```

where `NET` in the filename should be replaced by the name of the network segment accordingly.


**Lab report**: From the output of `show ip rip status`, how often do the routers send updates? After how long without updates will a route be removed from the routing table (the timeout value)? 

**Lab report**: Show the RIP tables and RIP messages you captured at each stage of this exercise. Explain how the routing tables changed when the most direct path between Router 1 and Router 2 was disabled, and then changed again when the direct path was re-established.

