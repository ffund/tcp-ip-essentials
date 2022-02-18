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

on this bridge. Initially, the state of the bridge ports may appear as "learning". Repeat this until the state of each port is either "forwarding" or "blocked", and the "flags" section of the output is blank. Save the final output.


Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-1.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.

The bridge will have sent BPDUs on each of the network segments it is on, so you should find BPDUs in two of the packet captures: the packet capture on "romeo" and the packet capture on "othello". (The other two packet captures will not have BPDUs, since those network segments do not have any active bridge.)

**Lab report**: Show the BPDU sent by the bridge in the network segment that "romeo" is on, and identify the key values in the BPDU. Then, show the BPDU sent by the bridge on the network segment that "othello" is on, and identify the key values in the BPDU.


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

on both of the "active" bridges ("bridge-3" and "bridge-2") shows that all ports are either "forwarding" or "blocked", and the "flags" section of the output is blank. Save the final output on each bridge.


Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-2.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.

---

In the spanning tree protocol, there are four tiebreakers that can be applied to "competing" BPDUs, to definitively determine the bridge configuration. They are (in order):

1. Lowest root bridge ID
2. Lowest root path cost
3. Lowest sender bridge ID
4. Lowest sender bridge port

When two different BPDUs are sent on a link, or when a bridge receives a BPDU with a configuration that disagrees with its own current configuration, it uses these tiebreakers to determine the "winning" configuration. In this section, we'll see how the "lowest root bridge ID" tiebreakers is applied! 

In this experiment, initially "bridge-3" is sending BPDUs on both of its ports announcing *itself* as the root bridge. 

However, when "bridge-2" comes online and receives these BPDUs, it will realize that its own initial configuration (with itself as the root bridge!), should "win" becuase of a lower root bridge ID. So "bridge-2" will start sending BPDUs announcing itself as the root bridge. 

When "bridge-3" receives this BPDU, it will compare the BPDU to its existing STP configuration, realize that the root bridge ID in the new BPDU is lower, and update its configuration to reflect the new BPDU.

---

Look at the BPDUs captured by "othello" on the network segment between the two "active" bridges. What happens when a bridge with a lower ID joins the network? 

Next, look at the BPDUs captured by "romeo", on the network segment connected by the first bridge that we brought up. At the end of this stage, is the BPDU sent by this bridge different from the BPDU you captured in the previous section, when there was only one bridge in the network?


**Lab report**: Show the BPDU that "bridge-2" receives when it first comes up (from the BPDUs captured by "othello"), and the BPDU that "bridge-2" eventually sends on the same network segment. Also show the final `brctl showstp br0` output from "bridge-2" and "bridge-3" at this part of the experiment. 

**Lab report**: Before it receives any BPDUs, "bridge-2" considers itself the root bridge. After it receives a BPDU, will "bridge-2" consider itself the root bridge, or will it adopt the root bridge configuration from the BPDU it receives from "bridge-3"? Explain - which criteria breaks the tie?

**Lab report**: After "bridge-2" comes up, "bridge-3" changes its own network configuration the BPDU that "bridge-2" receives when it first comes up (from the BPDUs captured by "othello"), and the BPDU that "bridge-2" eventually sends on the same network segment. Also show the final `brctl showstp br0` output from "bridge-2" and "bridge-3" at this part of the experiment. Before it receives any BPDUs, "bridge-2" considers itself the root bridge. After it receives a BPDU, will "bridge-2" consider itself the root bridge, or will it adopt the root bridge configuration from the received BPDU? Explain - which criteria breaks the tie?


**Lab report**: At the end of this part of the experiment, which bridge sends BPDUs on the link between "bridge-2" and "bridge-1" (as captured on "hamlet")? Which bridge sends BPDUs on the link between "bridge-3" and "bridge-4" (as captured on "romeo")? Which bridge sends BPDUs on the link between "bridge-2" and "bridge-3" (as captured on "othello")? Explain.


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

on all of the "active" bridges ("bridge-3", "bridge-2", and "bridge-1") shows that all ports are either "forwarding" or "blocked", and the "flags" section of the output is blank.  Save the final output on each bridge.


Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-3.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.

---

Any bridge that is not a root bridge must elect a root port. This should be the port that is "closer" to the root bridge - i.e., has the lowest root path cost. 

Every bridge port is assigned a "path cost". This is typically, a value inversely proportional to the link speed of the interface. A 1 Gbps interface will have a lower path cost than a 100 Mbps interface! This value does not depend on the network topology, or how far the interface is from the root bridge; it's just a feature of the port.

