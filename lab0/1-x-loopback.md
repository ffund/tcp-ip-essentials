### Exercise - Loopback interface

In this exercise, you will see how processes *on the same host* can communicate with each other using the loopback interface. 

For example: Suppose you have a database server and a web server installed on the same host, and the web server is supposed to display dynamic information from the database on its web pages.

* If the database server and web server were on two different hosts, they would communicate across a network, so that the web server could retrieve information from the database.
* If the database server and web server are on the same host, they'll still communicate using network protocols, but these communications won't appear on any network link. Instead, they'll appear across the loopback interface. "Packets" sent on the loopback interface are not sent on any network, but are sent to other processes on the same host.



On the "romeo" host, run

```
sudo tcpdump -n -i eth1 icmp
```

and leave it running. Open a second terminal window on "romeo". Run

```
ping -c 3 127.0.0.1
```

from the second window to send three ICMP requests to the address 127.0.0.1.

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.

Next, run

```
sudo tcpdump -n -i eth1 icmp
```

again, and leave it running. On the second terminal window on "romeo", run

```
ping -c 3 10.10.0.100
```

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.

Now, we will repeat these steps, but with the `tcpdump` running on the loopback interface. Run

```
sudo tcpdump -n -i lo icmp
```

on "romeo", and leave it running. On the second terminal window on "romeo", run

```
ping -c 3 127.0.0.1
```

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.

Finally, run

```
sudo tcpdump -n -i lo icmp
```

again, and leave it running, and on the second terminal window on "romeo", run

```
ping -c 3 10.10.0.100
```

When the `ping` finishes, use Ctrl+C to stop the `tcpdump`, then save the output for your lab report.


**Lab report**: Show the output of the `tcpdump` in each case. Which network interface carries traffic from the host *to itself* when that traffic is sent to the 127.0.0.1 address? Which network interface carries traffic from the host *to itself* when that traffic is sent to the 10.10.0.100 address? Explain how the evidence from the `tcpdump` output supports your answer.
