## 0.3 Inspect network interfaces

### Exercise 8

Make sure you have a terminal window logged in to each host - romeo, juliet, and the router. Then, run

```
ifconfig -a
```

on each host in your topology, and examine the output.


```
eth0      Link encap:Ethernet  HWaddr 02:0d:1e:c3:c3:dc  
          inet addr:172.17.1.33  Bcast:172.31.255.255  Mask:255.240.0.0
          inet6 addr: fe80::d:1eff:fec3:c3dc/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:17561 errors:0 dropped:0 overruns:0 frame:0
          TX packets:14740 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:11047161 (11.0 MB)  TX bytes:1175202 (1.1 MB)

eth1      Link encap:Ethernet  HWaddr 02:d8:ce:5b:bc:45  
          inet addr:10.0.0.2  Bcast:10.0.0.255  Mask:255.255.255.0
          inet6 addr: fe80::d8:ceff:fe5b:bc45/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:44 errors:0 dropped:0 overruns:0 frame:0
          TX packets:20 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3476 (3.4 KB)  TX bytes:1858 (1.8 KB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:127 errors:0 dropped:0 overruns:0 frame:0
          TX packets:127 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:7644 (7.6 KB)  TX bytes:7644 (7.6 KB)
```

(The output may look slightly different, depending on the operating system version that is loaded on the hosts you are using, but the basic elements should be the same.)

On romeo and juliet, we note two Ethernet interfaces (named `eth0` and `eth1`) and a loopback interface (named `lo`). The loopback interface is a virtual network interface that the computer uses for processes on the same host to communicate with one another using network protocols. The two Ethernet interfaces represent two points of attachment to networks.  On the router node, you'll see three Ethernet interfaces, representing three points of attachment to networks.

Why do we have multiple points of attachment? Every host we reserve on GENI will have a "control" interface connected to the public Internet, that we use to SSH into the VM to run commands. In addition to the "control" interface, it can also have experiment interfaces (one for each link that we connect to the host, when setting it up in the GENI Portal, and with IP address and netmask according to what we configured in the Portal). In our lab experiments, we will send traffic over the "experiment" interfaces. The "control" interface will be used strictly for logging in to the hosts.

You can distinguish the "control" and "experiment" interfaces by their IP addresses; the experiment interfaces have whatever IP addresses you assigned to them in the GENI Portal. The IP address of the control interface is assigned by the host site, not by you.

**Lab report**: Show the output of `ifconfig -a` for each host in _your_ topology: romeo, juliet, and the router. Make sure you show which output comes from which host. Also, for each, indicate the name of the "control" interface (e.g. `eth0`, `eth1`, `eth2`) and the name of each "experiment" interface, and explain how you can tell which is which.

Once you are done with this part of the lab , proceed to the [next part](1-4-working-on-remote-hosts.md)
