## Observe the spanning tree protocol

Now that we have seen what can happen _without_ the spanning tree protocol, we will set up the bridges to form a logical loop-free topology using the STP. 

We'll bring up one bridge at a time, in a very specific order so that we can focus on different details of the protocol each time. For your reference, this figure shows the order in which we will bring up the bridges, and the hosts at which we will capture BPDUs each time.

![](spanning-tree-order.png)


At each stage, we will:

1. use `tcpdump` on the four hosts to capture BPDUs exchanged on every network segment,
2. bring up one bridge,
3. use `brctl showstp br0` to wait until the STP converges (until all of the bridge ports throughout the network are either in "forwarding" or "blocked" state), then
4. look at the BPDUs we captured.

For this section, you will need an SSH session on each bridge, and an SSH session on each of the other hosts.


### Network of one bridge 

In this step, we'll see what happens when a bridge first comes up, before it has received BPDUs from any other bridge.

On the four hosts, start a `tcpdump` to capture STP traffic on each network segment. Run

```
sudo tcpdump -i eth1 stp -w stp-$(hostname -s)-1.pcap
```

and leave these running.

We will start with a bridge that is *not* the final root bridge. First, we will bring up a bridge is located one step away from the final root bridge: **bridge-3**. 

On "bridge-3", run


```
sudo ifconfig br0 up
```


Then, run

```
brctl showstp br0
```

on this bridge. Initially, the state of the bridge ports may appear as "learning". Repeat this until the state of each port is either "forwarding" or "blocked". Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-1.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.

The bridge will have sent BPDUs on each of the network segments it is on, so you should find BPDUs in two of the packet captures: the packet capture on "romeo" and the packet capture on "othello". (The other two packet captures will not have BPDUs, since those network segments do not have any active bridge.)

**Lab report**: Show the BPDU sent by the bridge in the network segment that "romeo" is on, and identify the key values in the BPDU. The, show the BPDU sent by the bridge on the network segment that "othello" is on, and identify the key values in the BPDU.


### Network of two bridges 

Next, we'll bring up a second bridge: **bridge-2**, which has the _smallest_ bridge ID of all the bridges in the network. We'll use this as an opportunity to understand how the root bridge is elected, when there is more than one bridge in the network.

On the four hosts, start a `tcpdump` to capture STP traffic on each network segment. Run

```
sudo tcpdump -i eth1 stp -w stp-$(hostname -s)-2.pcap
```

and leave these running.

Then, on "bridge-2", run

```
sudo ifconfig br0 up
```

Wait until the output of

```
brctl showstp br0
```

on both of the "active" bridges ("bridge-3" and "bridge-2") shows that all ports are either "forwarding" or "blocked". 


Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-2.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.

Look at the BPDUs captured by "othello" on the network segment between the two "active" bridges. What happens when a bridge with a lower ID joins the network? 

Next, look at the BPDUs captured by "romeo", on the network segment connected by the first bridge that we brought up. At the end of this stage, is the BPDU sent by this bridge different from the BPDU you captured in the previous section, when there was only one bridge in the network?

Finally, look at the BPDUs captured by "hamlet", on the network segment connected to the new root bridge.

**Lab report**:

**Lab report**: Are the STP BPDUs forwarded by the bridges from one network segment to the next?


### Network of three bridges 

In this section, we'll bring up a third bridge, and we'll use this as an opportunity to understand how the root port is selected, and how the designated bridge and port on each network segment is selected.


On the four hosts, start a `tcpdump` to capture STP traffic on each network segment. Run

```
sudo tcpdump -i eth1 stp -w stp-$(hostname -s)-3.pcap
```

and leave these running.

Then, on "bridge-1", run

```
sudo ifconfig br0 up
```

Wait until the output of

```
brctl showstp br0
```

on all of the "active" bridges ("bridge-3", "bridge-2", and "bridge-1") shows that all ports are either "forwarding" or "blocked". 


Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-3.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.

### Network of four bridges 

Finally, we'll bring up the fourth bridge. In this section, we'll see an example of a tiebreaker being applied to elect a root port. We'll also see how a bridge port that is neither a root port nor a designated port is set to the "blocked" state, to create a logical loop-free topology.


On the four hosts, start a `tcpdump` to capture STP traffic on each network segment. Run

```
sudo tcpdump -i eth1 stp -w stp-$(hostname -s)-4.pcap
```

and leave these running.

Then, on "bridge-4", run

```
sudo ifconfig br0 up
```

Wait until the output of

```
brctl showstp br0
```

on each of the four bridges shows that all ports are either "forwarding" or "blocked". 


Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-4.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.


### Draw the spanning tree

Finally, you will draw the spanning tree configuration of the network. You can use [this template](https://viewer.diagrams.net/?highlight=0000ff&edit=_blank&layers=1&nav=1&title=spanning-tree-template.drawio#Uhttps%3A%2F%2Fraw.githubusercontent.com%2Fffund%2Ftcp-ip-essentials%2Fmaster%2Flab3%2Fspanning-tree-template.drawio) to create the drawing - click the pencil icon and then fill in the values in the shaded boxes.

* Put the root bridge at the top of your drawing. Label it "Root bridge". Then, draw each of the other bridges. On each bridge, write its hostname (e.g. "bridge-1", "bridge-2", etc.) Draw links connecting the bridges; label each network segment (e.g. "1-2", "2-3", etc.)
* Label each bridge with its bridge ID, and each port with its port ID (1 or 2).
* If a port is the root port for that bridge, put a **RP** designation next to the port.
* If a port is the designated port on its network segment, put a **DP** designation next to the port.
* Next to each bridge port, put a check mark if it is in the forwarding state. If a port is in the blocked state, then put an X next to it.
* Next to each network segment (1-2, 2-3, 3-4, 1-4), write the designated bridge and the designated port on that bridge (1 or 2) for that network segment.
* Next to each bridge, write the root path cost for that bridge.


**Lab report**: Submit your drawing.