## 2.6 Network interface exercises

For this experiment, we will use a topology with four connected workstations on a single network segment, with IP addresses configured as follows:

* romeo: 10.10.0.100
* juliet: 10.10.0.101
* hamlet: 10.10.0.102
* ophelia: 10.10.0.103

each with a netmask of 255.255.255.0. 

To set up this topology in the GENI Portal, create a slice, click on "Add Resources", and load the RSpec from the following URL: https://git.io/fApjs

Then bind to an InstaGENI site and reserve your resources. Wait for them to become available for login ("turn green" on your canvas) and then SSH into each, using the details given in the GENI Portal.

Before you start, use `ifconfig -a` to capture the network interface configuration of each host in this topology. Draw a diagram of the topology, and label each network interface with its name, IP address, and MAC address.

### Exercise 1

Use the `ifconfig -a` command to display information about the network interface on the "romeo" host. Find the IP address and net mask of this machine on each network interface.

**Lab report**: How many interfaces does the host have? List all the interfaces found, give their names, and explain their functions briefly.

**Lab report**: What are the MTUs of the interfaces on your host?

**Lab report**: Consider the network that the experiment interface is connected to. Is the network subnetted? What is the reasoning for your answer? 

### Exercise 2

On the "romeo" host, run

```
sudo tcpdump -i eth1
```

and leave it running. Open a second terminal window and SSH into the "romeo" host in this second window. Run

```
ping -c 3 127.0.0.1
```

from the second window to send three ICMP requests to the address 127.0.0.1.

**Lab report**: From the `ping` output, is the 127.0.0.1 interface on? Can you see any ICMP message sent from your host in the `tcpdump` output? Why? (What if you would run `ping -c 3 10.10.0.100` - your experiment interface IP address - and run `tcpdump` listening on eth1. Do you see the ICMP packets in your `tcpdump` output?)


