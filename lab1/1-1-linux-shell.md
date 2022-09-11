## 1.1 Learning the basics of the Bash shell

For this experiment, we will use a topology with two connected workstations (named "romeo" and "juliet"), with IP addresses configured as follows:

* romeo: 10.10.0.100
* juliet: 10.10.0.101

each with a netmask of 255.255.255.0. 

To set up this topology in the GENI Portal, create a slice, click on "Add Resources", and load the RSpec from the following URL: https://raw.githubusercontent.com/ffund/tcp-ip-essentials/gh-pages/rspecs/two-hosts-one-segment.xml

Refer to the [monitor website](https://fedmon.fed4fire.eu/overview/instageni) to identify an InstaGENI site that has many "free VMs" available. Then bind to an InstaGENI site and reserve your resources. Wait for them to become available for login ("turn green" on your canvas) and then SSH into each, using the details given in the GENI Portal.


Before you start, use `ifconfig -a` to capture the network interface configuration of each host in this topology. Save this information for your reference.

You will run all of the commands in this exercise in your SSH session (on either host), *not* on your local system. Check the terminal prompt to make sure you are working on the remote host.
                                                                                
### Exercise - "Hello world"

When you run commands in a terminal environment, you are actually *programming* 
the computer. Each command is a line of code, that is then executed by an *interpreter*.

(You may be familiar with the idea of an interpreter if you have ever used Python - 
in interpreted programming languages, code is not translated into machine code by a compiler in advance of execution. Instead, the code is translated into machine code, one line at a time, by an interpreter *as the program runs*.)

The most common shell, or command language interpreter, you'll encounter on Linux systems, and the one we'll use in this course, is called Bash. In this lab exercise, you will learn some basic commands you can use to "program" in the Bash shell environment.

We will start with the standard "hello world" exercise that is often 
a first introduction to a new computing environment or language.

For the standard "hello world" exercise, we use the `echo` command to 
print a quoted string to the terminal output. At the terminal prompt, type:

```
echo "Hello world"
```

and then hit Enter to run the command you've just entered.

Like other programming languages, you can define and use variables in the Bash shell. To see how this works, try defining a new variable called `mymessage` by assigning a value to it:

```
mymessage="hello world"
```

(note that there is no space on either side of the `=`).


You can then access the value stored in the variable in your Bash "code" by prefacing the variable name with a `$` sign. Try running:

```
echo $mymessage
```

In addition to assigning a value to a variable manually, you can also make a variable take on the output of a command as its value. For example, the command `whoami` will return your current username. Try running it now:

```
whoami
```

To assign its output to a variable, we enclose it in `$()` when doing the assignment - this tells the shell to evaluate the command and use its output:

```
myname=$(whoami)
```

You can now use the `myname` variable in another command:

```
echo "$mymessage, $myname"
```

You can even use the output of one command directly in another command, without assigning it to a variable - try


```
echo "$mymessage, $(whoami)"
```

This feature is known as *command substitution*.


### Exercise - tab autocompletion


Many terminals have a feature called "tab autocompletion" where, when 
you type a partial command and then press the Tab key, it will 
finish the command for you.

Let's try this with the `whoami` command. First write out the entire command:

```
whoami
```

When you hit Enter, you should see that this command returns your 
username. Now try typing just

```
whoa
```

and then hit Tab. At the prompt, the rest of the command `whoami` should
be filled out, and you can then hit Enter to run it.

Tab autocompletion will only fill out the entire command if only one command on the 
system matches what you've entered so far. If there are multiple matching 
commands, Tabl will show you all of them. You'll have to continue 
typing out the one you want until there is only one match, and then Tab
will autocomplete it for you. Try typing

```
who
```

and then hit Tab to see how this works.

Tab autocompletion also works for file and directory names, for arguments to 
many commands, and for variables.

For example, suppose you save the string "hello world" in a new variable called
`mymessage` like this:

```
mymessage="hello world"
```
(note that there is no space on either side of the `=`).

You can then run 

```
echo $mym
```

and hit Tab, and it will be autocompleted to `echo $mymessage` (which 
will print "hello world" to the terminal output).


### Exercise - History

It's often useful to be able to see and re-run commands you've previously run. 

You can use the up arrow and down arrow keys to scroll 
through your previous commands. Or, to see your command history all at once, run

```
history
```

You'll note that each line in the output of the `history` command has a number 
next to it, with which you can re-run that command. To run a command that 
appears as number `1` in your history, run

```
!1
```

or, to quickly run your last command again (without having to specify the 
number), you can run 

```
!!
```

Sometimes you want to run the same command again, but with different arguments; 
or run a different command on the same arguments (for example, if you are doing
several operations on a file.) Here are some useful shortcuts you can try:

```
!:0 # command only of last command in history
!^  # first argument of last command in history
!*  # all arguments of last command in history
!$  # last argument of last command in history
```
