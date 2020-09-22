## 1.4 Manipulating output of a command

In this section, you will learn how to use the commands `head`, `tail`, `less`, and `grep` to manipulate the output of a command. You'll also learn how to do I/O redirection with `>` and `>>`.

### Exercise 9 - See more or less

We'll often want to see more or less of a command that has a lot of output.

As an examples, we will use the file `/etc/services`. This file lists networked service names, along with the port number and transport-layer protocol each one uses.

If you run

```
cat /etc/services
```

to see the contents of the file, you won't see much - there's just too much 
output, and it goes by too quickly.

To see the beginning of the file, use

```
head /etc/services
```

To see just the end, use

```
tail /etc/services
```

You can also specify the number of lines to see with either command, with e.g.

```
head --lines=5 /etc/services
```

or

```
tail --lines=10 /etc/services
```

To page through one line of output at a time, use

```
less /etc/services
```

which will show the entire file, but one "page" a time. Use Enter, the up and down arrow keys, or the Page Up and Page Down keys to scroll through the file, or press `q` to quit at any time.

One useful feature of `less` is the ability to search for a word. Suppose you want to know what port the `smtp` mail service uses. You can open the file with

```
less /etc/services
```

Then, while the file is open with `less`, type

```
/smtp
```

and hit Enter. This will search the file for the first occurence of the word `smtp`, go to that part of the file, and highlight the matching word. (Once you have tried this, you can use `q` to close the file.)


Finally, suppose you want to be able to see only lines matching a particular pattern.
There's a very powerful utility called `grep` that allows us to filter
a file or other input to see only those lines that contain a particular word.
For example, to see lines containing the word "ftp", you can run

```
grep "ftp" /etc/services
```

and you will see only the lines containing the word "ftp". Note that this is case-sensitive; you won't see the same lines if you run

```
grep "FTP" /etc/services
```



### Exercise 10 - I/O redirection and pipes


For example, suppose we want to get all of the lines in `/etc/services` related to services that operate over UDP. We can save those lines to a file called `udp-services.txt` in our home directory, by using the `>` operator to redirect the output of the `grep` command:

```
grep "udp" /etc/services > ~/udp-services.txt
```

We may occasionally want to send the output of a command to a file, 
but append to an existing file rather than create a new one (as `>` does). To 
append to an existing file we will use `>>`. 

For example, to create a file called `routing-services.txt` 
that contains the lines in `/etc/services` 
related to the routing services `ripd` and `bgpd`, run

```
grep "ripd" /etc/services > ~/routing-services.txt
grep "bgpd" /etc/services >> ~/routing-services.txt
```

The second line won't overwrite the text that is written to `routing-services.txt`
in the first line; it will append to the file instead.

One valuable feature of the Bash shell is the ability to "chain" together multiple
utilities by using the _pipe_ operator, `|`. This operator takes the output of the command
*before* the pipe, and uses it as input to the command *after* the pipe.

We can use this feature to filter the output of any command with `grep` (although that's not the only usage!). For example, suppose we want to see the MAC address of every network interface card on the host.  We can "pipe" the output of the `ifconfig` command to `grep`:

```
ifconfig -a | grep "HWaddr"
```

We can even use the pipe operator to connect more than two commands. For example, let's try using the `awk` utility to print only the first and fifth "columns" of output from the previous command:

```
ifconfig -a | grep "HWaddr" | awk '{print $1,$5}'
```

If you see a piped command sequence and you're unsure what each part does, a good way to find out is to gradually build up the sequence from left to right. For example, for the command sequence above, if you want to find out what it does you might first run:


```
ifconfig -a 
```

Then add


```
ifconfig -a | grep "HWaddr" 
```

to see how the output of `ifconfig` is modified by the `grep` command. Finally, run

```
ifconfig -a | grep "HWaddr" | awk '{print $1,$5}'
```

and compare to the previous output, to see what the `awk` command does. 


**Lab report**: Run the piped command sequence: 

```
ifconfig -a | grep "inet addr" > $(hostname -s)-network-config.txt
```

on the "romeo" host, then answer these questions.

* Explain what each of these commands does, in the context of the command sequence above: `ifconfig -a`,  `grep "inet addr" `, `hostname -s`
* Explain what each of these operators does, in the context of the command sequence above: `|`, `>`
* Explan what the complete sequence does.
* This command saves some output to a file. What is the full path to that file? What command(s) could you use to find out the full path to the file? Show the contents of the file. What command(s) could you use to see the contents of the file?

Once you are done with this part of the lab, proceed to the [next part](1-5-tcpdump-wireshark.md).
