::: {.cell .markdown}
### Retrieve files from Dynamic Routing experiment
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
    ("romeo", romeo_exec, romeo_name),
    ("hamlet", hamlet_exec, hamlet_name),
    ("othello", othello_exec, othello_name),
    ("petruchio", petruchio_exec, petruchio_name)
]
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - Set up RIP

:::

::: {.cell .code}
```python
for node_name, host_exec, host_name in host_vars:
    host_rip_pcap = "/home/ubuntu/%s-rip.pcap" % host_name
    host_exec.download_file(os.path.abspath('%s-rip.pcap' % node_name), host_rip_pcap)
```
:::

::: {.cell .markdown}
#### Packet Captures for Exercise - RIP response to link failure

:::

::: {.cell .code}
```python
for node_name, host_exec, host_name in host_vars:
    host_fail_pcap = "/home/ubuntu/%s-rip-failure.pcap" % host_name
    host_exec.download_file(os.path.abspath('%s-rip-failure.pcap' % node_name), host_fail_pcap)
```
:::

::: {.cell .markdown}
#### Packet Captures for Exercise - traceroute

:::

::: {.cell .code}
```python
for node_name, host_exec, host_name in host_vars:
    if (node_name == "romeo" || node_name == "othello"):
        host_traceroute_pcap = "/home/ubuntu/%s-traceroute.pcap" % host_name
        host_exec.download_file(os.path.abspath('%s-traceroute.pcap' % node_name), host_traceroute_pcap)
```
:::

::: {.cell .markdown}
#### Packet Captures for Exercise - ICMP redirect

:::

::: {.cell .code}
```python
romeo_redirect_1_pcap = "/home/ubuntu/%s-redirect-1.pcap" % romeo_name
romeo_exec.download_file(os.path.abspath('romeo-redirect-1.pcap'), romeo_redirect_1_pcap)
```
:::

::: {.cell .code}
```python
romeo_redirect_2_pcap = "/home/ubuntu/%s-redirect-2.pcap" % romeo_name
romeo_exec.download_file(os.path.abspath('romeo-redirect-2.pcap'), romeo_redirect_2_pcap)
```
:::

::: {.cell .markdown}
#### Packet Captures for Exercise - Destination unreachable, network unreachable

:::

::: {.cell .code}
```python
romeo_net_unreachable_pcap = "/home/ubuntu/%s-icmp-dest-net-unreachable.pcap" % romeo_name
romeo_exec.download_file(os.path.abspath('%s-icmp-dest-net-unreachable.pcap'), romeo_net_unreachable_pcap)
```
:::

::: {.cell .markdown}
#### Packet Captures for Exercise - Destination unreachable, host unreachable

:::

::: {.cell .code}
```python
for node_name, host_exec, host_name in host_vars:
    if (node_name == "romeo" || node_name == "hamlet"):
        host_host_unreachable_pcap = "/home/ubuntu/%s-icmp-dest-host-unreachable.pcap" % host_name
        host_exec.download_file(os.path.abspath('%s-icmp-dest-host-unreachable.pcap' % node_name), host_host_unreachable_pcap)
```
:::