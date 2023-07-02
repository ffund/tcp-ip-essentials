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
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: TCP connection refused

:::


::: {.cell .code}
```python
romeo_refused_pcap = "/home/ubuntu/%s-tcp-connection-refused.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tcp-connection-refused.pcap'), romeo_refused_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: TCP connection establishment

:::


::: {.cell .code}
```python
romeo_established_pcap = "/home/ubuntu/%s-tcp-connection-establishment.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tcp-connection-establishment.pcap'), romeo_established_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: TCP bulk transfer

:::


::: {.cell .code}
```python
romeo_bulk_error_pcap = "/home/ubuntu/%s-tcp-bulk-error.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tcp-bulk-error.pcap'), romeo_bulk_error_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: interrupted bulk file transfer

:::


::: {.cell .code}
```python
romeo_bulk_interrupted_pcap = "/home/ubuntu/%s-tcp-bulk-interrupted.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tcp-bulk-interrupted.pcap'), romeo_bulk_interrupted_pcap)
```
:::