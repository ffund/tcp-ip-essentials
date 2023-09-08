## Exercises on network layer security

In the previous exercise, we looked at applications that offer some degree of confidentiality, by encrypting application-layer data.


Now, we'll look at confidentiality at the network layer.


### VPN setup


In our network topology, "romeo" is a host located within the "internal network", as is the "server". Another host, "juliet", is located _outside_ the "internal network."

To allow secure access to the "internal network" from external networks, we might use a VPN. This works by creating a virtual *tunnel* between the host on the external network and the internal network. IP packets sent through this tunnel will be encrypted by the VPN software at the host on the external network, then decrypted by the VPN server at the interface to the "internal network".

We will configure the "vpn" host as the VPN server. (A VPN server must have a "public-facing" interface on the external network, to accept connections from outside, as well as an interface on the internal network.)

On "vpn", run

```
openvpn --genkey --secret static.key  
```

to generate a cryptographic key. Then, run

```
cat static.key
```

to view the key. Copy the contents of the key file, then on "juliet", run


```
nano static.key
```

and paste the contents of the key file. Use Ctrl+O to save and Ctrl+X to exit `nano`.

Next, we are going to set up routes for the VPN traffic. 


On both router nodes, "router-int" and "router-ext", run

```
sudo sysctl net.ipv4.ip_forward=1
```

to enable packet forwarding.


We also need to make sure the OpenVPN instance will forward traffic, so on "vpn" run:

```
sudo sysctl -w net.ipv4.ip_forward=1  
```

For the VPN tunnel, we will use the 10.10.8.0/24 subnet. We need to set up routes for this network prefix throughout the "internet" network. 

On the "server" node, run

```
sudo ip route add 10.10.8.0/24 via 10.10.2.1
```

so that the server will route traffic destined for the VPN tunnel through the internal router. On the "router-int" node, run

```
sudo ip route add 10.10.8.0/24 via 10.10.3.100
```

so that the traffic destined for the VPN tunnel will go to the "vpn" node.

Now we are ready to prepare the VPN configuration.

On "vpn", run

```
nano server.ovpn
```

to create the OpenVPN configuration file, and place the following contents inside:

```
dev tun  
local 10.10.4.100
remote 10.10.5.100
ifconfig 10.10.8.1 10.10.8.100  
secret static.key  
```

Use Ctrl+O to save and Ctrl+X to exit. 


Then, run

```
sudo openvpn server.ovpn  
```

to start the OpenVPN server. Leave this running.


On the "juliet" node, run

```
nano client.ovpn
```

and place the following contents inside:

```
dev tun
local 10.10.5.100
remote 10.10.4.100
ifconfig 10.10.8.100 10.10.8.1
secret static.key
route 10.10.2.0 255.255.255.0
```


Then, run

```
sudo openvpn client.ovpn  
```

to connect to the VPN. Wait until you see


```
Initialization Sequence Completed
```

in the output.

In a second terminal on "juliet", run

```
ip addr
```

and note the new `tun0` interface. Also run


```
ip route
```

and save the output. Traffic for which prefix is routed through the VPN?

### Exercise: VPN

Now that the VPN tunnel is set up, let us see its security benefits. We will capture traffic at two locations:

* On the "router-ext" node, we'll capture traffic at the interface with the address 10.10.5.1. (Use `ip addr` to identify the name of this interface.) By inspecting the packet capture at this location, we'll be able to see what is visible to a potential eavesdropper located somewhere along the network path **between the client and the VPN server**.

* On the "router-int" node, we'll capture traffic at the interface with the address 10.10.2.1. (Use `ip addr` to identify the name of this interface.) By inspecting the packet capture at this location, we'll be able to see what is visible to a potential eavesdropper located somewhere along the network path **between the VPN server and the web, file, or login server** that the client will connect to.

On the "router-ext" node and the "router-int" node, run

```
sudo tcpdump -i IFACE  -w vpn-$(hostname -s).pcap
```

where in place of `IFACE` you use the interface name you identified as described above. 

Then, on "juliet", run

```
ftp server
```

When prompted for a "Name", enter

```
shakespeare
```

and hit "Enter". Then, when prompted for a password, enter the password you set previously for the "shakespeare" user.

After you have successfully authenticated your FTP session (you will see the message "230 Login successful"), you will see an FTP prompt. At the FTP prompt, type

```
cd /etc
```

and then 

```
get passwd
```

This will transfer a list of all usernames on the remote system over the FTP session. Finally, type 

```
exit
```

in the FTP session and hit "Enter" to end it. 

Stop the `tcpdump` running on both routers with Ctrl+C, and use `scp` to transfer these to your laptop.

When you are finished with these exercises, also stop the VPN service.


**Lab report**: Use evidence from your packet captures to indicate which of the following an eavesdropper might see (1) on the network path between the client and VPN server, and (2) on the network path between the VPN server and the FTP server:

* IP address of "juliet" on the external network (not the address on the VPN tunnel!)
* IP address of the VPN server, "vpn" (i.e. the fact that the client is using this particular VPN server)
* Internal address of the "server" node (i.e. the fact that the client is connecting to this particular FTP server)
* UDP port 1194 (i.e. this connection uses the well-known port number of OpenVPN, so eavesdroppers can identify it as VPN traffic)
* TCP port 21 (i.e. this connection uses the well-known port number of FTP, so eavesdroppers can identify it as FTP traffic)
* Session data (e.g. the name of the file that the user retrieves, the file contents)




