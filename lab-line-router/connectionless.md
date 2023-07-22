## UDP as a connectionless transport protocol

<!-- For this experiment, we will use a topology with two workstations (named "romeo" and "juliet"), and a router in between them, with IP addresses configured as follows:

* romeo: 10.10.1.100
* router, interface connected to romeo: 10.10.1.1
* router, interface connected to juliet: 10.10.2.1
* juliet: 10.10.2.100

each with a netmask of 255.255.255.0. 

To set up this topology in the GENI Portal, create a slice, click on "Add Resources", and load the RSpec from the following URL: https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/rspecs/line-no-route.xml

Refer to the [monitor website](https://fedmon.fed4fire.eu/overview/instageni) to identify an InstaGENI site that has many "free VMs" available. Then bind to an InstaGENI site and reserve your resources. Wait for them to become available for login ("turn green" on your canvas) and then SSH into each, using the details given in the GENI Portal. -->


### Setup


<!-- On both workstations, set up a route to reach the other workstation. 

On romeo, run

```
sudo route add -net 10.10.2.0/24 gw 10.10.1.1
```

and on juliet, run


```
sudo route add -net 10.10.1.0/24 gw 10.10.2.1
``` -->

We'll install and configure the `echo` service, which we'll use for this lab. On both workstations (romeo and juliet), run

```
sudo apt update
sudo apt -y install echoping xinetd
```

We will also need to edit the configuration file for the `echo` service, to enable it. Run

```
sudo nano /etc/xinetd.d/echo
```

on both workstations, to open the configuration file for editing. Change the line

```
        disable         = yes
```

to 


```
        disable         = no 
```

in *both* places where it appears, in each file.

Then use Ctrl+O and Enter to save the file, and Ctrl+X to quit.

Run

```
sudo cat /etc/xinetd.d/echo
```

to make sure the file contents are correct. It should look like [this](https://github.com/ffund/tcp-ip-essentials/blob/master/lab5/echo).

Then, run

```
sudo service xinetd restart
```

to apply the changes.

Traffic between romeo and juliet will be forwarded by the router. In this case, romeo, juliet, and the router are very close to one another (in network terms) so there is very little delay across the network. In a realistic network, there would be some delay as packets traverse the network. We will emulate this by adding some artificial delay.

On the router, run

```
sudo tc qdisc add dev EXPIFACE1 root netem delay 10ms
sudo tc qdisc add dev EXPIFACE2 root netem delay 10ms
```

Test this by running

```
ping -c 10 10.10.2.100
```

on romeo, to ping juliet. You should see a round trip time of a little over 20 ms.


### Exercise: UDP as a connectionless protocol

UDP is a very simple transport protocol. It adds a small header to the payload, then sends it directly to a target host, without establishing a connection first. This is in contrast to the other major transport protocol, TCP, which is a connection-oriented protocol.

This makes UDP useful for:

* Time-sensitive messages. Since we don't need to establish a connection before sending the message, it can reach its destination quickly. This is why UDP is often used for live audio and video, because a delay in packet delivery degrades the user experience for those applications.
* Network protocol traffic between devices. UDP avoids the computation and memory overhead of managing connections, and the extra network traffic due to connection establishment. For very small messages especially, extra network traffic due to connection establishment could add more load to the network than the message itself! This is why UDP is used to carry traffic for protocols like RIP, DNS, DHCP, NTP, and others.


On romeo, run


```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-echoping.pcap
```

to capture packets. 

On a second terminal on romeo, run

```
echoping -f x -u 10.10.2.100
```

This will send a *UDP* message (filled with the letter 'x') to the `echo` service on juliet, which will immediately send back a response. The elapsed time (from when romeo starts the `echo`, until the response was received from juliet) will be printed in the terminal output. Save this output. 


Next, on romeo, run

```
echoping -f x 10.10.2.100
```

This will send a *TCP* message (filled with the letter 'x') to the `echo` service on juliet, which will immediately send back a response. The elapsed time (from when romeo sent the TCP message, until the response was received from juliet) will be printed in the terminal output. Save this output. 

Stop your `tcpdump` process.  


You can play back the UDP echo with

```
tcpdump -r $(hostname -s)-echoping.pcap -envX udp
```

and play back the TCP echo with

```
tcpdump -r $(hostname -s)-echoping.pcap -envX tcp
```

In this packet capture, look for the packets with a repeated `x` in the payload. This is the actual echo message and response! The rest is for establishing and breaking down the connection, and for making sure that messages are received. 

Use `scp` to transfer your packet capture to your laptop, and open it in Wireshark. 

Apply the `udp` display filter to look at just the UDP echo. Then, in the Wireshark menu, click on Statistics > Flow Graph. Check the box on the bottom left that says "Limit to display filter". You should see the UDP echo request and response, with arrows showing the direction of each message and the time shown on the far left. Take a screenshot for your lab report.

Close the flow graph, and apply the `tcp` display filter to look at just the TCP echo. Then, in the Wireshark menu, click on Statistics > Flow Graph. Check the box on the bottom left that says "Limit to display filter". You should see the TCP echo request and response, with arrows showing the direction of each message and the time shown on the far left. Take a screenshot for your lab report.

**Lab report**: Show the output of the `echoping` command and the Wireshark flow graph for the UDP echo and the TCP echo. 

**Lab report**: For the echo *with* connection establishment (TCP), 

* How much time elapses from when romeo starts to establish the connection (the time of the first packet in the TCP flow graph) until romeo actually sends the echo request (time of the echo request in the TCP flow graph)?
* How much time elapses from when romeo starts to establish the connection (the time of the first packet in the TCP flow graph) until romeo receives the echo response from juliet (time of the echo reponse in the TCP flow graph)?  This number should be similar to the output of the `echoping` command, although it may be slightly smaller because it does not include some application layer overhead.
* What percent of the total round trip time (from the output of the `echoping` command) is due to the connection establishment, before the echo request is even sent?
* In the UDP case, what percent of the total round trip time (from the output of the `echoping` command) is due to the connection establishment, before the echo request is even sent?



### Exercise: UDP sockets

Applications that "live" above the transport layer use the *socket* API to send and receive data over networks. For applications using UDP, the socket API is very simple.

To ask the operating system to *send* data, an application should:

1. Create a UDP socket
2. (Optional) `bind` to the *local* IP address and UDP port that the socket should use. (If you don't choose a port, the operating system will select a random large port number for you when you first try to send data.)
3. `send` data, by specifying the data to send and the destination IP address and port.

To *receive* data, an application should:

1. Create a UDP socket
2. `bind` to the *local* IP address and UDP port that the socket should use.
3. `receive` data from the socket *buffer*, where the operating system will have put any data for this UDP port.

In this exercise, we will execute each of these steps, and observe their effect on the operating system and on the network.

On each workstation (romeo and juliet) run


```
sudo tcpdump -i EXPIFACE1 -envX udp
```

You will observe the `tcpdump` windows throughout the rest of the exercise, to see if any of your actions caused a packet to be sent over the link. 

Also on each workstation (romeo and juliet) run

```
python3
```

to open an interactive Python terminal. We will use Python to explore sockets, because it is easy to understand even if you don't have any previous Python experience. 

On romeo and juliet, run


```
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 
```

in the Python terminal, to create a UDP socket. Check the output in the `tcpdump` windows - is anything sent on the network when the socket is created? Save the output for your lab report.

We will make juliet the receiver. On juliet, run


```
sock.bind(('10.10.2.100', 4000))
```

in the Python terminal, to `bind` this socket to an IP address and port. Check the output in the `tcpdump` windows - is anything sent on the network when the socket binds to an IP address and port?  Save the output for your lab report.

The `lsof` command lets us *l*i*s*t *o*pen *f*iles that are in use by applications and processes on this host. Since sockets are represented as files to the operating system, we can use it to see sockets, once they are bound to an IP address and port.

On both romeo and juliet, run


```
lsof -n -i udp
```

in a *Linux* terminal (not the Python terminal). You should see output indicating that the `python` process is using a UDP socket bound to 10.10.2.100:4000 on juliet. Save this output for your lab report.

Also run

```
ss -lnu
```

in a Linux terminal on juliet, and find the line that indicates there is a UDP service listening on 10.10.2.100:4000. Save this output for your lab report.


Next, we'll see what happens when romeo sends some messages to a service that is *not* "receiving" yet.

On romeo, run

```
sent = sock.sendto(b'Hello', ('10.10.2.100', 4000))
print(sent)
```

in the Python terminal. The `sendto` command returns the number of bytes that were placed in the socket buffer, for the operating system to send, and then we print this value. It's not necessarily the number of bytes that are actually sent! In this case, though, if you look at the `tcpdump` output, you'll see that this message was sent over the network link.  Save the output for your lab report.

On romeo, run


```
lsof -n -i udp
```

again, in the Linux terminal. Now that you have sent data using this socket, the operating system has automatically selected a high-valued port number, and proceeded to `bind` the socket to this port (even though you didn't explicitly call `bind`). You should see the `python` process in the `lsof` output, and the port number to which the socket is bound should be identical to the source UDP port number you saw in the `tcpdump` output. 

However, this socket is not bound to only one IP address; by default, the operating system binds the socket to *all* IP addresses on this host (represented by an `*`).


Finally, in the Python terminal on juliet, run

```
data, addr = sock.recvfrom(1024)
```

to receive up to 1024 bytes from the socket. Then, in the Python terminal, run

```
print(data)
print(addr)
```

to see the message from romeo, and the address from which it was received. Save the output. The socket API passes the sender's IP address and port to the application, in case it needs to send a response.

In the Python terminal on juliet, run

```
data, addr = sock.recvfrom(1024)
```

again. When the receive buffer is empty, there is nothing to receive, so this command won't return. Send another message from romeo by running

```
sent = sock.sendto(b'Hello', ('10.10.2.100', 4000))
print(sent)
```

in the Python terminal, and note that the `recv` command will now return the newly received data.


Once a socket binds to an IP address and transport layer port, no other socket can use that IP address and transport layer port - otherwise, the network stack would not know which 

On juliet, create another socket by running


```
new_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 
```

in the Python terminal. Then, try to bind to the same IP address and port as the first socket:

```
new_sock.bind(('10.10.2.100', 4000))
```

Save the Python terminal history, including all commands and output, on each workstation. 

To exit the Python terminal, run

```
exit()
```


**Lab report**: Which UDP socket functions will cause one or more packets to appear on the network link? Show evidence for your answer from your experiment - show a screenshot of a message in your the `tcpdump` output and the Python command that triggered it. If your screenshot includes multiple Python commands, circle the one that caused the message to be sent.


**Lab report**: Which UDP socket functions will assign a transport layer port on one or more IP addresses to the socket that it is called on, so that no other socket can bind to the same address and port? Show evidence for your answer from your experiment - show output of `lsof` and the Python command that triggered it. If your screenshot includes multiple Python commands, circle the relevant one. 




### Exercise: When no service is listening

In previous lab exercises, we saw two different kinds of ICMP Type 3 (Destination Unreachable) messages:

* **Host Unreachable**: this ICMP Destination Unreachable message is sent when ARP fails to resolve an IP address. (We saw this in "Exercise - ARP for a non-existent host".)
* **Network Unreachable**: this ICMP Destination Unreachable message is sent when there is no route in the routing table (at the sending host or any intermediate router) that applies to the packet's destination address. (We saw this in "Exercises with IP address and subnet mask in a single segment network"  and in "Routing experiments with ICMP > Exercise - Destination Unreachable".)

Now, we will observe a third type of ICMP Destination Unreachable message: **Port Unreachable**. This message is returned by a host that receives a UDP packet for a destination port number on which no application or service is listening for incoming communications.

On juliet, run

```
ss -lnu
```

in a Linux terminal, and verify that there is *not* a UDP service listening on port **4005**. Save this output for your lab report.


Then, on juliet, run

```
sudo tcpdump -i EXPIFACE1 -envX
```

and leave this running. 

On romeo, try to send a UDP message to port **4005** on juliet. First, run

```
python3
```

on romeo to open an interactive Python terminal. Then, in that Python terminal, run

```
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 
sent = sock.sendto(b'Hello', ('10.10.2.100', 4005))
```

Stop the `tcpdump` and examine the ICMP message you observed.

To exit the Python terminal, run

```
exit()
```

