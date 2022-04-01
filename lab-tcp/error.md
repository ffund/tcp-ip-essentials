
## TCP error control


Next, we'll look at a *bulk* data transfer. We'll see how TCP error control works when part of the data transfer is lost in the network. We'll also have a chance to see what happens when an established connection is broken, and then re-connected.


### Setup

First, we need to get the bulk data to send. On romeo, run

```
wget -O file.txt http://www.gutenberg.org/files/100/100-0.txt
```

to retrieve a file from the Internet and save it as `file.txt`. 

Also download the Python scripts we'll use to transfer bulk data. These scripts use the same socket commands you're familiar with from the previous exercise.

On romeo, run

```
wget https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/lab-tcp/file-sender.py -O file-sender.py
```

On juliet, run

```
wget https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/lab-tcp/file-receiver.py -O file-receiver.py
```

Next, configure the router as a 1 Mbps bottleneck, with a buffer size of 0.1 MB, in both directions. On the router, run

```
sudo tc qdisc del dev eth1 root  
sudo tc qdisc add dev eth1 root handle 1: htb default 3  
sudo tc class add dev eth1 parent 1: classid 1:3 htb rate 1Mbit  
sudo tc qdisc add dev eth1 parent 1:3 handle 3: bfifo limit 0.1MB

sudo tc qdisc del dev eth2 root  
sudo tc qdisc add dev eth2 root handle 1: htb default 3  
sudo tc class add dev eth2 parent 1: classid 1:3 htb rate 1Mbit  
sudo tc qdisc add dev eth2 parent 1:3 handle 3: bfifo limit 0.1MB  
```

Don't worry if you see a message in the output that says

```
RTNETLINK answers : No such file or directory  
```

This is normal, and not a problem!

If data arrives from the sender faster than the router can send it (through the 1 Mbps) bottleneck, it will be queued in this buffer. However, the buffer only has a 0.1 MB capacity, so once it is full, further data packets arriving from the sender will be dropped. We will see how TCP handles these dropped data packets.

### Exercise: TCP bulk transfer

On romeo, run

```
sudo tcpdump  -s 80 -i eth1 -w $(hostname -s)-tcp-bulk-error.pcap  
```

to save the packet headers to a file.


Now, we'll transfer the `file.txt` file from romeo to juliet.

On juliet, run

```
python3 file-receiver.py
```

Then, on romeo, run


```
python3 file-sender.py
```

Once the file transfer is complete, on juliet, run


```
cat file.txt
```

to verify the received file contents.

Use Ctrl+C to stop the `tcpdump`, and then transfer the packet capture file to your laptop using `scp`.

**Lab report**: The [file sending application](file-sender.py) passes blocks of data with size 4096 bytes as an argument to the `send` socket API call. Look at the TCP segment length in the TCP header of the data segments from romeo to juliet. Is the data transferred in 4096 B blocks? Will TCP segments be fragmented by the IP layer, as oversized UDP datagrams were? Can data from different 4096 B blocks (different `send` calls) end up in the same TCP segment? Explain. Compare and contrast your answer to this question with the equivalent UDP behavior.

**Lab report**: Does the number of data segments differ from that of their acknowledgements? Find an ACK that acknowledges more than one data segment. Also show the ACK immediately before this one. How can you tell that this ACK acknowledges more than one data segment? How many data segments are acknowledged by the ACK you have selected, and how many bytes of data?


**Lab report**: When segments are dropped in a TCP connection, the sender retransmits those segments.

* Find and show a retransmission in your packet capture. Also find and show the initial transmission of this segment. Note the time and the sequence number of each packet. How long did it take for the TCP sender to realize that the segment was lost, and retransmit it?
* Did the sender learn that the segment was dropped because it received a duplicate ACK? If so, show the duplicate ACK *and* the first ACK, with the same ACK number. What transmitted data segment did the receiver send the first ACK in response to, and what transmitted data segment did the receiver send the duplicate ACK in response to? Explain. (If the retransmission you selected was not sent in response to a duplicate ACK, you can find any duplicate ACK.)
* When sending a duplicate ACK, the receiver can use *selective acknowledgement* to inform the sender about subsequent segments (after the missing segment) that have arrived successfully, so the sender need retransmit only the segment that was lost and not the subsequent segments. The hosts in our connection should be configured to use SACK by default. Show the SACK TCP option in the duplicate ACK. Which segments were received successfully after the missing segment?



### Exercise: interrupted bulk file transfer

When a connection is broken, with segments left "in flight" that are not acknowledged, TCP will try to retransmit those segments. We'll explore this further in this exercise.

On romeo, run

```
sysctl net.ipv4.tcp_retries2
```

to find out how many retransmissions will be attempted before the connection is considered permanently broken.


Next, on romeo, run

```
sudo tcpdump  -s 80 -i eth1 -w $(hostname -s)-tcp-bulk-interrupted.pcap  
```

to save the packet headers to a file.


Now, we'll transfer the `file.txt` file from romeo to juliet.

On juliet, run application that receives the file from the network - 

```
python3 file-receiver.py
```

Then, on romeo, run


```
python3 file-sender.py
```

While the file transfer is ongoing, break the connection between romeo and juliet - on the router, identify the name of the interface that is on the same LAN as *juliet*, and bring it down with


```
sudo ifconfig IFACE down
```

(substitute the correct interface name).

While the connection is broken, run

```
ss -t -o state established -n src 10.10.0.0/16
```


on romeo - as part of this output, it will show you how many retransmissions have been attempted. Look for the part of the output where it says something like `timer:(on,13sec,10)` - that last value is the current retransmission count (10, in my example).


After a few minutes, run

```
sudo ifconfig IFACE up
```

on the router to restore the connection. (Again, substitute the correct interface name.)

When the file transfer is complete, use Ctrl+C to stop the `tcpdump`, and then transfer the packet capture file to your laptop using `scp`.

**Lab report**: Find the part of the packet capture where the connection was broken.  Examine the time difference between successive retransmissions of the same segment. Describe how the time intervals between successive retransmissions changes during the period when the connection was broken, and show evidence from your packet capture.
