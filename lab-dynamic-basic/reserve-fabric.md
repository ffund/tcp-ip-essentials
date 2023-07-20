## FABRIC-specific instructions: Reserve resources

For this experiment, we will use a topology with four routers in a ring, and a host connected to each LAN.

The topology for this experiment, with the IP address of each interface, is illustrated in the following diagram:

<img src="rip-topology.svg" width="500px">

The topology has four LANs:

* 10.10.61.0/24 (LAN 61)
* 10.10.62.0/24 (LAN 62)
* 10.10.63.0/24 (LAN 63)
* 10.10.64.0/24 (LAN 64)

For convenience, the last octet of each IP address is the router index (for routers) or 100 (for workstations), so that it is easy to identify.

To run this experiment on FABRIC, open the JupyterHub environment on FABRIC, open a shell, and run

```
git clone https://github.com/ffund/tcp-ip-essentials.git
git checkout wip
```

In the File Browser on the left, first go to the directory "tcp-ip-essentials", and then go to the directory "lab-dynamic-basic".

Then open the notebook titled "setup.ipynb".

Follow along inside the notebook to reserve resources and get the login details for each node in the experiment.

Before you start, use `ip addr` to capture the network interface configuration of each host and router in this topology. Save this for your reference.

On boot, each workstation and router will only have routing rules for subnets that it directly connects to (and for the control interface). It will not have routing rules for other subnets in the experiment topology. Confirm this with

```
ip route
```
