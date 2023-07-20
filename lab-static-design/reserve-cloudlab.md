## Cloudlab-specific instructions: Reserve resources

For this experiment, you will reserve a topology that includes three routers (router-a, router-b, and router-c) and two hosts connected to each router. The routers will already be configured with IP addresses (in the 10.1.10.0/24 subnet) on the link that connects the routers to one another. However, it will be up to you to design subnets for the small LAN connected to each router.

The topology will look like the following:

![](subnet-design-topology.png)

To reserve resources on Cloudlab, open this profile page:

https://www.cloudlab.us/p/nyunetworks/education?refspec=refs/heads/design_subnets_22

Click "next", then select the Cloudlab project that you are part of and a Cloudlab cluster with available resources. (This experiment is compatible with any of the Cloudlab clusters.) Then click "next", and "finish".

Wait until all of the sources have turned green and have a small check mark in the top right corner of the "topology view" tab, indicating that they are fully configured and ready to log in. Then, click on "list view" to get SSH login details for the nodes.

Use `ip addr` to view the network interface configuration on each host, and save the output for your own reference. 

In particular, make sure to note **the name of the interface on each router that is on the 10.1.10.0/24 subnet** (Routing LAN), and the name of the interface that has no assigned address yet (LAN).