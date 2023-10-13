## Cloudlab-specific instructions: Reserve resources

For this experiment, we will use a topology with two workstations (named "romeo" and "juliet"), and a router in between them, with IP addresses configured as follows:

* romeo: 10.0.1.100
* router, interface connected to romeo: 10.0.1.1
* router, interface connected to juliet: 10.0.2.1
* juliet: 10.0.2.100

each with a netmask of 255.255.255.0.

To reserve these resources on Cloudlab, open this profile page:

[https://www.cloudlab.us/p/nyunetworks/education?refspec=refs/heads/line_udp](https://www.cloudlab.us/p/nyunetworks/education?refspec=refs/heads/line_udp)

Click "next", then select the Cloudlab project that you are part of and a Cloudlab cluster with available resources. (This experiment is compatible with any of the Cloudlab clusters.) Then click "next", and "finish".

Wait until all of the resources have turned green and have a small check mark in the top right corner of the "topology view" tab, indicating that they are fully configured and ready to log in. Then, click on "list view" to get SSH login details for the nodes.
