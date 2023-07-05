::: {.cell .markdown}
### Define configuration for SNMP and Network Security experiment
:::

::: {.cell .code}
```python
slice_name="multicast-basic-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "router-int",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "server", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "vpn",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "router-ext",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}, 
 {'name': "juliet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.1.0/24", "nodes": [{"name": "romeo", "addr": "10.10.1.100"}, {"name": "router-int", "addr": "10.10.1.1"}]},
 {"name": "net1", "subnet": "10.10.2.0/24", "nodes": [{"name": "server", "addr": "10.10.2.100"}, {"name": "router-int", "addr": "10.10.2.1"}]},
 {"name": "net2", "subnet": "10.10.3.0/24", "nodes": [{"name": "vpn", "addr": "10.10.3.100"}, {"name": "router-int", "addr": "10.10.3.1"}]},
 {"name": "net3", "subnet": "10.10.4.0/24", "nodes": [{"name": "vpn", "addr": "10.10.4.100"}, {"name": "router-ext", "addr": "10.10.4.1"}]},
 {"name": "net4", "subnet": "10.10.5.0/24", "nodes": [{"name": "juliet", "addr": "10.10.5.100"}, {"name": "router-ext", "addr": "10.10.5.1"}]}
]
route_conf = [
 {"addr": "10.10.2.0/24", "gw": "10.10.1.1", "nodes": ["romeo"]},
 {"addr": "10.10.3.0/24", "gw": "10.10.1.1", "nodes": ["romeo"]},
 {"addr": "10.10.4.0/24", "gw": "10.10.1.1", "nodes": ["romeo"]},
 {"addr": "10.10.5.0/24", "gw": "10.10.1.1", "nodes": ["romeo"]},
 {"addr": "10.10.1.0/24", "gw": "10.10.2.1", "nodes": ["server"]},
 {"addr": "10.10.3.0/24", "gw": "10.10.2.1", "nodes": ["server"]},
 {"addr": "10.10.4.0/24", "gw": "10.10.2.1", "nodes": ["server"]},
 {"addr": "10.10.5.0/24", "gw": "10.10.2.1", "nodes": ["server"]},
 {"addr": "10.10.4.0/24", "gw": "10.10.3.100", "nodes": ["router-int"]},
 {"addr": "10.10.5.0/24", "gw": "10.10.3.100", "nodes": ["router-int"]},
 {"addr": "10.10.1.0/24", "gw": "10.10.3.1", "nodes": ["vpn"]},
 {"addr": "10.10.2.0/24", "gw": "10.10.3.1", "nodes": ["vpn"]},
 {"addr": "10.10.5.0/24", "gw": "10.10.4.1", "nodes": ["vpn"]},
 {"addr": "10.10.1.0/24", "gw": "10.10.4.100", "nodes": ["router-ext"]},
 {"addr": "10.10.2.0/24", "gw": "10.10.4.100", "nodes": ["router-ext"]},
 {"addr": "10.10.3.0/24", "gw": "10.10.4.100", "nodes": ["router-ext"]},
 {"addr": "10.10.1.0/24", "gw": "10.10.5.1", "nodes": ["juliet"]},
 {"addr": "10.10.2.0/24", "gw": "10.10.5.1", "nodes": ["juliet"]},
 {"addr": "10.10.3.0/24", "gw": "10.10.5.1", "nodes": ["juliet"]},
 {"addr": "10.10.4.0/24", "gw": "10.10.5.1", "nodes": ["juliet"]}
]
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::