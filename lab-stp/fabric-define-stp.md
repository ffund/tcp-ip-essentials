::: {.cell .markdown}
### Define configuration for Spanning Tree experiment
:::

::: {.cell .code}
```python
slice_name="l2-stp-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "hamlet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "othello",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "petruchio", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "bridge-1", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "bridge-2", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "bridge-3", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "bridge-4", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.0.0/24", "nodes": [{"name": "hamlet", "addr": "10.10.0.102"}, {"name": "bridge-1", "addr": None}, {"name": "bridge-2", "addr": None}]},
 {"name": "net1", "subnet": "10.10.0.0/24", "nodes": [{"name": "othello", "addr": "10.10.0.104"}, {"name": "bridge-2", "addr": None}, {"name": "bridge-3", "addr": None}]},
 {"name": "net2", "subnet": "10.10.0.0/24", "nodes": [{"name": "petruchio", "addr": "10.10.0.106"}, {"name": "bridge-1", "addr": None}, {"name": "bridge-4", "addr": None}]},
 {"name": "net3", "subnet": "10.10.0.0/24", "nodes": [{"name": "romeo", "addr": "10.10.0.100"}, {"name": "bridge-3", "addr": None}, {"name": "bridge-4", "addr": None}]}
]
route_conf = []
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::