The "root path cost" of a bridge port _does_ depend on the network topology! The root path cost tells us: suppose we would send a frame through this port, toward the root bridge. **What is the cumulative cost of every bridge port (including this one!) that would have to send/forward this frame before it is received at the root bridge?**

A bridge doesn't need to know the entire network topology to compute this value, though. It just needs to know the root path cost of the _designated bridge port_ on this network segment. (The designated bridge port is the one that has the lowest root path cost, of all the bridge ports on the network segment.) And, the designated bridge port sends BPDUs on the network segment that tell its neighbors its root path cost. This value is the "designated cost" of the interface.

Then, a bridge can compute the root path cost of each port: just add the interface "path cost" to the "designated cost".

Once a bridge has computed the root path cost of each of its ports, it will select the port with the lowest root path cost as the root port. (This is tiebreakers #2, lowest root path cost!) 

Also, the root path cost of the root port becomes the bridge's overall root path cost. 

What if there is a tie when determining the root port? If two ports have the same smallest root path cost, tiebreakers #3 (lowest sender bridge ID) and, in cast of another tie, tiebreaker #4 (lowest sender bridge port) will be applied to the BPDUs received on each port. 

Root path cost is also used to decide which bridge port is the designated bridge port on a network segment. If a bridge receives a BPDU on a port, but this port's "root path cost" is less than the "root path cost" in the BPDU, then this bridge port "wins" on tiebreaker #2 (lowest root path cost) and should become the new designated bridge port on this network segment. It will begin sending BPDUs on the network segment, and other bridge port on the network segment will update their configuration to reflect the new designated bridge port and cost.



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

on each of the four bridges shows that all ports are either "forwarding" or "blocked", and the "flags" section of the output is blank.  Save the final output on each bridge.


Then, stop the `tcpdump` processes running on the four hosts. You can play these back with

```
tcpdump -nv -r stp-$(hostname -s)-4.pcap
```

or use `scp` to transfer them to your laptop and open them in Wireshark.

When "bridge-4" comes up, it receives a different BPDU on each of its ports: one from "bridge-1" and one from "bridge-3". 

**Lab report**: Show the BPDU that "bridge-4" receives on its port 1 when the bridge comes up, and the BPDU that "bridge-4" receives on its port 2 when the bridge comes up. Also show the final `brctl showstp br0` output from this bridge. Explain the configuration of "bridge-4" with respect to the four tiebreaker criteria:

* Before it receives any BPDUs, "bridge-4" considers itself the root bridge. After it receives the two BPDUs, will "bridge-4" consider itself the root bridge, or will it adopt the root bridge configuration from one of the BPDUs? Explain - which criteria breaks the tie?
* Which of the two ports on "bridge-4" becomes the root port? Explain with reference to the four tiebreaker criteria - indicate which criteria the two BPDUs were tied on, and which criteria broke the tie. 
* For each network segment it is on, "bridge-4" will compare two possible designated bridge ports: its own port on the network segment, and the bridge port that sends a BPDU on the network segment. Does "bridge-4" become the designated bridge on any network segment? Explain with reference to the four tiebreaker criteria - indicate which criteria the two possibilities were tied on, and which criteria broke the tie.

Also answer: What is the final state of each port on "bridge-4"? Explain.  


### Draw the spanning tree

Finally, you will draw the spanning tree configuration of the network. You can use [this template](https://viewer.diagrams.net/?highlight=0000ff&edit=_blank&layers=1&nav=1&title=spanning-tree-template.drawio#Uhttps%3A%2F%2Fraw.githubusercontent.com%2Fffund%2Ftcp-ip-essentials%2Fmaster%2Flab3%2Fspanning-tree-template.drawio) to create the drawing - click the pencil icon and then fill in the values in the shaded boxes.

* Put the root bridge at the top of your drawing. Label it "Root bridge". Then, draw each of the other bridges. On each bridge, write its hostname (e.g. "bridge-1", "bridge-2", etc.) Draw links connecting the bridges; label each network segment (e.g. "1-2", "2-3", etc.)
* Label each bridge with its bridge ID, and each port with its port ID (1 or 2).
* If a port is the root port for that bridge, put a **RP** designation next to the port.
* If a port is the designated port on its network segment, put a **DP** designation next to the port.
* Next to each bridge port, put a check mark if it is in the forwarding state. If a port is in the blocked state, then put an X next to it.
* Next to each network segment (1-2, 2-3, 3-4, 1-4), write the designated bridge and the designated port on that bridge (1 or 2) for that network segment.
* Next to each bridge, write the root path cost for that bridge.


**Lab report**: Submit your drawing, along with the *final* `brctl showstp br0` screenshots from each bridge.