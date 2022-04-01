## Reserve resources 

In this exercise and the ones that follow, we'll examine these features of TCP.

For these experiments, we will use a topology with two workstations (named "romeo" and "juliet"), and a router in between them, with IP addresses configured as follows:

* romeo: 10.10.1.100
* router, interface connected to romeo: 10.10.1.1
* router, interface connected to juliet: 10.10.2.1
* juliet: 10.10.2.100

each with a netmask of 255.255.255.0. 

To set up this topology in the GENI Portal, create a slice, click on "Add Resources", and load the RSpec from the following URL: https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/rspecs/line-tso-off.xml

Refer to the [monitor website](https://fedmon.fed4fire.eu/overview/instageni) to identify an InstaGENI site that has many "free VMs" available. Then bind to an InstaGENI site and reserve your resources. Wait for them to become available for login ("turn green" on your canvas) and then SSH into each, using the details given in the GENI Portal.
