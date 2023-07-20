## Set up bridge interfaces

Next, we will set up the bridge nodes. Open a terminal for every bridge node, and SSH into each one. 

Follow the setup procedure in this section on _each_ bridge node (but not on the other hosts!). 

(It may be quickest to bring up four terminals, each logged in to another bridge node, then copy each command and paste it into all four terminals at once. That way, you will set up all the bridge nodes together.)

<!-- Flush the IP address on each experiment interface - since a bridge operates at Layer 2, bridge interfaces do not need an IP address:

```
sudo ip addr flush dev eth1  
sudo ip addr flush dev eth2  
``` -->


Next, run

```
sudo apt-get update
sudo apt-get -y install bridge-utils
```

to install the bridge software package.

Then, create a new bridge interface named `br0` with the command

```
sudo brctl addbr br0
```

and add the two experiment interfaces to the bridge:

```
sudo brctl addif br0 EXPIFACE1
sudo brctl addif br0 EXPIFACE2
```

Finally, on each bridge, run

```
echo '0' | sudo tee -a /sys/class/net/br0/bridge/multicast_snooping
```

At this point, the bridges are configured but they are not yet "up" - we'll do that in the next section!
