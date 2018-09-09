## 1.4 Working on remote hosts

There are a few extra challenges associated with working on remote hosts via SSH. Some common pitfalls and tricks are listed on this page.


### Exercise 10 - Watch those terminal prompts

When you open a new terminal window, you'll have a _local_ shell open. Make a note of what the prompt looks like. For example, mine looks like this:

```
ffund@ffund-xps:~$
```

It shows my username (`ffund`), hostname (`ffund-xps`), my current
working directory (`~`, which is shorthand for my home directory), and then a `$` to signify that I'm working as a
normal (unprivileged) user. (If I was working as the privileged "root" user,
the prompt would end with a `#` instead.)

When you log in to a remote host, the terminal prompt will change - at the very least, it will show the hostname of the remote host instead of the hostname on the laptop you are working on. When working on remote hosts,
the prompt is useful for determining *where* you are running a command.

In particular, if your SSH session is idle for some time, you may find that you get disconnected from the remote host. When you try to type a command in the terminal window, you'll see something like this:

```
ffund01@juliet:~$ packet_write_wait: Connection to 206.196.180.202 port 25106: Broken pipe
ffund@ffund-xps:~$ 
```

This indicates that you've been disconnected from the remote host, and any command you run now will execute on your _local_ system, and not on the remote host. To log back in to the remote host, just use the "up" arrow on your keyboard to fill in the last command you ran - which will have been the SSH login command - and then hit "Enter".

**Lab report**: Show a screenshot or copy and paste from your terminal to show the terminal prompt of your _local_ shell.

**Lab report**: Show a screenshot or copy and paste from your terminal to show the terminal prompt when you are logged in to the "juliet" node in your experiment.

### Exercise 11 - Transferring files to and from remote hosts

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
