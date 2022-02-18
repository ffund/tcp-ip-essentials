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
sudo ifconfig br0 down
```

On the other bridges, run

```
brctl showstp br0
```

and see how they reconfigure themselves to work around the change in the topology. How long does it take before the ICMP echo requests you are sending start to get a response again?

Once the ICMP echo requests are getting through again, stop the `tcpdump` instances.  Use `scp` to transfer these to your laptop. Also run `brctl showstp br0` to get the bridge port state on all four bridges, and save these for your lab report.

