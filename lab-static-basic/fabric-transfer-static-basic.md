::: {.cell .markdown}
### Retrieve files from Static Routing experiment
:::


::: {.cell .markdown}

As you complete each part of the experiment, you may choose to transfer packet captures from the remote hosts to this Jupyter environment. Then, you can download them from the Jupyter environment to open in Wireshark.

To download a file from the Jupyter environment, use the file browser on the left side. You may need to use the "Refresh" button to see the updated file list after transferring a file. Then, you can right-click on a file and select "Download" to download it to your own computer.

:::


::: {.cell .code}
```python
import os
romeo_exec = slice.get_node("romeo")
romeo_name = romeo_exec.execute("hostname", quiet=True)[0].strip()
othello_exec = slice.get_node("othello")
othello_name = othello_exec.execute("hostname", quiet=True)[0].strip()
router1_exec = slice.get_node("router-1")
router1_name = router1_exec.execute("hostname", quiet=True)[0].strip()
router2_exec = slice.get_node("router-2")
router2_name = router2_exec.execute("hostname", quiet=True)[0].strip()
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - network unreachable

:::

::: {.cell .code}
```python
romeo_net_pcap = "/home/ubuntu/%s-net-unreachable.pcap" % romeo_name
romeo_exec.download_file(os.path.abspath('romeo-net-unreachable.pcap'), romeo_net_pcap)
```
:::

::: {.cell .code}
```python
romeo_host_pcap = "/home/ubuntu/%s-host-unreachable.pcap" % romeo_name
romeo_exec.download_file(os.path.abspath('romeo-host-unreachable.pcap'), romeo_host_pcap)
```
:::

::: {.cell .markdown}
#### Packet Captures for Exercise - packet headers

:::

::: {.cell .code}
```python
romeo_header_pcap = "/home/ubuntu/%s-static-headers.pcap" % romeo_name
romeo_exec.download_file(os.path.abspath('romeo-static-headers.pcap'), romeo_header_pcap)
```
:::

::: {.cell .code}
```python
var_list = [
    ("othello", othello_exec, othello_name),
    ("router-1", router1_exec, router1_name),
    ("router-2", router2_exec, router2_name)
]
for node_name, host_exec, host_name:
    host_1_header_pcap = "/home/ubuntu/%s-1-static-headers.pcap" % host_name
    host_exec.download_file(os.path.abspath('%s-1-static-headers.pcap' % node_name), host_1_header_pcap)
    host_2_header_pcap = "/home/ubuntu/%s-2-static-headers.pcap" % host_name
    host_exec.download_file(os.path.abspath('%s-2-static-headers.pcap' % node_name), host_2_header_pcap)
```
:::
