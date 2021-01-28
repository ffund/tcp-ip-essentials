## 1.2 Navigating the filesystem


In this section, you will learn about the structure of the Linux filesystem, and some basic commands for navigating the filesystem: `pwd`, `ls`, `cd`, `mkdir`

### Exercise 4 - Basic filesystem navigation

First, check where you are currently located in the filesystem with the `pwd`
("**p**rint **w**orking **d**irectory") command:

```
pwd
```
Next, **l**i**s**t the contents of the directory you are in:

```
ls
```

To create a new directory inside our current directory, run `mkdir` and 
specify a name for the new directory, like

```
mkdir new
```

You can **c**hange **d**irectory by running `cd` and specifying the directory
you want to change to. For example, to change to the directory you've just 
created, run

```
cd new
```

and then use 

```
pwd
```

again to verify your current working directory.

### Exercise 5 - Relative and absolute paths

You may have noticed that when you run the `pwd` command, it gives you 
a full path with several directory names separated by a `/` character.
This is a _full path_. For example, after running the commands above, I would see
the following output for `pwd`:

```
/users/ff524/new
```

When you run commands that involve a file or directory, you can always 
give a full path, which starts with a `/` and contains the entire directory
tree up until the file or directory you are interested in. For example, you can 
run 

```
cd /users/ff524
```

to return to your home directory. Alternatively, you can give a path that is
_relative_ to the directory you are in. For example, when I am inside my home
directory (`/users/ff524` - yours will be different), which has a directory 
called `new` inside it, I can navigate into the `new` directory with 
a relative path:

```
cd new
```

or the absolute path:
 

```
cd /users/ff524/new
```

The concepts and commands in this section will be essential for future lab assignments. They will be especially important when you use `scp` to retrieve data from your experiments - you will need to be able to find out the absolute path of the file you want to retrieve, so that you can use it in your `scp` command.


Some useful shortcuts for navigating the filesystem:

* Running `cd` with no argument takes you to your home directory.
* The shorthand `..` refers to "the directory that is one level higher" (can be
used with `cd` and with other commands).
* The shorthand `~` refers to the current user's home directory (can be used 
with `cd` and with other commands).
* After navigating to a new directory with `cd`, you can then use `cd -` to 
return to the directory you were in previously.

Try these commands. Before and after each `cd` command, run `pwd` to see
where you have started and where you ended up after running the command.


```bash
cd       # takes you to your home directory
cd ..    # takes you one directory "higher" from where you were before
cd ~     # takes you to your home directory
cd ../.. # takes you two directories "higher" from where you were before
cd -     # takes you to the directory you were in before the last time you ran "cd"
```


Then, return to your home directory.

Once you are done with this part of the lab, proceed to the [next part](1-3-linux-files-directories.md).
