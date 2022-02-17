## Before beginning the spanning tree protocol

Before we bring the bridges up _with_ the spanning tree protocol enabled, we'll first:

* configure each bridge to use the spanning tree protocol
* identify the bridge ID that each bridge will use for the spanning tree protocol
* learn how to read the `brctl showstp` output
* and set the priority of one bridge so that it will become the root bridge


### Configure bridge to use the spanning tree protocol

On each _bridge_ node, bring down the bridge interface:

```
sudo ifconfig br0 down
```

and then run

```
sudo brctl stp br0 on
```

to turn on the spanning tree algorithm. Run

```
brctl show br0
```

and confirm that you see a "yes" in the "STP enabled" column on each bridge.


Also make a node of each bridge's bridge ID, which is displayed as 16 hex digits. The bridge ID is formed by concatenating a priority value and the MAC address of the `br0` interface:

* The default priority is 32768, which is `8000` in hex digits.
* The software bridge package we are using assigns to `br0` the lowest MAC address of all of the bridged interfaces, so this is the MAC address that will be used in the bridge ID.

Identify the bridge that has the lowest bridge ID. This is the bridge that would be the root bridge, if all of the bridges were active.


**Lab report**: Show the `brctl` output for each bridge (include the prompt, so that it is evident which bridge each output is from). Which bridge would be elected the root bridge in the spanning tree (if you did not change any bridge priority)?

### Understanding the `showstp` outut

We will monitor the progress of the spanning tree protocol on the bridges by watching the output of 

```
brctl showstp br0
```

on each bridge. 

In this output, make a note of where to find:

* the ID of the bridge whose configuration you are looking at
* the ID of the current root bridge
* the path cost to the root bridge 
* the root port (if this bridge is not the root)
* for each bridge port: 
  * the port ID
  * the ID of the designated bridge port on the network segment that this port is on
  * the root path cost (including the path to the root!) of the designated bridge port on the network segment that this port is on
  * the cost associated with forwarding through this port (not including the rest of the path to the root!)
  * the current state of the port.

Initially, before you bring any bridge up, each bridge considers *itself* to be the root bridge. However, by exchanging BPDUs, they will eventually converge and all agree on the same root bridge.


### Change bridge priority

The experiment procedure is easier to describe and follow along with as a group if we all have the same root bridge in our networks. Therefore, we will set the priority of one bridge to be lower than the rest, so that this bridge will definitely be the root bridge.

On "bridge-2", run

```
sudo brctl setbridgeprio br0 0x7000
```

to set the bridge priority to `0x7000` (this is lower than the default `0x8000`, so this bridge will have the lowest bridge ID in the network and will become the root bridge).

Run 


```
brctl showstp br0
```

and verify that this change was applied.

**Lab report**: After changing the priority on "bridge-2", which bridge do you expect will be the root bridge in the spanning tree?