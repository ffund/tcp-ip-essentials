## FABRIC-specific instructions: Reserve resources

For this experiment, we will use a topology with four connected workstations on a single network segment, with IP addresses configured as follows:

* romeo: 10.10.0.100
* juliet: 10.10.0.101
* hamlet: 10.10.0.102
* ophelia: 10.10.0.103

each with a netmask of 255.255.255.0.

To run this experiment on FABRIC, open the JupyterHub environment on FABRIC, open a shell, and run

```
git clone https://github.com/ffund/tcp-ip-essentials.git
git checkout wip
cd tcp-ip-essentials/lab-l2-arp
```

Then open the notebook titled "setup.ipynb".

Follow along inside the notebook to reserve resources and get the login details for each node in the experiment.