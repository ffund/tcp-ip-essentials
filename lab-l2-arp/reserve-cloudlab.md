## Cloudlab-specific instructions: Reserve resources

For this experiment, we will use a topology with four connected workstations on a single network segment, with IP addresses configured as follows:

* romeo: 10.10.0.100
* juliet: 10.10.0.101
* hamlet: 10.10.0.102
* ophelia: 10.10.0.103

each with a netmask of 255.255.255.0.

To reserve these resources on Cloudlab, open this profile page:

https://www.cloudlab.us/p/nyunetworks/education?refspec=refs/heads/lan_one_segment

Click "next", then select the Cloudlab project that you are part of and a Cloudlab cluster with available resources. (This experiment is compatible with any of the Cloudlab clusters.) Then click "next", and "finish".

Wait until all of the sources have turned green and have a small check mark in the top right corner of the "topology view" tab, indicating that they are fully configured and ready to log in. Then, click on "list view" to get SSH login details for the client, router, and server hosts, and SSH into each.