::: {.cell .markdown}
### Retrieve files from the experiment
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
juliet_exec = slice.get_node("juliet")
juliet_name = juliet_exec.execute("hostname", quiet=True)[0].strip()
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: CWND-limited bulk file transfer

:::


::: {.cell .code}
```python
romeo_bulk_cwnd_pcap = "/home/ubuntu/%s-tcp-bulk-cwnd.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tcp-bulk-cwnd.pcap'), romeo_bulk_cwnd_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: RWND-limited bulk file transfer

:::


::: {.cell .code}
```python
romeo_bulk_rwnd_pcap = "/home/ubuntu/%s-tcp-bulk-rwnd.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tcp-bulk-rwnd.pcap'), romeo_bulk_rwnd_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: Explicit congestion notification (ECN)

:::


::: {.cell .code}
```python
romeo_ecn_pcap = "/home/ubuntu/%s-tcp-ecn.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tcp-ecn.pcap'), romeo_ecn_pcap)
```
:::

::: {.cell .code}
```python
juliet_ecn_pcap = "/home/ubuntu/%s-tcp-ecn.pcap" %  juliet_name
juliet_exec.download_file(os.path.abspath('juliet-tcp-ecn.pcap'), juliet_ecn_pcap)
```
:::