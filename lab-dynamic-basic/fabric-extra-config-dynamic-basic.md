::: {.cell .code}
```python
# Install and configure FRR on routers
for i in range(4):
    router_node = slice.get_node("router-%i" % (i + 1))
    router_node.execute("curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -")
    router_node.execute("echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) frr-stable | sudo tee -a /etc/apt/sources.list.d/frr.list")
    router_node.execute("sudo apt update; sudo apt -y install frr frr-pythontools nload", quiet=True)
    router_node.execute("sudo sed -i 's/zebrad=no/zebrad=yes/g' /etc/frr/daemons")
    router_node.execute("sudo sed -i 's/ripd=no/ripd=yes/g' /etc/frr/daemons")
    router_node.execute("sudo systemctl restart frr.service")
```
:::