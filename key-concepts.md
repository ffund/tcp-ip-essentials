# ECE-GY 6353 key concepts

## 2: ARP, Bridges

### A. ARP

1. before sending a frame, a host checks its ARP table to find out the destination MAC address corresponding to the destination IP
2. if the IP address to MAC address mapping is already in the ARP table, the host uses that MAC address as the destination address of the frame
3. if the IP address to MAC address mapping is not already in the ARP table, the host sends an ARP request to try to resolve the address
4. an ARP request is sent with the broadcast address in the destination address field of the Ethernet header, so that everyone on the LAN will receive it
5. if a host receives an ARP request on an interface whose assigned IP address matches the "Target IP Address" field in the ARP request, it will return an ARP reply with the interface's MAC address
6. in an ARP reply, the destination address in the Ethernet header is the unicast address that was the source of the ARP request
7. the host that receives the ARP reply adds an entry to its ARP table with the IP address, MAC address, and interface name
8. the host that receives the ARP *request* and sends a response also adds an entry to its ARP table with the IP address, MAC address, and interface name from the ARP *request*
9. when an ARP table entry becomes "stale", a host can send a unicast "ARP poll" to confirm an existing ARP entry
10. when a host sends an ARP request and does not receive an ARP reply, it retransmits the ARP request several times, then gives up and returns an ICMP message of type Destination Unreachable with code Host Unreachable

### B. Basic bridge operation

1. a bridge operates at layer 2 and looks at Ethernet headers
2. a bridge does not change IP or MAC headers when it forwards a frame
3. when a bridge receives a frame whose destination MAC is not in its forwarding table (including broadcast), it will **flood** it out all ports except the one it is received on.
4. when a bridge receives a frame whose destination MAC is in its forwarding table, it will either **forward** it on the port where the destination is, or **drop** the frame (if it was received on the same port where the destination is)
5. when a bridge receives a frame whose source address is not in its forwarding table, it will add an entry for the source address and port number in its table
6. when a bridge receives a frame whose source address is in its forwarding table, it will reset the ageing timer for that entry
7. a bridge removes forwarding table entries that have aged out
8. a bridge can improve network performance by segmenting the network into multiple collision domains


## 3. Spanning tree



### A. Spanning tree protocol basics

1. bridges perform the spanning tree protocol by exchanging BPDUs
2. each bridge determines its own bridge ID by combining a priority number and the MAC address of the first bridge port interface
3. the bridge with the lowest bridge ID will become the root bridge
4. 

### B. Broadcast storm

1. broadcast storms can occur in a network with bridge loops, if the bridges do not form a spanning tree
2. a broadcast storm can be triggered by any frame that will be flooded by bridges, including a frame with the broadcast address in the destination field
3. a "broadcast" storm can be triggered by a unicast frame if there is no device with that address in the network, since that frame will be flooded by all the bridges
3. a broadcast storm is not usually triggered by a frame with unicast destination address of a destination on the network, since eventually the host with that address may send a frame from which the bridges can learn 