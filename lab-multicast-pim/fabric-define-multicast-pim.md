::: {.cell .markdown}
### Define configuration for Multicast Routing with PIM experiment
:::

::: {.cell .code}
```python
slice_name="multicast-pim-" + fablib.get_bastion_username()

node_conf = [
 {'name': "romeo",   'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['vlc']}, 
 {'name': "juliet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['vlc']}, 
 {'name': "hamlet",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['vlc']}, 
 {'name': "ophelia", 'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['vlc']},
 {'name': "source1",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['vlc']},
 {'name': "source2",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': ['vlc']},
 {'name': "rp",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "cr1",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "cr2",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "fhr1",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "fhr2",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "lhr1",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []},
 {'name': "lhr2",  'cores': 2, 'ram': 4, 'disk': 10, 'image': 'default_ubuntu_22', 'packages': []}
]
net_conf = [
 {"name": "net0", "subnet": "10.10.1.0/24", "nodes": [{"name": "rp", "addr": "10.10.1.100"}, {"name": "cr1", "addr": "10.10.1.1"}, {"name": "cr2", "addr": "10.10.1.2"}]},
 {"name": "net1", "subnet": "10.10.11.0/24", "nodes": [{"name": "fhr1", "addr": "10.10.11.2"}, {"name": "cr1", "addr": "10.10.11.1"}]},
 {"name": "net2", "subnet": "10.10.12.0/24", "nodes": [{"name": "fhr2", "addr": "10.10.12.2"}, {"name": "cr1", "addr": "10.10.12.1"}]},
 {"name": "net3", "subnet": "10.10.21.0/24", "nodes": [{"name": "lhr1", "addr": "10.10.21.2"}, {"name": "cr2", "addr": "10.10.21.1"}]},
 {"name": "net4", "subnet": "10.10.22.0/24", "nodes": [{"name": "lhr2", "addr": "10.10.22.2"}, {"name": "cr2", "addr": "10.10.22.1"}]},
 {"name": "net5", "subnet": "10.10.101.0/24", "nodes": [{"name": "source1", "addr": "10.10.101.2"}, {"name": "fhr1", "addr": "10.10.101.1"}]},
 {"name": "net6", "subnet": "10.10.102.0/24", "nodes": [{"name": "source2", "addr": "10.10.102.2"}, {"name": "fhr2", "addr": "10.10.102.1"}]},
 {"name": "net7", "subnet": "10.10.103.0/24", "nodes": [{"name": "romeo", "addr": "10.10.103.2"}, {"name": "juliet", "addr": "10.10.103.3"}, {"name": "lhr1", "addr": "10.10.103.1"}]},
 {"name": "net8", "subnet": "10.10.104.0/24", "nodes": [{"name": "hamlet", "addr": "10.10.104.2"}, {"name": "ophelia", "addr": "10.10.104.3"}, {"name": "lhr2", "addr": "10.10.104.1"}]}
]
route_conf = []
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::