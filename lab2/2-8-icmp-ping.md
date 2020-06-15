## 2.8 Exercise with ICMP and Ping

For this experiment, we will reuse the same network as in the previous experiment.

In this experiment, we will explore the transport layer requirement for communication between two hosts in the *same network segment*: the destination host must have an application listening for incoming communication on the IP address and transport layer port to which the traffic is sent.



### Exercise 9 - port unreachable

While running

```
sudo tcpdump -i eth1 -w $(hostname -s)-wrong-port.pcap
```

in one terminal window on "romeo", open a second window on "romeo" and run


```
netcat -u 10.10.0.101 4000
```

You should then see a blinking cursor on the next line. Type a message at this cursor, and hit Enter. This will send a UDP packet carrying your message to the "juliet" host on port 4000, which is not open by default.

Stop the `tcpdump` and `netcat` with Ctrl+C. You can play back the summary of the packet capture with

```
tcpdump -enX -r $(hostname -s)-wrong-port.pcap
```

Also transfer the packet capture to your laptop with `scp`.


On the "juliet" host, run


```
netstat -ln
```

to list listening ports.

Next, on the "juliet" host, run

```
netcat -l -u 4000
```

to start an application listening on UDP port 4000.

Run

```
sudo tcpdump -i eth1 -w $(hostname -s)-open-port.pcap
```

in one terminal window on "romeo", and in a second window on "romeo" run


```
netcat -u 10.10.0.101 4000
```

You should then see a blinking cursor on the next line. Type a message at this cursor, and hit Enter. This will send a UDP packet carrying your message to the "juliet" host on port 4000.

Stop the `tcpdump` and both `netcat` instances with Ctrl+C. You can play back the summary of the packet capture with

```
tcpdump -enX -r $(hostname -s)-open-port.pcap
```

Also transfer the packet capture to your laptop with `scp`.


**Lab report**: Study the saved ICMP port unreachable message (see Fig. 2.7 in the text book). Why are the first 8 bytes of the original IP datagram payload included in the ICMP message?


**Lab report**: What transport layer protocol (UDP or TCP) and port number did you attempt to contact "juliet" on? Is any service listening on that port in the first case? Is any service listening on that port in the second case? Use the `netstat` and `tcpdump` output to explain.

