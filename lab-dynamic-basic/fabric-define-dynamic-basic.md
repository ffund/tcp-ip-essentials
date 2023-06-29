::: {.cell .markdown}
### Define configuration for Dynamic Routing experiment
:::

::: {.cell .code}
```python
slice_name="dynamic-basic-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "hamlet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "othello",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "petruchio", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-1", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-2", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-3", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-4", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.61.0/24", "nodes": [{"name": "romeo", "addr": "10.10.61.100"}, {"name": "router-1", "addr": "10.10.61.1"}, {"name": "router-4", "addr": "10.10.61.4"}]},
 {"name": "net1", "subnet": "10.10.62.0/24", "nodes": [{"name": "hamlet", "addr": "10.10.62.100"}, {"name": "router-1", "addr": "10.10.62.1"}, {"name": "router-2", "addr": "10.10.62.2"}]},
 {"name": "net2", "subnet": "10.10.63.0/24", "nodes": [{"name": "othello", "addr": "10.10.63.100"}, {"name": "router-2", "addr": "10.10.63.2"}, {"name": "router-3", "addr": "10.10.63.3"}]},
 {"name": "net3", "subnet": "10.10.64.0/24", "nodes": [{"name": "petruchio", "addr": "10.10.64.100"}, {"name": "router-3", "addr": "10.10.64.3"}, {"name": "router-4", "addr": "10.10.64.4"}]}
]
route_conf = []
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::