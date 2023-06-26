::: {.cell .markdown}
### Retrieve files from ARP experiment
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
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - ARP

:::


::: {.cell .code}
```python
romeo_arp_pcap = "/home/ubuntu/%s-arp.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-arp.pcap', romeo_arp_pcap)
```
:::


::: {.cell .code}
```python
romeo_no_arp_pcap = "/home/ubuntu/%s-no-arp.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-no-arp.pcap', romeo_no_arp_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - ARP for a non-existent host

:::

::: {.cell .code}
```python
romeo_eth_pcap = "/home/ubuntu/%s-eth-nonexistent.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-eth-nonexistent.pcap', romeo_eth_pcap)
```
:::

::: {.cell .code}
```python
romeo_lo_pcap = "/home/ubuntu/%s-lo-nonexistent.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-lo-nonexistent.pcap', romeo_lo_pcap)
```
:::



