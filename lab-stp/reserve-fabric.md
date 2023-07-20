## FABRIC-specific instructions: Reserve resources

First, you will reserve a topology that includes four bridges connected in a loop. There is also one host on each network segment:

![](spanning-tree-topo.svg)

To run this experiment on FABRIC, open the JupyterHub environment on FABRIC, open a shell, and run

```
git clone https://github.com/ffund/tcp-ip-essentials.git
git checkout wip
cd tcp-ip-essentials/lab-stp
```

Then open the notebook titled "setup.ipynb".

Follow along inside the notebook to reserve resources and get the login details for each node in the experiment.