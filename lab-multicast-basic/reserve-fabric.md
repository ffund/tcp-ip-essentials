## FABRIC-specific instructions: Reserve resources

First, you will reserve a topology with four hosts and one router, and IP addresses as follows:

* romeo - 10.10.1.100
* juliet - 10.10.1.101
* hamlet - 10.10.1.102
* ophelia - 10.10.2.103
* router - 10.10.1.1 and 10.10.2.1

with netmask 255.255.255.0.

To run this experiment on FABRIC, open the JupyterHub environment on FABRIC, open a shell, and run

```
git clone https://github.com/ffund/tcp-ip-essentials.git
git checkout wip
cd tcp-ip-essentials/lab-l2-arp
```

Then open the notebook titled "setup.ipynb".

Follow along inside the notebook to reserve resources and get the login details for each node in the experiment.