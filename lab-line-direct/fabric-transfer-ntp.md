::: {.cell .markdown}
### Retrieve files from the experiment
:::


::: {.cell .markdown}

As you complete each part of the experiment, you may choose to transfer packet captures from the remote hosts to this Jupyter environment. Then, you can download them from the Jupyter environment to open in Wireshark.

To download a file from the Jupyter environment, use the file browser on the left side. You may need to use the "Refresh" button to see the updated file list after transferring a file. Then, you can right-click on a file and select "Download" to download it to your own computer.

:::


::: {.cell .markdown}
#### Packet Captures for Exercise - IP layer limit and fragmentation

:::


::: {.cell .code}
```python
import os
client_node = # TODO: fill in whichever node on which you run 'ntpdate' ("romeo" or "juliet")
client_exec = slice.get_node(client_node)
client_name = client_exec.execute("hostname", quiet=True)[0].strip()
```
:::

::: {.cell .code}
```python
client_pcap = "/home/ubuntu/ntp-%s.pcap" %  client_name
client_exec.download_file(os.path.abspath('ntp-%s.pcap' % client_node), client_pcap)
```
:::