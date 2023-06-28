::: {.cell .markdown}
### Define configuration for Bridge experiments
:::

::: {.cell .code}
```python
slice_name="l2-bridge-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "juliet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "hamlet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "ophelia", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "bridge",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.0.0.0/24", "nodes": [{"name": "romeo", "addr": "10.0.0.1"}, {"name": "bridge", "addr": None}]},
 {"name": "net1", "subnet": "10.0.0.0/24", "nodes": [{"name": "juliet", "addr": "10.0.0.2"}, {"name": "bridge", "addr": None}]},
 {"name": "net2", "subnet": "10.0.0.0/24", "nodes": [{"name": "hamlet", "addr": "10.0.0.3"}, {"name": "bridge", "addr": None}]},
 {"name": "net3", "subnet": "10.0.0.0/24", "nodes": [{"name": "ophelia", "addr": "10.0.0.4"}, {"name": "bridge", "addr": None}]}
]
route_conf = []
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::