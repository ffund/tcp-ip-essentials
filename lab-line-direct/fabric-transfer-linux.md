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
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - Save a packet capture to a file and analyze it in Wireshark

:::


::: {.cell .code}
```python
romeo_file_pcap = "/home/ubuntu/romeo-tcpdump-file.pcap"
romeo_exec.download_file(os.path.abspath('romeo-tcpdump-file.pcap'), romeo_file_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - Useful display options and capture options in tcpdump

:::


::: {.cell .code}
```python
romeo_snaplen_pcap = "/home/ubuntu/romeo-tcpdump-snaplen.pcap"
romeo_exec.download_file(os.path.abspath('romeo-tcpdump-snaplen.pcap'), romeo_snaplen_pcap)
```
:::