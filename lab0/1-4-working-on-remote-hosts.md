## Working on remote hosts

There are a few extra challenges associated with working on remote hosts via SSH, especially if your network connection is unreliable. Some common pitfalls and tricks are listed on this page.


### Exercise - Dealing with disconnection

When you open a new terminal window, you'll have a _local_ shell open. Make a note of what the prompt looks like. For example, mine looks like this:

```
ffund@ffund-xps:~$
```

It shows my username (`ffund`), hostname (`ffund-xps`), my current
working directory (`~`, which is shorthand for my home directory), and then a `$` to signify that I'm working as a
normal (unprivileged) user. (If I was working as the privileged "root" user,
the prompt would end with a `#` instead.)

When you log in to a remote host, the terminal prompt will change - at the very least, it will show the hostname of the remote host instead of the hostname on the laptop you are working on. When working on remote hosts, the prompt is useful for determining *where* you are running a command.

In particular, if your SSH session is idle for some time, you may find that you get disconnected from the remote host. When you try to type a command in the terminal window, you'll see something like this:

```
ffund01@juliet:~$ packet_write_wait: Connection to 206.196.180.202 port 25106: Broken pipe
ffund@ffund-xps:~$ 
```

This indicates that you've been disconnected from the remote host, and any command you run now will execute on your _local_ system, and not on the remote host. To log back in to the remote host, just use the "up" arrow on your keyboard to fill in the last command you ran - which will have been the SSH login command - and then hit "Enter".

Keep an eye on that terminal prompt while you are working on the lab exercises in this course, since the lab procedures only "work" if you run the commands in the right place! You may get disconnected without realizing it. If you run a command and don't get the expected output, check the terminal prompt to make sure that your SSH session is still alive. 

Sometimes when you are working on a remote host, your SSH session may become "stuck" because of a network connectivity problem. Under these circumstances, you might close the terminal window, open a new terminal window, and re-enter the SSH information to reconnect - all of which takes a lot of time. Fortunately, there is a quick way to "hang up" an SSH session, so that you can start a new SSH session and resume working without having to close your terminal and open a new one. To "hang up" an SSH session, place your cursor in the SSH session that you want to hang up, then: 

