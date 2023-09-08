## Exercises with FTP and TFTP

Both UDP and TCP can be used to transfer files between two hosts. In this exercise we will explore FTP, a TCP-based file transfer protocol, and TFTP, a UDP-based file transfer protocol.

For this experiment, we will reuse the same network as in the previous section. However, we will need to perform some additional steps to configure the hosts in this network.

You will need to configure "romeo" as an FTP and TFTP server. First, install the software packages:

```
sudo apt-get update
sudo apt-get -y install vsftpd tftpd-hpa
```

Then, create two files - one small and one large - with random contents, in directory that we will use as the FTP and TFTP root directory:


```
sudo dd if=/dev/urandom of=/var/lib/tftpboot/small.bin bs=1K count=1
sudo dd if=/dev/urandom of=/var/lib/tftpboot/large.bin bs=10M count=10
```

(it may take some time to create the large file.)

Next, edit the FTP server configuration file to enable anonymous connections (with no username and password) and to set the root directory. Run

```
sudo nano /etc/vsftpd.conf
```

and change the line

```
anonymous_enable=NO
```

to 

```
anonymous_enable=YES
```

Also add the lines

```
no_anon_password=YES
anon_root=/var/lib/tftpboot/
```

to the end of the file. Use Ctrl+O and Ctrl+X to save the file and exit `nano`. Then run

```
sudo service vsftpd restart
```

to restart the FTP server with the new configuration file.

Next, install the packages necessary for "juliet" to be an FTP and TFTP client. On "juliet", run

```
sudo apt-get update
sudo apt-get -y install tnftp atftp
```

Finally, on "romeo", install one more package that we'll use to monitor the file transfer:

```
sudo apt-get update
sudo apt-get -y install nload
```


### Exercise - FTP and TFTP operation

In this exercise, we will transfer the same file between two hosts using FTP and then using TFTP, and compare their operation.

You'll need two terminal windows open to "romeo" and one open to "juliet".

On "romeo", start `tcpdump` with 

```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-ftp-large.pcap
```

In the second terminal window on "romeo", run

```
nload -i 100000 -o 100000 EXPIFACE1
```

You will see a live display of the incoming and outgoing data rates on the `EXPIFACE1` network interface on "romeo" (and it will be scaled to the link capacity, which is 100 Mbps). Monitor this window during the file transfer.

While that is running, on "juliet" run

```
ftp romeo
```

and when prompted for a "Name", write

```
anonymous
```

and hit "Enter".

At the `ftp>` prompt, type

```
get large.bin
```

and wait for the file to be transferred over FTP. You can monitor the throughput of the file transfer in real time using the `nload` window on "romeo".

When the file transfer is complete, you will see a message similar to 

```
104857600 bytes received in X secs (Y MB/s)
```

Type

```
quit
```

and hit Enter to return to your regular terminal prompt. On "romeo", use Ctrl+C to stop `tcpdump`.

Now we will repeat the file transfer using TFTP. On "romeo", start `tcpdump` with

```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-tftp-large.pcap
```

In a second terminal window on "romeo", run

```
nload -i 100000 -o 100000 EXPIFACE1
```

You will see a live display of the incoming and outgoing data rates on the `EXPIFACE1` network interface on "romeo" (and it will be scaled to the link capacity, which is 100 Mbps).  Monitor this window during the file transfer.

While that is running, on "juliet" run

```
atftp romeo
```

At the `tftp>` prompt, type

```
get large.bin
```

and type `y` and Enter if prompted to overwrite the local file. Wait several minutes for the file to be transferred over TFTP. You can monitor the throughput of the file transfer in real time using the `nload` window on "romeo".


When the file transfer is complete, type 

```
quit
```

and hit Enter to return to your regular terminal prompt. On "romeo", use Ctrl+C to stop `tcpdump`.

