## Create a broadcast storm

The spanning tree protocol creates a loop-free forwarding topology, so as to avoid a broadcast storm. However, our bridges do _not_ currently have the spanning tree protocol turned on, so we will be able to observe a broadcast storm.

We will bring up one bridge at a time, with "bridge-1" last so that there is no loop in the network until the end.

For this section, you will need one SSH session on each bridge, and one SSH session on the "romeo" host. 

On "bridge-4", run

```
sudo ip link set br0 up
```

to bring up the bridge interface. At this point, you should be able to list the bridge ports with

```
brctl show br0
```

The output should look something like this:

```
bridge name bridge id       STP enabled interfaces
br0     8000.0245b6768fdd   no      eth1
                            	    eth2
```


Note that the spanning tree algorithm is _not_ enabled (as seen in the "STP enabled" column in the output).


Then, run

```
sudo tcpdump -env -i br0
```

on "bridge-4" to monitor traffic. (Leave this running for the rest of this section.)


In the second terminal on "romeo", run

```
sudo ping -b 10.10.0.255 -c 1
```

to generate a broadcast frame. Note that this frame will have the broadcast address `ff:ff:ff:ff:ff:ff` as the destination MAC address.

You should see one instance of this frame in the `tcpdump` on "bridge-4", but there is no loop in the network yet, so it won't trigger any broadcast storm. 

On "bridge-3" **and** on "bridge-2", run

```
sudo ip link set br0 up
```

to bring up the bridge interface. Then, run

```
sudo tcpdump -env -i br0
```

on each.  (Leave these running for the rest of this section.)


On "romeo", run

```
sudo ping -b 10.10.0.255 -c 1
```

again, to generate another broadcast frame. You should see this frame on each bridge (broadcast frames will be flooded throughout the network), but no broadcast storm yet, since there is still no loop!

Finally, we'll bring up "bridge-1". This creates a loop in the network, so as soon as a broadcast or multicast frame arrives at any bridge, it will trigger a broadcast storm that will continue until we remove the loop.


> **Note**: Some of the networking protocols running on the hosts in this experiment (in particular: IPv6 and its automatic configuration protocols) involve sending frames to a broadcast or multicast MAC address, so this may happen as soon as the loop is created, even before you send another broadcast frame! If this happens, it's OK.

On "bridge-1", run

```
sudo ip link set br0 up
sudo tcpdump -env -i br0
```

to bring up the bridge interface and watch network traffic on it. Then, on "romeo", run

```
sudo ping -b 10.10.0.255 -c 1
```

again, to generate another broadcast frame. 


Observe the `tcpdump` output on each bridge node. Take screenshots for your lab report.

> **Note**: On CloudLab, the underlying network infrastructure has some protection against broadcast storms, so you may observe that that broadcast storm stops after a few hundred or thousand instances of the frame circulating in the network, even before you bring down one bridge in the loop.

After you have observed the broadcast storm, stop the `tcpdump` sessions and then stop the broadcast storm by running 

```
sudo ip link set br0 down
```

on "bridge-1", to break the loop. 


**Lab report**: Show several packets from each of the `tcpdump` processes running on the four bridge nodes, during the broadcast storm. Can you see the many copies of the same ICMP packet? Look at the ID and sequence fields in the ICMP header, which are used to help match ICMP requests and responses - each ICMP "session" gets a unique ID, and the sequence number is incremented on each subsequent ICMP request in the same session. Are the packets you see in your `tcpdump` output different ICMP requests, or are they all copies of the same request? How can you tell?


**Lab report**: Why does a broadcast storm occur specifically when there is a loop in the network? Even though a small number of broadcast packets are sent, we see many frames circulating in the network - why?
