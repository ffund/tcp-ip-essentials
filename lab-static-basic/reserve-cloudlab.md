## Cloudlab-specific instructions: Reserve resources

For this experiment, we will use a topology with five hosts, three routers, and four network segments, with addresses on each network interface configured as follows:

![](static-routing-topo.svg)

each with a netmask of 255.255.255.0.

To reserve resources on Cloudlab, open this profile page:

[https://www.cloudlab.us/p/nyunetworks/education?refspec=refs/heads/static_routing](https://www.cloudlab.us/p/nyunetworks/education?refspec=refs/heads/static_routing)

Click "next", then select the Cloudlab project that you are part of and a Cloudlab cluster with available resources. (**For this experiment, avoid the Cloudlab Utah cluster.**) Then click "next", and "finish".

Wait until all of the sources have turned green and have a small check mark in the top right corner of the "topology view" tab, indicating that they are fully configured and ready to log in. Then, click on "list view" to get SSH login details for the nodes.

Use `ip addr` to view the network interface configuration on each host, and save the output for your own reference.
