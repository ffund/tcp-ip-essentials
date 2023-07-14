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
# Add hosts to the multicast group RIPv2 uses
for i, node_name in enumerate(["romeo", "hamlet", "othello", "petruchio"]):
    host_node = slice.get_node(node_name)
    host_node.execute("sudo ip maddr add 01:00:5e:00:00:09 dev $(ip route get 10.10.6%i.0 | grep -oP "(?<=dev )[^ ]+")" % i)
```
:::