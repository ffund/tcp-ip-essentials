## 1.3 Working with files and directories

In this section, you will learn how to work with files and directories, using the commands: `cp`, `rm`, `mv`, `cat`, `wget`, `scp`, `nano`                                     

### Exercise 6 - Moving files around the filesystem

The easiest way to create a file is to just open it for editing. We will 
use the `nano` text editor to open file called `newfile.txt`:

```
nano newfile.txt
```

You can type some text into this file, then use Ctrl + O to write it 
**o**ut to file, and hit Enter to confirm the file name to which to save.
Near the bottom of the screen, it should say e.g. "[ Wrote 1 line ]".
Then use Ctrl + X to exit.

To see the contents of a file, we can print the contents of the file 
to the terminal output with `cat`:

```
cat newfile.txt
```

You can edit an existing file with `nano`, too. Open the file again with

```
nano newfile.txt
```

and you can change its contents. The use Ctrl + O to write it 
**o**ut to file, and hit Enter to confirm the file name to which to save.
Use Ctrl + X to exit.

You will use `nano` often in the lab, whenever you are asked to modify a configuration file for a networked service. Take a few moments now to practice using it and become familiar with how it works.

To copy a file, we use `cp`, and give the source and destination file names
as arguments:

```
cp newfile.txt copy.txt
```

To move (or rename) a file, we use the `mv` command:

```
mv copy.txt mycopy.txt
```

and we use `rm` to delete a file:

```
rm mycopy.txt
```

With `rm`, there is no "Recycle Bin" and no getting back files you've 
deleted accidentally - so be very, very careful.


### Exercise 7 - Retrieving files from the Internet

Use `wget` to download a file from the Internet. 

For example, to download a file I've put at 
https://witestlab.poly.edu/bikes/README.txt
we can run

```
wget https://witestlab.poly.edu/bikes/README.txt
```

Then, use

```
cat README.txt
```

to verify that you've retrieved the file and see its contents.
Similarly, you can download anything from the web by URL.


### Exercise 8 - flags, man page and `--help`

Bash utilities typically have some flags you can use to modify the way 
they behave, or what their output looks like. 

For example, take the `ls` command. We can:

* See one file per output line: `ls -1`
* See "long" output that includes file permissions, ownership, modification dates: `ls -l`
* See "long" output and also sort files in order of time of last modification: `ls -lt`
* See "long" output and sort files so that the most recently modified file is last: `ls -ltr`

With most utilities, you can use the `--help` flag to find out how to use 
the utility and what flags are available for it:

```
ls --help
```


You can also use the `man` command to read the complete user manual for a command. Try

```
man ls
```