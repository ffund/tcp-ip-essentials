::: {.cell .markdown}
### Define configuration for the experiment
:::

::: {.cell .code}
```python
slice_name="line-router-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "juliet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "router",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.1.0/24", "nodes": [{"name": "romeo", "addr": "10.10.1.100"}, {"name": "router", "addr": "10.10.1.1"}]},
 {"name": "net1", "subnet": "10.10.2.0/24", "nodes": [{"name": "juliet", "addr": "10.10.2.100"}, {"name": "router", "addr": "10.10.2.1"}]}
]
route_conf = [
 {"addr": "10.10.2.0/24", "gw": "10.10.1.1", "nodes": ["romeo"]},
 {"addr": "10.10.1.0/24", "gw": "10.10.2.1", "nodes": ["juliet"]}
]
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::