1. Hit Enter (to make sure you are typing the hangup command at the beginning of a new line),
2. Type `~` (on many keyboards, you may need to use Shift to type the tilde symbol), (note that **you won't see anything appear in the terminal output when you type the `~` at the beginning of a new line**!)
3. Then type `.` (and note that again, **you won't see it appear in the terminal output**!)

Practice hanging up a session, then reconnecting by using the "up" arrow on your keyboard followed by "Enter". 

**Note**: To "gracefully" end an SSH session, instead of hanging up, just type `exit` in the terminal at the remote host (and hit "Enter").


**Lab report**: Show a screenshot or copy and paste from your terminal to show the terminal prompt of your _local_ shell. 

**Lab report**: Show a screenshot or copy and paste from your terminal to show the terminal prompt when you are logged in to the "juliet" node in your experiment.

**Lab report**: Show a screenshot or copy and paste from your terminal to show what is looks like when you use `~.` to hang up on an SSH session.



### Exercise - Using `screen`


In addition to the inconvenience of having to restart a stuck SSH session, there may be further complications when your SSH session is stuck or disconnected *while a process is still running in it*. When that happens, you may have to kill the running process and re-start it, or you won't be able to access its output.


For example, suppose you are using the `ping` utility to measure the round trip delay between the "romeo" and "juliet" host in your experiment. On "romeo", run

```
ping juliet
```

This command will send a request packet to the "juliet" host every second, wait for a response, and measure the time difference between the request and response until you force it to stop. When you force the `ping` process to stop - using Ctrl+C - it will print the minimum, average, maximum, and standard deviation of round trip time, like this:

```
--- juliet-link-0 ping statistics ---
11 packets transmitted, 11 received, 0% packet loss, time 10007ms
rtt min/avg/max/mdev = 0.451/0.551/0.694/0.075 ms
```

While the `ping` is *still running*, hang up on your SSH session using the `~.` command you practiced in the previous exercise. Then, start a new SSH session. Note that you aren't able to retrieve the summary statistics from the `ping` output. 


If you find that this happens to you a lot while working on the lab assignments, you may find it helpful to use `screen`. `screen` is a utility that lets you:

* launch and use multiple interactive terminal sessions from within a single SSH session, 
* disconnect from your SSH session while processes in your `screen` sessions keep running, and
* reconnect to your `screen` session from a new SSH connection.

In other words: if you start a process inside a `screen` session, then even if your SSH connection is disrupted, the process will continue running, and you can reconnect to the session to see its output or interact with the process.

Try it out now. On the "romeo" host, start a new screen session with 

```
screen -S "mysession"
```

(you can pass any name you like to the session).  Hit "Enter" and then you should see your usual terminal prompt. But, you are now working *inside* a screen session.

Now, let's start a long-running process - run

```
ping juliet
```

Leave this running, and hang up on your SSH session (using the special `~.` command).

Then, reconnect to the "romeo" host. Once you are logged in to "romeo", run

```
screen -ls
```

to list all your current `screen` sessions. You should see one session listed. Run 

```
screen -R mysession
```

to re-attach to your running session, by name.

Some useful `screen` hints:


* If you are working inside a `screen` session, you can end the session and return to your "regular" SSH session using the `exit` command.
* You can "detach" from a `screen` session (leaving it running, so you can re-attach to it later) with `screen -d` or with the keyboard shortcut Ctrl+A and then D

### Exercise - Transferring files to and from remote hosts

When running lab exercises, you'll generate data on remote hosts on GENI, and then you will have to transfer the data back to your laptop for analysis.

To move files back and forth between your laptop and a remote system that you access with `ssh`, we can use `scp`. The syntax is:

```
scp [OPTIONS] SOURCE DESTINATION
```

where `SOURCE` is the full address of the location where the file is currently llocated, and `DESTINATION` is the address of the location that you want to copy a file to.

When you are transferring a file from a remote host (e.g. a host on GENI) to your laptop, you will run `scp` from a terminal *on your laptop* (NOT a terminal that is logged in to the remote host), and the syntax will look like this:

```
scp -i PATH-TO-KEY -P PORT USERNAME@HOSTNAME:REMOTE-FILE-PATH LOCAL-FILE-PATH
```

For example, if the file is located on a remote host where

* the location of the key you use to SSH into the remote host is `~/.ssh/id_rsa`
* the port you use to SSH into the remote host is  25107
* the username you use to SSH into the remote host is ff524
* the hostname you use to SSH into the remote host is pc3.instageni.maxgigapop.net
* the location of the file you want to copy on the remote host is `/etc/services`
* and you want to copy the file to the location on your laptop from which you run the `scp` command (`.` is shorthand for "my current working directory"), 

you would run

```
scp -i ~/.ssh/id_rsa -P 25017 ffd01@pc3.instageni.maxgigapop.net:/etc/services .
```

and the output would look like this:

```
services                                      100%   19KB 401.3KB/s   00:00    
```

and then, when you run `ls`, you should see the `services` file in your current directory. 

You'll have to make sure you have the necessary file permissions to write files to the directory you are working in! If you get a message indicating a file permission error, you may have to specify a path to a directory in which you have write permission, instead of the `.` argument.

**Lab report**: Transfer the file located at `/etc/services` on your "romeo" host to your laptop. Include a screenshot, or copy and paste from your terminal, to show the command you ran *and* the result showing a successful file transfer. For example

```
ffund@ffund-xps:~$ scp -i ~/.ssh/id_rsa -P 25107 ffund01@pc3.instageni.maxgigapop.net:/etc/services .
services                                      100%   19KB 401.3KB/s   00:00  
```

