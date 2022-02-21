## Exercises with ARP table and routing table on a host

In a previous experiment, we saw that a host uses ARP to resolve a destination IP address to a MAC address. However, in our previous experiment, the destination address was always in the _same subnet_ as the sending host.

In this experiment, we will see how a host or router uses _both_ its routing table _and_ the ARP table when sending a packet.

Note: in this discussion, 

* when we say that two devices are on the same "network segment", we mean that they are physically connected at Layer 2 (for example: on the same Ethernet segment), regardless of their Layer 3 configuration
* when we say that two devices are on the same "subnet", this is a reference to their Layer 3 configuration.

[![](https://mermaid.ink/img/pako:eNqtlE1P4zAQhv_KyBeKBGL3Gi1IJS2lq21V8XEiHNx42lhN7K7tUEWU_864Dm0DqeiBnKyZ8TzvOxP5laVaIIvY3PBlBg-9RAF93aeE_dN6AeUSBFonFXdSKxhOQCowuqTIHByf5piwZ6gvwfn51TphI-7SzOd9HYK0f6bm4kpIg6nLK0i1UnRCAZ3B5a_ThK3hmnBxhukC5OwTb3OXenhu926yZTaRYw1Fg-q79qjrHbrSKEBjtIlCrzG6lTYL37NUBnmatbZsd_EiOcy5wxWvvPzfG_nxvvyP7HfSr2vOsJFcww01u0clwOnWUaykyxqJTTjT1p1YGHVj4EIYtPYLaKydV7IF9Qn0YCrPoXqdv2AAfNr3tAphS5r8OLxYg_9LqurY0y2lX1NCeplXhLj5mnKyQJonJYd7Pi3mswiG8WgS3PT2JDzudlQv8Ja87odDtNPUvVMWH_A_OOB_t8BjvQ9avN8es8YadRL-rdbtDVqH9_enh7czHWyxM1agKbgU9Da8eikJcxkWNLmIjgJnvMxJSaLeqLRcCrrfF9Jpw6IZzy2eMV46fV-pdBsIVT3J6a0p6ujbO8FWea4)](https://mermaid.live/edit#pako:eNqtlE1P4zAQhv_KyBeKBGL3Gi1IJS2lq21V8XEiHNx42lhN7K7tUEWU_864Dm0DqeiBnKyZ8TzvOxP5laVaIIvY3PBlBg-9RAF93aeE_dN6AeUSBFonFXdSKxhOQCowuqTIHByf5piwZ6gvwfn51TphI-7SzOd9HYK0f6bm4kpIg6nLK0i1UnRCAZ3B5a_ThK3hmnBxhukC5OwTb3OXenhu926yZTaRYw1Fg-q79qjrHbrSKEBjtIlCrzG6lTYL37NUBnmatbZsd_EiOcy5wxWvvPzfG_nxvvyP7HfSr2vOsJFcww01u0clwOnWUaykyxqJTTjT1p1YGHVj4EIYtPYLaKydV7IF9Qn0YCrPoXqdv2AAfNr3tAphS5r8OLxYg_9LqurY0y2lX1NCeplXhLj5mnKyQJonJYd7Pi3mswiG8WgS3PT2JDzudlQv8Ja87odDtNPUvVMWH_A_OOB_t8BjvQ9avN8es8YadRL-rdbtDVqH9_enh7czHWyxM1agKbgU9Da8eikJcxkWNLmIjgJnvMxJSaLeqLRcCrrfF9Jpw6IZzy2eMV46fV-pdBsIVT3J6a0p6ujbO8FWea4)

### Exercise - directly connected route


For this exercise, we will configure addresses and subnet masks on four hosts, as follows:

| Host          | IP address    | Subnet mask     |
| ------------- | ------------- |-----------------|
| romeo         | 10.10.0.100   | 255.255.255.240 |
| juliet        | 10.10.0.101   | 255.255.255.0   |
| hamlet        | 10.10.0.102   | 255.255.255.0   |
| ophelia       | 10.10.0.120   | 255.255.255.240 |


To change the IP address and/or netmask of a given interface on our hosts, use the syntax

```
sudo ifconfig INTERFACE IP-ADDRESS netmask NETMASK
```

substituting appropriate values for `INTERFACE` name, `IP-ADDRESS`, and `NETMASK`. 

When a network interface is configured with an IP address and subnet mask, a "directly connected network" rule is *automatically* added to the routing table on that device. This rule applies to all destination addresses in the same subnet as the network interface, and says to send all traffic directly (without an "next hop" router) from that interface. 


Run 


```
route -n
```

on each host, and observe the directly connected route. Save the routing tables for your lab report. 
