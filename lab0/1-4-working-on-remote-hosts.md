## 0.4 Working on remote hosts

There are a few extra challenges associated with working on remote hosts via SSH, especially if your network connection is unreliable. Some common pitfalls and tricks are listed on this page.


### Exercise 10 - Dealing with disconnection

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

### Exercise 12 - Transferring files to and from remote hosts

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


**Lab report**: Mistakes with `scp` can be a source of frustration for students, so it's good to know about common errors and what they mean. For each of the following SCP commands, can you identify the mistake I made, and explain how to fix it? (You can try out these "wrong" commands for yourself - just replace the port number, username, and hostname with the relevant one for your experiment resource.)

* "cannot stat 'port number': No such file or directory":

```
ffund@ffund-XPS-13-9300:~$ scp -i ~/.ssh/id_rsa -p 25107 ffund01@pc3.instageni.maxgigapop.net:/etc/services .
cp: cannot stat '25107': No such file or directory
```

* Usage message:

```
ffund@ffund-XPS-13-9300:~$ scp -i ~/.ssh/id_rsa -P 25107 ffund01@pc3.instageni.maxgigapop.net:/etc/services
usage: scp [-346BCpqrTv] [-c cipher] [-F ssh_config] [-i identity_file]
            [-J destination] [-l limit] [-o ssh_option] [-P port]
            [-S program] source ... target
```

* "Not a regular file":

```
ffund@ffund-XPS-13-9300:~$ scp -i ~/.ssh/id_rsa -P 25107 ffund01@pc3.instageni.maxgigapop.net: /etc/services .
scp: .: not a regular file
```

* "Connection timed out":

```
ffund01@romeo:~$ scp -i ~/.ssh/id_rsa -P 25107 ffund01@pc3.instageni.maxgigapop.net:/etc/services .
Warning: Identity file /users/ffund01/.ssh/id_rsa not accessible: No such file or directory.
ssh: connect to host pc3.instageni.maxgigapop.net port 25107: Connection timed out
```

* "Permission denied":

```
ffund@ffund-XPS-13-9300:/$ scp -i ~/.ssh/id_rsa -P 25107 ffund01@pc3.instageni.maxgigapop.net:/etc/services .
/services: Permission denied
```


Once you are done with this part of the lab , proceed to the [next part](1-5-delete-resources.md).

