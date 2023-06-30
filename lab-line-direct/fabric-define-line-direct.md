::: {.cell .markdown}
### Define configuration for the experiment
:::

::: {.cell .code}
```python
slice_name="line-direct-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "juliet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.0.0/24", "nodes": [{"name": "romeo", "addr": "10.10.0.100"}, {"name": "juliet", "addr": "10.10.0.101"}]}
]
route_conf = []
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::