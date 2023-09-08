## TCP sockets and the TCP state diagram

Unlike UDP, which we studied in a previous lab exercise, TCP is a *reliable* and *connection oriented* transport protocol, and includes features such as *flow control* and *congestion control*. (Applications using UDP can also implement their own versions of these features - for example, TFTP uses a sliding window flow control to transfer data using UDP. However, it's not included in the transport layer for UDP - it has to be implemented in the application.)


### Overview: TCP sockets and the TCP state diagram

Applications that "live" above the transport layer use the *socket* API to send and receive data over networks. For applications using TCP, calls to the socket API cause the socket to transition between the states in the TCP state diagram:

![State transition diagram.](StateTransitionDiagram.svg)

TCP starts with connection establishment. Of the two communication endpoints, one will `listen` for incoming connections and the other will use `connect` to initiate the connection. The host that listens is known as the *server*, and the host that initiates the connection is called the *client*. In the diagram above, the heavy solid lines show the path typically taken by the client, and the dashed lines show the path typically taken by the server.

First, the server should:

1. Create a TCP socket.
2. `bind` to the local IP address and TCP port that the socket should use, and `listen` for incoming connections on the socket. This is the "passive open" step shown on the diagram. Nothing is sent on the network but the socket is now in the `LISTEN` state.
3. Call `accept`, which won't send anything over the network, but will wait until there is an incoming connection. When a connection is initiated by the client, `accept` will spin off a *new* socket which will be used for the connection to this host.

The client will then:

1. Create a TCP socket.
2. (Optional) The client may `bind` to the local IP address and TCP port. This is optional - if there is no explicit call to `bind`, the operating system will assign a TCP port to this socket in the next step.
3. Call `connect`, specifying the destination IP address and port. This is the "active open" step shown on the diagram, and starts the three-way TCP handshake.  A SYN is sent from the client to the server, putting the client in `SYN_SENT` state. The server receives the SYN and responds with a message carrying its own SYN and an ACK of the client's SYN, putting it in `SYN_RCVD` state. The client receives the SYN ACK, sends an ACK, and goes to `ESTABLISHED` state.


Once connection establishment is complete, the client and server applications can use two more socket API calls to transfer data while remaining in the `ESTABLISHED` state:

1. `send` to put data into the send socket buffer, from which the OS will stream data across the connection. As soon as a data segment is delivered to the receive socket buffer at the other endpoint, an ACK is sent in response.
2. `recv` to read data from the receive socket buffer.


Finally, the client or server can use the `shutdown` socket API call to send a FIN to the other endpoint, and close the connection. Either side can initiate the shutdown, but we'll describe the scenario where the client initiates the shutdown. 

1. The client calls `shutdown`, and sends a FIN over the network. The client is in `FIN_WAIT_1` state. The server receives the FIN and sends an ACK, at which point the server is in `CLOSE_WAIT` state. When the ACK is received by the client, the client is in `FIN_WAIT_2` state.
2. The server in `CLOSE_WAIT` state calls `shutdown`, sending its own FIN. The client receives the FIN and sends an ACK, putting it in `TIME_WAIT` state; after some time elapses, the connection will be closed. The server receives the ACK, and closes its connection.


In this experiment, we will execute each of the socket API calls involved in TCP connection establishment, data transfer, and shutdown, and observe their effect on the operating system and on the network.

For these exercises, you will need three SSH sessions on romeo, and three on juliet: one for the Python shell in which you'll set up your sockets, one for running `tcpdump` to see the effect of each socket API call on the network, and one for using Linux utilities like `lsof` and `ss` to observe the effect of each socket API call on the local system.


### Exercise: open a TCP socket

On each workstation (romeo and juliet), run

```
sudo tcpdump -i EXPIFACE1 -SnvX tcp
```

to observe network traffic.

Also on each workstation (romeo and juliet) run

```
python3
```

to open an interactive Python terminal. We will use Python to explore sockets, because it is easy to understand even if you don't have any previous Python experience. 

On romeo and juliet, run


```
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
```

in the Python terminal, to create a TCP socket. (Notice that the socket type for a TCP socket is `socket.SOCK_STREAM`. In the last lab assignment, we used a `socket.SOCK_DGRAM` type socket for UDP transport.) 

Check the output in the `tcpdump` windows - is anything sent on the network when the socket is created? Save the output for your lab report.


The `lsof` command lets us *l*i*s*t *o*pen *f*iles that are in use by applications and processes on this host. Since sockets are represented as files to the operating system, we can use it to see sockets, once they are bound to an IP address and port.

On both romeo and juliet, run

```
lsof -n -i tcp
```

Since the sockets you have created are not yet bound to any address or port, you won't see any file descriptor for them yet. 

Also check the output of


```
ss -t -o state all -ipn src 10.10.0.0/16
```

which shows *s*ocket *s*tatistics. Again, you won't see these sockets listed, since they're not yet bound to any IP address and port.


Stop the `tcpdump`, but leave your Python terminals open, as we will continue to use these sockets in the next few exercises. 


### Exercise: TCP connection refused

Normally, we would not try to initiate a connection until the server has called `bind` and then `listen`, and is prepared to process incoming connections with `accept`. However, in this exercise we will try to establish a connection when there is *not* a server process in the LISTEN state, to see what TCP does in this case.


We will use romeo as the client and juliet as the server.

In a *Linux* shell on juliet, run

```
sudo tcpdump -i EXPIFACE1 -SnvX
```

to see a live packet summary. In a *Linux* shell on romeo, run


```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-tcp-connection-refused.pcap 
```

Then, in the Python shell on romeo, run

```
sock.connect(('10.10.2.100', 4000))
```

to try and establish a connection to TCP port 4000 on juliet. (Note that juliet has not yet called `bind` and `listen` to accept incoming connections on that port!)


You should see a `ConnectionRefusedError` in the Python shell. Also note the output in `tcpdump`.

Stop the `tcpdump`, but leave your Python terminals open, as we will continue to use these sockets in the next few exercises. Transfer the file to your laptop with `scp` and open it in Wireshark. Or, you can play back the packet capture with

```
tcpdump -SnXr $(hostname -s)-tcp-connection-refused.pcap 
```

Note the TCP flags that are set in the message from romeo to juliet, and in the response from juliet to romeo.


**Lab report**: In Lab 2, you saw what happened when a client tries to reach a UDP port on which no process is listening. In this exercise, you saw what happened when a client tries to reach a TCP port on which no process is listening. Explain what happened in the TCP case, using evidence from this experiment, and note any difference from the UDP case. What kind of message (TCP, UDP, ICMP) is sent from the destination host in each case? What header fields are used in each case, to indicate that there is no service listening on that port? 


### Exercise: TCP connection establishment

Next, we're going to set up juliet as a TCP server, to listen for incoming connections on port 4000.

In a *Linux* shell on romeo, run

```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-tcp-connection-establishment.pcap 
```

to save packets to a file. In a *Linux* shell on juliet, run


```
sudo tcpdump -i EXPIFACE1 -SnvX tcp
```

to see a live packet summary.

Then, in the Python shell on juliet, run

```
sock.bind(('10.10.2.100', 4000))
sock.listen()
```

Check the `tcpdump` window on juliet, which is showing a live packet summary. Is anything sent over the network following the call to `bind` or `listen`?

On juliet, run

```
lsof -n -i tcp
```

Now you should see a TCP socket on IP address 10.10.2.100 and TCP port 4000, and it will also indicate that the socket is in the `LISTEN` state. 

Next, in the Python shell on romeo, run

```
sock.connect(('10.10.2.100', 4000))
```

to establish a connection to the listening socket on juliet. Note the output in the `tcpdump` on juliet, which should show the TCP handshake.

Run

```
lsof -n -i tcp
```

in a Linux shell on both hosts, to see the file descriptors assigned to TCP sockets.  Also check the output of


```
ss -t -o state all -ipn src 10.10.0.0/16
```

which shows *s*ocket *s*tatistics.


On romeo, you should see a socket in the `ESTABLISHED` state, with the remote address 10.10.2.100:4000. It will be labeled with the IP address and port number of *both* endpoints.  The UDP sockets we observed in a previous week were not connection-oriented, and the same socket could send data to multiple different destinations, so the socket is defined only by the *local* IP address and port. Since TCP sockets are connection-oriented, a socket that is part of an established connection can only transfer data to and from one remote endpoint, so the socket is defined by a four-tuple of local IP, local port, remote IP, and remote port.


On juliet, you won't see any change in the output of `lsof` yet. That is because our application has not yet called `accept`, so the established TCP connection has not been assigned a file descriptor yet! When the application does call `accept`, it will return a file descriptor for the socket in the `ESTABLISHED` state, and it will appear in both the `lsof` and `ss` output. The file descriptor for the socket in the `LISTEN` state will remain in that state, listening for more incoming connections from other remote hosts.



Try it now - in the Python shell on juliet, run


```
conn_sock, conn_addr = sock.accept()
```

You won't see any new traffic in the `tcpdump` window, since this socket API call only has *local* effects. However, if you run 


```
lsof -n -i tcp
```

and


```
ss -t -o state all -ipn src 10.10.0.0/16
```

again in a Linux shell on juliet, you'll see two entries:

* the *same* socket you saw previously, still in the `LISTEN` state
* a *new* socket defined by the local IP, local port, remote IP, and remote port, in the `ESTABLISHED` state

Leave your `tcpdump` and Python terminals open, as we will continue to use these sockets in the next few exercises. 


### Exercise: TCP send and receive

Now, we're going to use our sockets to exchange data between romeo and juliet.

Inside the Python terminal on romeo, run


```
sock.send(b"Hello juliet")
```

In the `tcpdump` window on juliet, you should see a packet carrying this message, and then an acknowledgement for that message. Note the sequence number in the TCP header. TCP tracks each byte of data sent and acknowledged using sequence numbers. The numbering starts from the random initial sequence number in the SYN packet, is incremented by 1 after sending the SYN, and is then incremented by 1 for each byte of data sent. In the TCP header of a packet, the sequence number is the number of the *first* byte of data in the packet.

The message will be sent over the network, and juliet will place the message in the socket's receive buffer and send an ACK in response. The ACK number will indicate the number of the *next* byte of data that the receiver expects to see.

For example:

* Suppose a host sends a SYN with the initial sequence number 710726657
* The other endpoint sends an ACK with number 710726658. Since the sequence number increments by 1 after sending a SYN, the next byte of data expected is number 710726658.
* The host then sends a 6-byte message. The sequence number in the TCP header will be 710726658.
* The other endpoint sends an ACK with number 710726658 + 6 = 710726664 

Acknowledgement of a segment only indicates that it's been placed in the socket receive buffer, but it hasn't been passed to the application yet. When juliet calls `recv` on the socket, the message will be transferred from the socket buffer to the application.

Before we call `recv`, let's check the current socket status on juliet. In a *Linux* terminal on juliet, run

```
ss -t -o state all -ipn src 10.10.0.0/16
```

to see all TCP connections. In the `Recv-Q` column for this socket, you should see a value equal to the number of bytes you just sent from romeo.


In the *Python* terminal on juliet, run

```
conn_sock.recv(1024)
```

to read up to 1024 bytes from the socket buffer. This call should return the message you sent from romeo, and if you then run

```
ss -t -o state all -ipn src 10.10.0.0/16
```


again, you'll see that there are currently 0 bytes in the receive buffer.

The client and server can both send and receive data. On juliet, send a response message to romeo - in the Python terminal on juliet, run

```
conn_sock.send(b"Hello romeo")
```

and in the Python terminal on romeo, run

```
sock.recv(1024)
```

to receive the message.

Leave your `tcpdump` and Python terminals open, as we will continue to use these sockets in the next few exercises. 


### Exercise: TCP connection termination

Now, we will see how to terminate a TCP connection. Either host can terminate their side of the connection by sending a FIN. 

In the Python terminal on romeo, run

```
sock.shutdown(socket.SHUT_RDWR)
```

and note the TCP message with the FIN flag set in the `tcpdump` output. On romeo, run

```
ss -t -o state all -ipn src 10.10.0.0/16
```

and note that the connection is now in the `FIN_WAIT2` state.

Also run

```
ss -t -o state all -ipn src 10.10.0.0/16
```

on juliet, and note that the connection is in the `CLOSE_WAIT` state.


Finally, in the Python terminal on juliet, run


```
conn_sock.shutdown(socket.SHUT_RDWR)
sock.close()
```

Run 

```
ss -t -o state all -ipn src 10.10.0.0/16
```

again in the Linux terminal on romeo. The socket may be closed (and no longer appear in the `ss` output), or it may be in the `TIME_WAIT` state, depending on how much time has elapsed. 


Use

```
quit()
```

to close the Python terminals, and Ctrl+C to stop the `tcpdump` processes. Transfer the packet capture to your laptop with `scp` and open it in Wireshark. Or, you can play it back with

```
tcpdump -SnXr $(hostname -s)-tcp-connection-establishment.pcap 
```

This packet capture should include the TCP connection establishment, the interactive data transfer, and the TCP connection termination.

**Note**: Wireshark may show you *relative* or *raw* sequence and ACK numbers. The *raw* sequence numbers reflect the values in the TCP headers. The *relative* sequence numbers show the values in the TCP headers, minus the initial sequence numbers, i.e the sequence number starting from zero. Always use the *raw* sequence numbers in your answers to lab report questions.


**Lab report**: Use the packets you captured to explain TCP connection establishment. Explain how the client goes from `CLOSED` to `SYN_SENT` to `ESTABLISHED` state, and show the packet that is sent and/or received by the client at each state transition. Explain how the server goes from `CLOSED` to `LISTEN` to `SYN_RCVD`to `ESTABLISHED` state, and show the packet that is sent and/or received by the server at each state transition.

**Lab report**: As part of the three-way handshake used for connection establishment, hosts exchange information about optional capabilities that they support - for example, if they want to use a maximum segment size (MSS) greater than the default value of 536B. Which options are used by both endpoints in this exchange? ([Here is a list of TCP options](https://www.iana.org/assignments/tcp-parameters/tcp-parameters.xml#tcp-parameters-1), with links to more information about each one.)

**Lab report**: You would expect to see TCP packets appear on a network link following which socket API calls?

**Lab report**: When a server receives a SYN over a TCP connection, it sends a SYN ACK in response. When is the SYN ACK sent - is it sent by the operating system as soon as the SYN is received, or is it only sent once the server calls `accept`?

**Lab report**: When a host receives a data segment over a TCP connection, it sends an ACK. When is this ACK sent - when the data is received by the operating system at the receiver, or when the data is received by the application at the receiver (by calling `recv`)?

**Lab report**: Use the packets you captured to show how TCP sequence numbers and ACK numbers are computed.


**Lab report**: Use the packets you captured to explain TCP connection termination. Explain how the client goes from `ESTABLISHED` to `FIN_WAIT_1` to `FIN_WAIT_2` to `TIME_WAIT` to `CLOSED` state, and show the packet that is sent and/or received by the client at each state transition. Explain how the server goes from `ESTABLISHED` to `CLOSE_WAIT` to `LAST_ACK`to `CLOSED` state, and show the packet that is sent and/or received by the server at each state transition.
