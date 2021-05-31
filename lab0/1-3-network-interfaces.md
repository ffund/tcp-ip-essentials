## Inspect network interfaces

### Exercise - Identify experiment and control interfaces

Make sure you have a terminal window logged in to each host - romeo, juliet, and the router. Then, run

```
ifconfig -a
```

on each host in your topology, and examine the output.


```
eth0      Link encap:Ethernet  HWaddr 02:0d:1e:c3:c3:dc  
          inet addr:172.17.1.33  Bcast:172.31.255.255  Mask:255.240.0.0
          inet6 addr: fe80::d:1eff:fec3:c3dc/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:17561 errors:0 dropped:0 overruns:0 frame:0
          TX packets:14740 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:11047161 (11.0 MB)  TX bytes:1175202 (1.1 MB)

eth1      Link encap:Ethernet  HWaddr 02:d8:ce:5b:bc:45  
          inet addr:10.0.0.2  Bcast:10.0.0.255  Mask:255.255.255.0
          inet6 addr: fe80::d8:ceff:fe5b:bc45/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:44 errors:0 dropped:0 overruns:0 frame:0
          TX packets:20 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3476 (3.4 KB)  TX bytes:1858 (1.8 KB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:127 errors:0 dropped:0 overruns:0 frame:0
          TX packets:127 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:7644 (7.6 KB)  TX bytes:7644 (7.6 KB)
```


On romeo and juliet, we note two Ethernet interfaces (named `eth0` and `eth1`) and a loopback interface (named `lo`). The loopback interface is a virtual network interface that the computer uses for processes on the same host to communicate with one another using network protocols. The two Ethernet interfaces represent two points of attachment to networks.  On the router node, you'll see three Ethernet interfaces, representing three points of attachment to networks.

Why do we have multiple points of attachment? Every host we reserve on GENI will have a "control" interface connected to the public Internet, that we use to SSH into the VM to run commands. In addition to the "control" interface, it can also have experiment interfaces (one for each link that we connect to the host, when setting it up in the GENI Portal, and with IP address and netmask according to what we configured in the Portal). In our lab experiments, we will send traffic over the "experiment" interfaces. The "control" interface will be used strictly for logging in to the hosts.

You can distinguish the "control" and "experiment" interfaces by their IP addresses; the experiment interfaces have whatever IP addresses you assigned to them in the GENI Portal. The IP address of the control interface is assigned by the host site, not by you.

**Lab report**: Show the output of `ifconfig -a` for each host in _your_ topology: romeo, juliet, and the router. Make sure you show which output comes from which host. Also, for each, indicate the name of the "control" interface (e.g. `eth0`, `eth1`, `eth2`) and the name of each "experiment" interface, and explain how you can tell which is which.

### Exercise - Create a network diagram

When you reserve a network topology on GENI, you will control the IP address assigned to each experiment interface. However, the MAC address of the interface will be different each time. On a host with multiple experiment interfaces, the name of the interface (e.g. `eth1`, `eth2`) can also vary. 

You can document these details in the form of a network diagram, on which you will:

* Draw a connectivity diagram that shows each host and which hosts it is directly connected to.
* Label each host with its hostname.
* Label each "experiment" network interface with the name assigned to it by the OS, e.g. `eth1`, `eth2`.
* Label each "experiment" network interface with its IP address and MAC address.

A sample network diagram is shown below:

![](1-network-diagram.svg)

You will submit at least one network diagram like this for each lab assignment. Some lab assignments may involve more than one network topology, in which case you will submit a network diagram for each topology.

**Lab report**: Include a network diagram, as described above, for _your_ experiment. The IP address and MAC address of each interface should reflect the output of `ifconfig -a`, from the previous question. You may use any software of your choice to create this diagram, or you can draw it by hand and take a photo to include in your lab report. 

