## Exercises on firewalls

For this experiment, we will reuse the same network as in the previous experiment.

### Exercise: Firewall with drop rule

On "server", execute 

```
sudo iptables -L -v
```

to list the existing rules in the filter table. Save the output for your lab report.

Append a rule to the end of the INPUT chain by executing

```
sudo iptables -A INPUT -v -p TCP --dport 23 -j DROP
```

Run

```
sudo iptables -L -v
```


again to display the filter table. Save the output.

On "romeo", run

```
sudo tcpdump -i eth1 -w iptables-drop-$(hostname -s).pcap
```

to capture traffic between "romeo" and "server". While this is running, initiate a `telnet` connection from "romeo" to "server" - on "romeo", run

```
telnet server
```

Wait until your `telnet` process terminates (this may take some time), then stop the `tcpdump` and transfer the packet capture to your laptop with `scp`.


**Lab report**: Can you `telnet` to the host from the remote machine? Explain.


### Exercise: Firewall with TCP RST reject

Delete the rule created in the last exercise - on "server", execute 

```
sudo iptables -D INPUT -v -p TCP --dport 23 -j DROP
```

Then, append a new rule to the INPUT chain: 

```
sudo iptables -A INPUT -v -p TCP --dport 23 -j REJECT --reject-with tcp-reset
```

Run

```
sudo iptables -L -v
```


to display the filter table. Save the output.

On "romeo", run

```
sudo tcpdump -i eth1 -w iptables-reset-$(hostname -s).pcap
```

to capture traffic between "server" and "romeo". While this is running, initiate a `telnet` connection from "romeo" to "server" - on "romeo", run

```
telnet server
```

Wait until your `telnet` process terminates, then stop the `tcpdump` and transfer the packet capture to your laptop with `scp`.


**Lab report**: Explain the different between the `tcpdump` output in this exercise and the previous exercise.
