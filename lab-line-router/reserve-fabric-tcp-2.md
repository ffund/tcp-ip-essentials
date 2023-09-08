## FABRIC-specific instructions: Reserve resources

For this experiment, we will use a topology with two workstations (named "romeo" and "juliet"), and a router in between them, with IP addresses configured as follows:

* romeo: 10.10.1.100
* router, interface connected to romeo: 10.10.1.1
* router, interface connected to juliet: 10.10.2.1
* juliet: 10.10.2.100

each with a netmask of 255.255.255.0.

To run this experiment on FABRIC, open the JupyterHub environment on FABRIC, open a shell, and run

```
git clone https://github.com/ffund/tcp-ip-essentials.git
git checkout wip
```

In the File Browser on the left, first go to the directory "tcp-ip-essentials", and then go to the directory "lab-line-router".

Then open the notebook titled "setup-tcp-2.ipynb".

Follow along inside the notebook to reserve resources and get the login details for each node in the experiment.