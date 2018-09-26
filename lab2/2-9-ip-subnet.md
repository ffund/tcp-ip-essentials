## 2.9 Exercises with IP address and subnet mask

For this experiment, we will reuse the same network as in the previous experiment.

In this section, we will observe what happens when the same IP address is assigned to two different hosts. We will also set an incorrect subnet mask for hosts and see what are the consequences. 

To change the IP address and/or netmask of a given interface on our hosts, we will use the syntax

```
sudo ifconfig INTERFACE IP-ADDRESS netmask NETMASK
```

substituting appropriate values for `INTERFACE` name, `IP-ADDRESS`, and `NETMASK`.


### Exercise 11

Open terminal windows to each host in your topology. Configure the (experiment) interface on each host, according to the following table:

| Host          | IP address    | Subnet mask   |
| ------------- | ------------- |---------------|
| romeo         | 10.10.0.100   | 255.255.255.0 |
| juliet        | 10.10.0.100   | 255.255.255.0 |
| hamlet        | 10.10.0.102   | 255.255.255.0 |
| ophelia       | 10.10.0.103   | 255.255.255.0 |

On each host, delete all ARP entries from the ARP table for `eth1`.

On each host, run

```
nc -l 4000
```

to start a `netcat` server listening on TCP port 4000. (Make sure your netcat servers keep running - if one of them stops during the experiment, start it again.)

We will run this exercise in three parts:


#### Part 1

On each host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-duplicate-1.pcap
```

in a new terminal window.

From "romeo", connect to the netcat server on "hamlet" with

```
nc 10.10.0.102 4000
```

If the connection is established successfully, then you should be able to type "Hello" in the romeo window and see it echoed on hamlet.

Note down the ARP tables in each of the four hosts. Now, repeat, but with a connection from "juliet" to "ophelia". Again, note down the ARP tables in each host to see if there is any change.

Observe what happens. Stop the `tcpdump` and save the `tcpdump` output and the ARP tables for all the hosts.


#### Part 2

On each host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-duplicate-2.pcap
```

Run

```
nc 10.10.0.100 4000
```

from "hamlet".

Observe what happens. Stop the `tcpdump` and save the `tcpdump` output and the ARP tables for all the hosts.

#### Part 3 

On each host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-duplicate-3.pcap
```

Run

```
nc 10.10.0.100 4000
```

from "ophelia".

Observe what happens. Stop the `tcpdump` and save the `tcpdump` output and the ARP tables for all the hosts.


**Lab report**: Explain what happened in each case and why. Specifically, in part 2, between which two hosts was the `netcat` connection established? Why? In step 3, which host is connected to ophelia? Why? 

### Exercise 12

In [Exercise 10](2-8-icmp-ping.md), you went through a series of steps to remove the routing rule for the default gateway on one host. Now, repeat those steps on each host in your topology, so that none of that have a routing rule that defines a default gateway.

Open terminal windows to each host in your topology. Configure the (experiment) interface on each host, according to the following table:

| Host          | IP address    | Subnet mask     |
| ------------- | ------------- |-----------------|
| romeo         | 10.10.0.100   | 255.255.255.240 |
| juliet        | 10.10.0.101   | 255.255.255.0   |
| hamlet        | 10.10.0.102   | 255.255.255.0   |
| ophelia       | 10.10.0.120   | 255.255.255.240 |


We will run this exercise in four parts:


#### Part 1

On each host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-netmask-1.pcap
```

in a new terminal window.

From "romeo", ping "hamlet" or "juliet".

Observe what happens. Stop your `tcpdump`, and save the `tcpdump` output and the ARP tables for all the hosts.

#### Part 2

On each host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-netmask-2.pcap
```

From "ophelia", ping "hamlet" or "juliet". Note the output in the `ping` window.

Observe what happens. Stop your `tcpdump`, and save the `tcpdump` output and the ARP tables for all the hosts.

#### Part 3

On each host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-netmask-3.pcap
```

From "hamlet" or "juliet", ping "romeo".

Observe what happens. Stop your `tcpdump`, and save the `tcpdump` output and the ARP tables for all the hosts.

#### Part 4

On each host, run

```
sudo tcpdump -enx -i eth1 -w $(hostname -s)-netmask-4.pcap
```

From "hamlet" or "juliet", ping "ophelia".

Observe what happens. Stop your `tcpdump`, and save the `tcpdump` output and the ARP tables for all the hosts.

**Lab report**: Explain what happened in each case according to the `tcpdump` outputs saved. Explain why "ophelia" could not be reached from other hosts, whereas "romeo", which has the same subnet mask, could communicate with the other hosts. Use a bitwise analysis and explain how the netmask was applied.



