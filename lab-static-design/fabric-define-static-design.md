::: {.cell .markdown}
### Define configuration for Static Routing - Subnet Design experiment
:::

::: {.cell .code}
```python
slice_name="static-design-" + fablib.get_bastion_username()

node_conf = [
 {'name': "router-a", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}, 
 {'name': "router-b", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}, 
 {'name': "router-c", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}, 
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}, 
 {'name': "juliet", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}, 
 {'name': "hamlet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}, 
 {'name': "ophelia",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}, 
 {'name': "othello",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']},
 {'name': "desdemona",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['mtr']}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.100.0/24", "nodes": [{"name": "router-a", "addr": "10.10.100.1"}, {"name": "router-b", "addr": "10.10.100.2"}, {"name": "router-c", "addr": "10.10.100.3"}]},
 {"name": "net1", "subnet": None, "nodes": [{"name": "router-a", "addr": None}, {"name": "romeo", "addr": None}, {"name": "juliet", "addr": None}]},
 {"name": "net2", "subnet": None, "nodes": [{"name": "router-b", "addr": None}, {"name": "hamlet", "addr": None}, {"name": "ophelia", "addr": None}]},
 {"name": "net3", "subnet": None, "nodes": [{"name": "router-c", "addr": None}, {"name": "othello", "addr": None}, {"name": "desdemona", "addr": None}]}
]
route_conf = []
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::