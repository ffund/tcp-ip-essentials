::: {.cell .code}
```python
# Flush IPv6 addresses on all interfaces
for net in net_conf:
    for n in net['nodes']:
        if_name = n['name'] + '-' + net['name'] + '-p1'
        iface = slice.get_interface(if_name)
        iface.get_node().execute("sudo ip -6 addr flush dev %s"  % iface.get_device_name())
```
:::

::: {.cell .code}
```python
# Disable IPv6 on all nodes
for n in slice.get_nodes():
    n.execute("sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1")
```
:::