(The sample diagram shown above was created with [https://www.draw.io](https://www.draw.io). If you would like to use this software, you can create a revised version of my diagram by opening [this link](https://viewer.diagrams.net/?highlight=0000ff&edit=_blank&layers=1&nav=1#R5Zlbc6M2FMc%2FjR%2FXA4ibH20n2T5sO5lJZ9o%2B7cggg3YFokJO7H76HgmBudgO2ZCN02ZnWHR0Rf%2FfObp4htbZ%2FrPARforjwmbOVa8n6GbmeMEyIWnMhwqg%2BctKkMiaFyZ7KPhgf5DjNEy1h2NSdkpKDlnkhZdY8TznESyY8NC8KdusS1n3V4LnJCB4SHCbGj9g8Yyray%2BZR3tvxCapKZnt87Y4Oh7IvguN93NHLTVf1V2huumTPkyxTF%2FapnQ7QytBeeyesv2a8LUzNazVtW7O5PbDFuQXI6pEJhhyEP95SSGiTBJLmTKE55jdnu0rvTnEdWABalUZgxebXiFPsXhT2PXib9UYu7VyXsiaEYkEabMNyLlwYiPd5KD6djlF84L03ApBf9O1pxxoQeJLP2nm42XSm412EfMKssdZaypiYXsldC2VhmoYcbg17mtNCQTIpuRPxQ4onliPqDkOxGRM5lDLYw8VS1DjoFb92Ioq0xKiFY1o99nwqErcYACgjAs6WOXWGzAT5pyR%2FXhxQBwGgYzFpilnWlUQCN8gAhAW6jXbJ8o559HtIz4POJZsYNJKL%2FiPP5awJwUKRGYlXMwZjTXc9%2BiJcZl2lC0BTla%2BsYeCWP3lPKhs0G%2B3%2BTUzgnzs3okQlJw4S94Q9g9L6mkPIe8DZeSZ60CS0YTlSEVYCtsUhHIpMhc8Z1kNIdO69ByUUzVKNlfFMrkOgF4gq5jgqIdGqmfWiHGNJu2oovnvl7bxaSOvqdS%2B%2Fnc9kyy5emQ6jt6ExnskZHhOb9%2BfeQYExlGebB3RR7sDTz4245RGJbjMxjbaiPgLZHNp%2F1UpyY2uHVwSpSFHyD8MZ3aXYTv5tP%2BiXitxBqpbVW4NP%2BP13EbRiSKTum4CT3Xsz6kjo7%2FvI5BeEJH9HodbTQQksjUbjttS03%2F753aHa62PJefSh0Cl1DAtoq9noo6v%2FZ025qrf1M1Z8EkLi1Ym5cIhr%2B0N%2FCA1QWS24l6GOALEsounoJAO3ijCygACk5zqRXwVjPvRoEDi0LVl65Qc8TIVp6Fray2b7%2Fr1eOTa4Z8hzPKFBVrCPpUeZf1G3kymWYJsq3Bcjlwjtulv9I7lwlotRdWl1ZnSKtdn6XSzkFlAlyH%2B0TA1ZkSV3taXBFM%2B5J46g3DI1CPBfmf4%2FqmgCKE3hHQ4cLYj6ed0OgMczQ2ZAsPV0U5bKmkxmYzYi%2F1vgS0Rb5IxHAfFtxYQTDRghr2TzunEHDeCoHgJQjYZxGIlfCuCh9qXpaBsuHwPyP40g%2BtVTjRTtgf4fJvpvdioPdApNaZMuc56ep1%2FqD4oqD64oPu2YlvHzHrgNY%2BY5pF%2BNkzZmv2vROTX9tGH0VND%2FeK51a87%2B5HEOppai7Kqkrt%2B8heO2G3nSZdt2Nu4%2FrtaDyajx5FTE3i1RAz9tJ0HDFoSMzYW4mPRYzj95Cx3w6ZOia%2BNzLm%2Bq2%2Birt89zaKlxMBxr6yCOP6l0PDWGDQotdQn7wJgXGuCxhr7kJgOEJjn0HmGJPMBe9kYSkYcuZdFWbNL3l1XLJ%2BEDM36MWlfkM%2FjBkkjz8QVsWPv8Gi238B) and then clicking on the pencil diagram near the bottom of the page. Then you can change the details in the diagram to match your own topology.)


