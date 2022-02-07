# ECE-GY 6353 LAB key concepts

## 2: ARP, Bridges

### A. ARP

1. before sending a frame, a host checks its ARP table to find out the destination MAC address corresponding to the destination IP
2. if the IP address to MAC address mapping is already in the table, the host uses that MAC address as the destination address of the frame
3. if the IP address to MAC address mapping is not already in the table, the host sends an ARP request to try to resolve the address
4. the ARP request is sent with the broadcast address in the destination address field of the MAC header, so that everyone on the LAN will receive it
5. if a host receives an ARP request on an interface whose assigned IP address matches the "Target IP Address" field in the ARP request, it will return an ARP reply with the interface's MAC address
6. in the ARP reply, the destination address in the MAC header is the unicast address that was the source of the ARP request
7. the host that receives the ARP reply adds an entry to its ARP table with the IP address, MAC address, and interface name
8. the host that receives the ARP *request* and sends a response also adds an entry to its ARP table with the IP address, MAC address, and interface name from the ARP *request*
9. when an ARP table entry becomes "stale", a host can send a unicast "ARP poll" to confirm an existing ARP entry


### B. Basic bridge operation

1. a bridge operates at layer 2 and looks at Ethernet headers
2. a bridge does not change IP or MAC headers when it forwards a frame
3. when a bridge receives a frame whose destination MAC is not in its forwarding table (including broadcast), it will **flood** it out all ports except the one it is received on.
4. when a bridge receives a frame whose destination MAC is in its forwarding table, it will either **forward** it on the port where the destination is, or **drop** the frame (if it was received on the same port where the destination is)
5. when a bridge receives a frame whose source address is not in its forwarding table, it will add an entry for the source address and port number in its table
6. when a bridge receives a frame whose source address is in its forwarding table, it will reset the ageing timer for that entry
7. a bridge removes forwarding table entries that have aged out
8. a bridge can improve network performance by segmenting the network into multiple collision domains
