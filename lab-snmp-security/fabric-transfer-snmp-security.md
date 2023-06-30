::: {.cell .markdown}
### Retrieve files from SNMP and Network Security experiment
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
server_exec = slice.get_node("server")
server_name = server_exec.execute("hostname", quiet=True)[0].strip()
router_int_exec = slice.get_node("router-int")
router_int_name = router_int_exec.execute("hostname", quiet=True)[0].strip()
router_ext_exec = slice.get_node("router-ext")
router_ext_name = router_ext_exec.execute("hostname", quiet=True)[0].strip()
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: Retrieving SNMP data

:::


::: {.cell .code}
```python
romeo_public_pcap = "/home/ubuntu/snmpwalk-public-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('snmpwalk-public-romeo.pcap'), romeo_public_pcap)
server_public_pcap = "/home/ubuntu/snmpwalk-public-%s.pcap" %  server_name
server_exec.download_file(os.path.abspath('snmpwalk-public-server.pcap'), server_public_pcap)
```
:::

::: {.cell .code}
```python
romeo_secret_pcap = "/home/ubuntu/snmpwalk-secret-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('snmpwalk-secret-romeo.pcap'), romeo_secret_pcap)
server_secret_pcap = "/home/ubuntu/snmpwalk-secret-%s.pcap" %  server_name
server_exec.download_file(os.path.abspath('snmpwalk-secret-server.pcap'), server_secret_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: Remote login

:::


::: {.cell .code}
```python
romeo_telnet_pcap = "/home/ubuntu/security-telnet-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('security-telnet-romeo.pcap'), romeo_telnet_pcap)
```
:::

::: {.cell .code}
```python
romeo_ssh_pcap = "/home/ubuntu/security-ssh-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('security-ssh-romeo.pcap'), romeo_ssh_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: File transfer

:::


::: {.cell .code}
```python
romeo_ftp_pcap = "/home/ubuntu/security-ftp-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('security-ftp-romeo.pcap'), romeo_ftp_pcap)
```
:::

::: {.cell .code}
```python
romeo_sftp_pcap = "/home/ubuntu/security-sftp-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('security-sftp-romeo.pcap'), romeo_sftp_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: Web access

:::


::: {.cell .code}
```python
romeo_http_pcap = "/home/ubuntu/security-http-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('security-http-romeo.pcap'), romeo_http_pcap)
```
:::

::: {.cell .code}
```python
romeo_https_pcap = "/home/ubuntu/security-https-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('security-https-romeo.pcap'), romeo_https_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: VPN

:::


::: {.cell .code}
```python
router_ext_vpn_pcap = "/home/ubuntu/vpn-%s.pcap" %  router_ext_name
router_ext_exec.download_file(os.path.abspath('vpn-router-ext.pcap'), router_ext_vpn_pcap)
router_int_vpn_pcap = "/home/ubuntu/vpn-%s.pcap" %  router_int_name
router_int_exec.download_file(os.path.abspath('vpn-router-int.pcap'), router_int_vpn_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: Firewall with drop rule

:::


::: {.cell .code}
```python
romeo_drop_pcap = "/home/ubuntu/iptables-drop-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('iptables-drop-romeo.pcap'), romeo_drop_pcap)
```
:::


::: {.cell .markdown}
#### Packet Captures for Exercise: Firewall with TCP RST reject

:::


::: {.cell .code}
```python
romeo_reset_pcap = "/home/ubuntu/iptables-reset-%s.pcap" %  romeo_name
romeo_exec.download_file(os.path.abspath('iptables-reset-romeo.pcap'), romeo_reset_pcap)
```
:::