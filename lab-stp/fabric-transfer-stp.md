::: {.cell .markdown}
### Retrieve files from Spanning Tree experiment
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
hamlet_exec = slice.get_node("hamlet")
hamlet_name = hamlet_exec.execute("hostname", quiet=True)[0].strip()
othello_exec = slice.get_node("othello")
othello_name = othello_exec.execute("hostname", quiet=True)[0].strip()
petruchio_exec = slice.get_node("petruchio")
petruchio_name = petruchio_exec.execute("hostname", quiet=True)[0].strip()

host_vars = [
    (romeo_exec, romeo_name),
    (hamlet_exec, hamlet_name),
    (othello_exec, othello_name),
    (petruchio_exec, petruchio_name)
]
```
:::


::: {.cell .markdown}
#### Packet Captures for Network of one bridge

:::

::: {.cell .code}
```python
for host_exec, host_name in host_vars:
    host_1_pcap = "/home/ubuntu/stp-%s-1.pcap" % host_name
    host_exec.download_file(os.path.abspath('stp-%s-1.pcap' % host_name, host_1_pcap))
```
:::

::: {.cell .markdown}
#### Packet Captures for Network of two bridges

:::

::: {.cell .code}
```python
for host_exec, host_name in host_vars:
    host_2_pcap = "/home/ubuntu/stp-%s-2.pcap" % host_name
    host_exec.download_file(os.path.abspath('stp-%s-2.pcap' % host_name, host_2_pcap))
```
:::

::: {.cell .markdown}
#### Packet Captures for Network of three bridges

:::

::: {.cell .code}
```python
for host_exec, host_name in host_vars:
    host_3_pcap = "/home/ubuntu/stp-%s-3.pcap" % host_name
    host_exec.download_file(os.path.abspath('stp-%s-3.pcap' % host_name, host_3_pcap))
```
:::

::: {.cell .markdown}
#### Packet Captures for Network of four bridges

:::

::: {.cell .code}
```python
for host_exec, host_name in host_vars:
    host_4_pcap = "/home/ubuntu/stp-%s-4.pcap" % host_name
    host_exec.download_file(os.path.abspath('stp-%s-4.pcap' % host_name, host_4_pcap))
```
:::

::: {.cell .markdown}
#### Packet Captures for Adapt to changes in the topology

:::

::: {.cell .code}
```python
for host_exec, host_name in host_vars:
    host_change_pcap = "/home/ubuntu/stp-change-%s.pcap" %  host_name
    host_exec.download_file(os.path.abspath('stp-change-%s.pcap' % host_name, host_change_pcap))
```
:::



