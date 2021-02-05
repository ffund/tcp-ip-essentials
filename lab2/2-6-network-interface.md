## 2.6 Network interface exercises

For this experiment, we will use a topology with four connected workstations on a single network segment, with IP addresses configured as follows:

* romeo: 10.10.0.100
* juliet: 10.10.0.101
* hamlet: 10.10.0.102
* ophelia: 10.10.0.103

each with a netmask of 255.255.255.0. 

To set up this topology in the GENI Portal, create a slice, click on "Add Resources", and load the RSpec from the following URL: [https://raw.githubusercontent.com/ffund/tcp-ip-essentials/master/lab2/lab2-single-segment-rspec.xml](https://raw.githubusercontent.com/ffund/tcp-ip-essentials/master/lab2/lab2-single-segment-rspec.xml)

Refer to the [monitor website](https://fedmon.fed4fire.eu/overview/instageni) to identify an InstaGENI site that has many "free VMs" available. Then bind to an InstaGENI site and reserve your resources. Wait for them to become available for login ("turn green" on your canvas) and then SSH into each, using the details given in the GENI Portal.

Before you start, use `ifconfig -a` to capture the network interface configuration of each host in this topology. Save this data for your reference.

Once you are done with this part of the lab , proceed to the [next part](2-7-arp.md)
