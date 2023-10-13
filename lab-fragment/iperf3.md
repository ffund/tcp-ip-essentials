## Using `iperf3`


On each host (romeo and juliet), install the `iperf3` package, which we'll use in this lab:

```
sudo apt-get update
sudo apt-get -y install iperf3
```

Before you start, use `ip addr` to capture the network interface configuration of each host in this topology. Identify the IP address and MAC address of each interface.

### Exercise - using iperf3 


In the first part of this lab, we will learn how to use the `iperf3` utility. This is a network testing tool which allows us to send TCP or UDP flows between two hosts, one of which is configured as a server (that listens for incoming connections and receives data), and one of which is configured as a client (that sends data).

Configure "romeo" to act as an `iperf3` server;

```
iperf3 -s
```

Once this is running, the client can initiate a TCP or UDP flow to the server. On "juliet", run

```
iperf3 -c 10.10.0.100
```

to start the `iperf3` application in client mode, and specify the server's IP address.

By default, `iperf3` will establish a TCP connection and run a test for ten seconds.  The client process will terminate automatically when it's finished. To stop the `iperf3` server, use Ctrl+C.

Use 

```
iperf3 --help
```

or 

```
man iperf3
```

to learn more about the other options available with `iperf3`.

Next, you will observe some common errors that people make with `iperf3`. Once you learn the error messages that are associated with common mistakes, you will be able to diagnose and fix problems you may encounter when using `iperf`.

Make sure the `iperf3` server is running on "romeo". Open a second terminal window on "romeo", and run


```
iperf3 -s
```

in this terminal window. Note the error message that you observe.

While the `iperf3` server is running in the first "romeo" terminal window, run

```
sudo killall iperf3
```

in the second "romeo" terminal window. What happened to the `iperf3` server in the first terminal window? Are you able to now run 

```
iperf3 -s
```

in the second terminal window?

Next, let's see what happens on the client side when we try to send `iperf3` traffic to a wrong address, wrong port, or to a host and port where no `iperf3` server is running.

On "juliet", try running

```
iperf3 -c 10.10.0.102
```

and note the message that you observe. Also try running 

```
iperf3 -c 10.10.0.100 -p 6000
```

and note the message. 

Finally, make sure there is no `iperf3` server on "romeo" - stop any running servers with Ctrl+C, and use

```
sudo killall iperf3
```

to kill any that might be running in the background. On "juliet", run

```
iperf3 -c 10.10.0.100
```

and note the error message that you observe.

