::: {.cell .markdown}
### Retrieve files from Multicast experiment
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
router_exec = slice.get_node("router")
router_name = router_exec.execute("hostname", quiet=True)[0].strip()
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - MAC addresses for multicast, broadcast, and unicast addresses

:::


::: {.cell .code}
```python
romeo_mac_pcap = "/home/ubuntu/simple-multicast-mac-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('simple-multicast-mac-romeo.pcap'), romeo_mac_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - Receiving traffic for a multicast group

:::


::: {.cell .code}
```python
router_net1_pcap = "/home/ubuntu/simple-multicast-net1-group-%s.pcap" %  router_name
router_exec.download_file(os.path.abspath('simple-multicast-net1-group-router.pcap'), router_net1_pcap)
router_net2_pcap = "/home/ubuntu/simple-multicast-net2-group-%s.pcap" %  router_name
router_exec.download_file(os.path.abspath('simple-multicast-net2-group-router.pcap'), router_net2_pcap)
```
:::