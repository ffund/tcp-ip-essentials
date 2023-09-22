## Adapt to changes in the topology

Finally, we will observe how the spanning tree protocol adapts to changes in the topology. After bringing down the root bridge, we will see a temporary loss in connectivity between two end hosts, then a change in bridge port state on some bridges and re-establishment of a link (following a different Layer 2 path).


We are going to choose two hosts that are on opposite sides of the root bridge: "othello" and "hamlet". 

On "othello", run

```
ping 10.10.0.102
```

to send ICMP echo requests to "hamlet". A new ICMP echo request (with increasing sequence number) will be sent after each second.


On all four hosts, run

```
sudo tcpdump -i eth1 -w stp-change-$(hostname -s).pcap
```

Then, on "bridge-2" -  the _root_ bridge in the spanning tree - bring the bridge interface down with

```
sudo ip link set br0 down
```

On the other bridges, run

```
brctl showstp br0
```

and see how they reconfigure themselves to work around the change in the topology. How long does it take before the ICMP echo requests you are sending start to get a response again?

Once the ICMP echo requests are getting through again, stop the `tcpdump` instances.  Use `scp` to transfer these to your laptop. Also run `brctl showstp br0` to get the bridge port state on all four bridges, and save these for your lab report.



 **Lab report**: Describe the path that the ICMP echo requests took through the network *before* you brought down the root bridge, and describe the path that the ICMP echo requests took through the network *after* you brought down the root bridge.

 
**Lab report**: When you changed the topology, how much time elapsed between the last ping request arriving at the target _before_ you brought the root bridge down, and the first ping request arriving at the target _after_ you brought the root bridge down? (Use the packet capture from the network segment on which the target node was located.)
 Show evidence from your packet captures to support your answer.

