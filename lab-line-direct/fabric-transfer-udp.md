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
#### Packet Captures for Exercise - IP layer limit and fragmentation

:::


::: {.cell .code}
```python
romeo_no_fragment_pcap = "/home/ubuntu/%s-no-ip-fragment.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-no-ip-fragment.pcap'), romeo_no_fragment_pcap)
```
:::


::: {.cell .code}
```python
romeo_fragment_pcap = "/home/ubuntu/%s-ip-fragment.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-ip-fragment.pcap'), romeo_fragment_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - FTP and TFTP operation

:::


::: {.cell .code}
```python
romeo_ftp_pcap = "/home/ubuntu/%s-ftp-large.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-ftp-large.pcap'), romeo_ftp_pcap)
```
:::


::: {.cell .code}
```python
romeo_tftp_pcap = "/home/ubuntu/%s-tftp-large.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tftp-large.pcap'), romeo_tftp_pcap)
```
:::


::: {.cell .code}
```python
romeo_tftp_blocksize_pcap = "/home/ubuntu/%s-tftp-large-blocksize.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tftp-large-blocksize.pcap'), romeo_tftp_blocksize_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - TFTP packets

:::


::: {.cell .code}
```python
romeo_tftp_small_pcap = "/home/ubuntu/%s-tftp-small.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-tftp-small.pcap'), romeo_tftp_small_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - FTP packets when not using passive mode

:::


::: {.cell .code}
```python
romeo_ftp_small_pcap = "/home/ubuntu/%s-ftp-small.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-ftp-small.pcap'), romeo_ftp_small_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise - FTP packets in passive mode

:::


::: {.cell .code}
```python
romeo_ftp_passive_pcap = "/home/ubuntu/%s-ftp-small-passive.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('romeo-ftp-small-passive.pcap'), romeo_ftp_passive_pcap)
```
:::