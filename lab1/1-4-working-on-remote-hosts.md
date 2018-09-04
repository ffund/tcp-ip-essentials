

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