We will also try another TFTP file transfer with slightly modified settings. The TFTP client we are using supports extensions to the TFTP protocol described in [RFC2348](https://tools.ietf.org/html/rfc2348), to allow the client and server to negotiate an appropriate blocksize (instead of using the 512B default value).

On "romeo", start `tcpdump` with

```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-tftp-large-blocksize.pcap
```

In a second terminal window on "romeo", run

```
nload -i 100000 -o 100000 EXPIFACE1
```

You will see a live display of the incoming and outgoing data rates on the `EXPIFACE1` network interface on "romeo" (and it will be scaled to the link capacity, which is 100 Mbps).  Monitor this window during the file transfer.

While that is running, on "juliet" run

```
atftp --option "blksize 1468" romeo
```

(The value of 1468 is selected because the standard Ethernet MTU is 1500B. A 20B IP header, 8B UDP header, and 4B TFTP header will be appended to each 1468B packet.)

At the `tftp>` prompt, type

```
get large.bin
```

and type `y` and Enter if prompted to overwrite the local file. Wait several minutes for the file to be transferred over TFTP. You can monitor the throughput of the file transfer in real time using the `nload` window on "romeo".


When the file transfer is complete, type 

```
quit
```

and hit Enter to return to your regular terminal prompt. On "romeo", use Ctrl+C to stop `tcpdump`.


### Exercise - TFTP packets

In this exercise, we will capture and analyze the packets that are exchanged during a TFTP session.


On "romeo", start `tcpdump` with

```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-tftp-small.pcap
```

While that is running, on "juliet" run

```
atftp romeo
```

At the `tftp>` prompt, type

```
get small.bin
```

Wait for the file to be transferred over TFTP. 

When the file transfer is complete, type 

```
quit
```

and hit Enter to return to your regular terminal prompt. On "romeo", use Ctrl+C to stop `tcpdump`.

Transfer the packet capture to your laptop with `scp`.

Answer the following questions:

* List all the different types of packets exchanged during the TFTP session (note the value of the `opcode` field for each). Compare them with the TFTP message format in Fig. 5.3 in the textbook. 
* Why does the server's port number change during the TFTP session?
* In a previous exercise, we found the maximum size of a UDP datagram on this network. With TFTP, which uses UDP, we transferred a file larger than the maximum UDP datagram size. How do you explain this?

### Exercise - FTP packets when not using passive mode

In this exercise, we will capture and analyze the packets that are exchanged during an FTP session that is not using passive mode.


On "romeo", start `tcpdump` with

```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-ftp-small.pcap
```

While that is running, on "juliet" run

```
ftp -A romeo
```

(the `-A` argument specifies that we should operate in active mode). When prompted for a "Name", write

```
anonymous
```

and hit "Enter".

At the `ftp>` prompt, type

```
get small.bin
```

and wait for the file to be transferred over FTP. 

When the file transfer is complete, type 

```
quit
```

and hit Enter to return to your regular terminal prompt. On "romeo", use Ctrl+C to stop `tcpdump`.

Transfer the packet capture to your laptop with `scp`. Use your packet capture to answer the following questions:

* How many well-known port numbers were used? Which machine used the well-known port numbers? What were the other port numbers used?
* Based on the `tcpdump` output, is your FTP session using passive mode or active mode? Explain how you know. What would you expect to see different if the FTP session was using the other mode?
* As can be seen from the `tcpdump` output, FTP involves two different connections, `ftp-control` and `ftp-data`. Why are two different connections used, instead of one connection?

### Exercise - FTP packets in passive mode

In this exercise, we will capture and analyze the packets that are exchanged during an FTP session using passive mode. The FTP client we have installed uses passive mode by default.

On "romeo", start `tcpdump` with

```
sudo tcpdump -i EXPIFACE1 -w $(hostname -s)-ftp-small-passive.pcap
```

While that is running, on "juliet" run

```
ftp romeo
```

and when prompted for a "Name", write

```
anonymous
```

and hit "Enter".

At the `ftp>` prompt, type

```
get small.bin
```

and wait for the file to be transferred over FTP. 

When the file transfer is complete, type 

```
quit
```

and hit Enter to return to your regular terminal prompt. On "romeo", use Ctrl+C to stop `tcpdump`.

Transfer the packet capture to your laptop with `scp`. In Wireshark, use the following steps to export a list of FTP control packets:

* Make sure that your Wireshark display inclucdes an "Info" column.
* In the filter bar at the top, type `ftp` and hit "Enter".
* In the menu, use File > Export Packet Dissections > As Plain Text
* In the dialog, enter a file name and location. In the "Packet Range" section, select the options "All packets" and "Displayed". In the "Packet Format" section, un-check the "Details" and "Bytes" options and check the "Summary line" option. 
* Click "Save" to save the list of FTP control packets. You can then open this file with any text editor.
* Then, erase the `ftp` filter from the filter bar and hit "Enter".

Also, repeat the above steps to export a list of FTP control packets from the previous exercise (with FTP in active mode).

Use your packet capture to answer the following questions:

* How many well-known port numbers were used in the FTP session in passive mode? Which machine used the well-known port numbers? What were the other port numbers used?
* Compare the list of FTP control packets in active and passive mode. What differences are there? Also compare the port numbers used in the FTP sessions in active and passive mode - which parts of each session used well-known port numbers?
* Explain how the `PORT` command works (refer to Page 28 of [RFC959](https://tools.ietf.org/html/rfc959)). Which side sends the `PORT` command, the server or the client? Our FTP client uses the `EPRT` command as an updated alternative to `PORT` (refer to [RFC2428](https://tools.ietf.org/html/rfc2428)). In your session, what are the arguments to the `EPRT` command and how are these used when establishing the `ftp-data` session? What is the response to the `EPRT` command? 
* Explain how the `PASV` command works (refer to Page 28 of [RFC959](https://tools.ietf.org/html/rfc959)). Which side sends the `PASV` command, the server or the client? What is the response to the `PASV` command, and how are the arguments in this response used when establishing the `ftp-data` session? Our FTP client uses the `EPSV` command as an updated alternative to `PASV` (refer to [RFC2428](https://tools.ietf.org/html/rfc2428)). 
* Show the list of FTP control packets for the FTP session using passive mode. Explain each packet.
