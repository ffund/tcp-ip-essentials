## Set up bridge interfaces

Next, we will set up the bridge nodes. Open a terminal for every bridge node, and SSH into each one. 

Follow the setup procedure in this section on _each_ bridge node (but not on the other hosts!). 

(It may be quickest to bring up four terminals, each logged in to another bridge node, then copy each command and paste it into all four terminals at once. That way, you will set up all the bridge nodes together.)

Flush the IP address on each experiment interface - since a bridge operates at Layer 2, bridge interfaces do not need an IP address:

```
sudo ip addr flush dev eth1  
sudo ip addr flush dev eth2  
```

Then, create a new bridge interface named `br0` with the command

```
sudo ip link add br0 type bridge
```

and add the two experiment interfaces to the bridge:

```
sudo ip link set eth1 master br0
sudo ip link set eth2 master br0
```

In the next part of this experiment, we will deliberately trigger a broadcast storm by sending a broadcast frame through this network of bridges. However, there is some background network protocol traffic in the network that may trigger a broadcast storm automatically, even before we send our own broadcast frame! To make it less likely that a broadcast storm will be triggered by automatic network protocol traffic, we will turn off multicast frame flooding on our bridges.

```
sudo bridge link set dev eth1 mcast_flood off
sudo bridge link set dev eth2 mcast_flood off
echo '0' | sudo tee -a /sys/class/net/br0/bridge/multicast_snooping
```

At this point, the bridges are configured but they are not yet "up" - we'll do that in the next section!
