## Exercises with Datagram Sizes


In this experiment, we will explore the limits on UDP datagram sizes. When you use an application that sends data over UDP, the size of each individual datagram may be limited or modified by the application layer, by the transport layer, or by the network layer.

For this experiment, we will reuse the same network as in the previous section. 

### Exercise - IP layer limit and fragmentation

In this exercise, we will observe IP fragmentation - when the network layer breaks a large transport-layer PDU into smaller pieces that are less than the maximum transmission unit (MTU) of the link.

First, run 

```
ip addr show dev eth1
```

on each host, and make a note of the MTU of the `eth1` interface on each. 

Now, we'll verify this value experimentally.

To make it easier to follow the fragments, we will use a human-readable UDP payload. Run

```
wget https://raw.githubusercontent.com/ffund/tcp-ip-essentials/sp21/lab5/tesla.txt
```

on "juliet" to download a text file, which we'll use as the payload source.

On "romeo", start `tcpdump` with 

```
sudo tcpdump -env -i eth1 "not tcp"
```

(Note that we use the `"not tcp"` filter to exclude the status/information data exchanged by `iperf3` over TCP. Also note that we are monitoring the output in real time, rather than saving to a file.)

In a second terminal window on "romeo", start an `iperf3` server with

```
iperf3 -s
```

While that is running, on "juliet" run

```
iperf3 -c romeo -u -k 1 -l 512 --file tesla.txt
```

to send a UDP datagram with a 512B payload, using part of the `tesla.txt` file for the payload. (Note that an Ethernet, IP, and UDP header will be added to the payload.) Observe the result in the `tcpdump` window, where the UDP payload length, IP packet length, and the total size of the Ethernet frame is shown. 

(At the beginning of each `iperf3` transaction, you may observe two very small packets which establish that the server is listening on the specified port - you should ignore these packets.)

Now we will repeat the `iperf3` client command, but increase the length of the payload by modifying the `-l` argument, until IP fragmentation occurs. Since the MTU is 1500 B, you might try that next:

```
iperf3 -c romeo -u -k 1 -l 1500  --file tesla.txt
```

In this case, the datagram *will* be fragmented, because the MTU refers to the maximum size of the IP-layer packet, including IP and UDP headers which are added to the payload size that we specified. Gradually reduce the payload size until you find the *maximum* payload size at which fragmentation does *not* occur.


Stop the `tcpdump` with Ctrl+C. Then, start a new `tcpdump` on "romeo" with the capture saved to a file:

```
sudo tcpdump -i eth1 -w $(hostname -s)-no-ip-fragment.pcap "not tcp"
```

Make sure the `iperf3` server is running on "romeo". Then, on "juliet", repeat the `iperf3` command to send a UDP datagram with the maximum payload length at which IP fragmentation does _not_ occur.

Stop `tcpdump` with Ctrl+C. Then, start a new `tcpdump` with


```
sudo tcpdump -i eth1 -w $(hostname -s)-ip-fragment.pcap "not tcp"
```

and on "juliet", run

```
iperf3 -c romeo -u -k 1 -l 4321 --file tesla.txt
```

Stop `tcpdump` and the `iperf3` server with Ctrl+C.

Transfer the packet captures to your laptop with `scp`.

The Wireshark display for fragmented packets can be confusing, so take special care to interpret it correctly. Use Wireshark to open the packet capture for the case with IP fragmentation. Ignore the two very small packets at the beginning, which are sent by `iperf3` to establish that the server is listening on the specified port. After those, you should see several packets that, together, are reassembled by the receiver into a UDP datagram with a 4321 B payload. Please note that:

* In Wireshark, the *last* of the fragments will have two tabs in the Packet Bytes pane: one tab, labeled "Frame", will show only the last frame, and the other tab, named "Reassembled IPv4", will show the result after the IP layer reassembles all of the fragments. 
* In the Packet Detail pane, which shows the various header fields, *only* the reassembled packet is shown. This can be confusing - for example, it may appear as though the UDP header is in the last fragment, since the last fragment shows the reassembled frame including UDP header, while the first fragment (which actually includes the UDP header) is not recognized as a UDP packet.
* You can change this behavior as follows: Edit > Preferences > Protocols > IPv4, and un-check "Reassemble fragmented IPv4 datagrams". Then, the UDP header will appear in the first fragment (where it actually is), and there will be no "Reassembled IPv4" tab in the Packet Bytes pane.

If you prefer to play back the packet capture with `tcpdump`, you can use

```
tcpdump -envX -r romeo-no-ip-fragment.pcap
```

and

```
tcpdump -envX -r romeo-ip-fragment.pcap
```

**Lab report**: What is the maximum `iperf3` payload size (e.g. largest `-l` argument) that can be sent without IP fragmentation?

**Lab report**: Explain the maximum `iperf3` payload size in terms of MTU and header lengths. What headers are appended to the `iperf3` payload, and what size is each header?  Describe the total size (including payload + headers) at each layer: application layer, UDP, IP, and Ethernet.

**Lab report**: What condition is necessary and sufficient to avoid IP fragmentation?

**Lab report**: Explain the `tcpdump` output for the `iperf3` flow with `-l 4321` in terms of the IP header fields (i.e., id, offset, flags, length) that are used in fragmentation.

### Exercise - IP+UDP protocol limit

In this exercise, we'll observe the maximum payload size that can be sent in a UDP datagram. This is a limit imposed by the design of the IP and UDP header, and it applies even when IP fragmentation is allowed.

You'll need on terminal window open on "romeo" and _two_ open on "juliet".

First, run 

```
iperf3 -s 
```

on "romeo".

On "juliet",  start `tcpdump` with 

```
sudo tcpdump -en -i eth1 "not tcp"
```

(Note that we use the `"not tcp"` filter to exclude the status/information data exchanged by `iperf3` over TCP. Also note that we are monitoring the output in real time, rather than saving to a file.)

In the second terminal window on "juliet", run

```
iperf3 -c romeo -u -k 1 -l 10000
```

Re-run the `iperf3` client command, but modify the `-l` argument to increase the length of the payload by 10000 (e.g. to 20000). Repeat until the system refuses to send anything. (It will take fewer than 10 tries, increasing by 10000 each time.)


**Lab report**: What is the maximum size of the `iperf3` UDP payload that the system can send, even when fragmentation is allowed? Explain this value in terms of the header sizes and the "length" header field. (Hint: imagine an interface with a very large MTU, so that there is no IP fragmentation, and the entire payload is sent in a single UDP datagram. How many bits are allocated for the "length" field in the IP header? What is the maximum value that this field can hold? What limitation does this impose on underlying protocol layers?)


### Exercise - Application layer limit

Another potential limit on datagram sizes is at the application layer: the application may impose a limit on the size of the data payload it is willing to send. For example, `iperf3` works by sending the entire contents of a buffer in a single datagram, and the maximum buffer size that `iperf3` is willing to allocate is 1MB. 

For this experiment, you'll need two terminal windows open on "romeo" and one open on "juliet".

In a terminal window on "romeo", start an `iperf3` server with

```
iperf3 -s
```

While that is running, on "juliet" run

```
iperf3 -c romeo -u -k 1 -l 10M
```

to ask `iperf3` to send a buffer of size 10MB one time, over UDP. Note the error message, which specifies this particular application's limit. 

Other applications may not impose any limit because the application itself divides a large quantity of data across multiple datagrams. For example, TFTP (a UDP based file transfer application) works by dividing a large data payload into multiple smaller payloads, and sending a small payload in each datagram.
