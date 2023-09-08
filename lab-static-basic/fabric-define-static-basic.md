::: {.cell .markdown}
### Define configuration for Static Routing experiment
:::

::: {.cell .code}
```python
slice_name="static-basic-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "juliet", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "hamlet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "ophelia",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-1", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-2", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-3", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "othello",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.0.0/24", "nodes": [{"name": "romeo", "addr": "10.10.0.100"}, {"name": "juliet", "addr": "10.10.0.101"}, {"name": "hamlet", "addr": "10.10.0.102"}, {"name": "ophelia", "addr": "10.10.0.103"}, {"name": "router-1", "addr": "10.10.0.1"}]},
 {"name": "net1", "subnet": "10.10.100.0/24", "nodes": [{"name": "router-1", "addr": "10.10.100.1"}, {"name": "router-2", "addr": "10.10.100.2"}, {"name": "router-3", "addr": "10.10.100.3"}]},
 {"name": "net2", "subnet": "10.10.1.0/24", "nodes": [{"name": "othello", "addr": "10.10.1.104"}, {"name": "router-2", "addr": "10.10.1.1"}]},
 {"name": "net3", "subnet": "10.10.2.0/24", "nodes": [{"name": "othello", "addr": "10.10.2.104"}, {"name": "router-3", "addr": "10.10.2.1"}]}
]
route_conf = []
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::