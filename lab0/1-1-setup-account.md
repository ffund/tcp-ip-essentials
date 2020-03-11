## 1.1 Set up your account on GENI

In this course, you will use [GENI](http://www.geni.net/) to run lab experiments. 

GENI is a "virtual lab" for experiments on networking and distributed systems. It allows experimenters to set up _real_ (not simulated!) end hosts and links at one or more GENI host sites located around the United States. Experimenters can then log in to the hosts asociated with their experiment and install software, run applications to generate traffic, and take network measurements.

Before you can run lab experiments on GENI, you will need to set up an account. Once you have completed the steps on this page, you will have an account that you can use for the duration of the course.

### Exercise 1

First, go to [https://portal.geni.net](https://portal.geni.net) and click on "Use GENI".

On the next screen, you will be prompted to choose an Identity Provider. Start typing the name of your university into the text input box. The field will start to suggest matching institutions after you type a few letters; when you see the name of your university appear underneath the text input box, click on it to select it, then choose "Continue". Then, when prompted, log in to your university account. (Your home institution username and password will not be sent to GENI; if you would like to read more about how this works, see [InCommon Federation Basics](http://www.incommon.org/federation/basics.html).)

> If your institution does *not* appear in the list:
> 
> * Click on the "[Request an account](https://go.ncsa.illinois.edu/geni)" link near the bottom of the page.
> * Fill in the form to request an account from NCSA.
> * Look for an email from NCSA asking you to confirm your request and follow the instructions in that email.
> * Wait for your NCSA account to be approved (you will get an email).
> 
> Now when you visit the GENI Portal and click "Use GENI", enter your institution as NCSA (National Center for Supercomputing Applications) and log in with the account you created there.

Review the policies on the next page, check both boxes, and click "Activate" to log in to the GENI Portal.

### Exercise 2

In this exercise, you will set up a pair of SSH keys with which you will access resources on GENI. (If you have already used GENI and have a key pair set up in the GENI Portal, and you still have access to those keys, you don't need to create new keys - you can skip this exercise and go on to the next one.)

GENI users access resources using public key authentication. Using SSH public-key authentication to connect to a remote system is a more secure alternative to logging in with an account password.

SSH public-key authentication uses a pair of separate keys (i.e., a key pair): one "private" key, which you keep a secret, and the other "public". A key pair has a special property: any message that is encrypted with your private key can only be decrypted with your public key, and any message that is encrypted with your public key can only be decrypted with your private key.

This property can be exploited for authenticating login to a remote machine. First, you upload the public key to a special location on the remote machine. Then, when you want to log in to the machine:

1. You use a special argument with your SSH command to let your SSH application know that you are going to use a key, and the location of your private key. If the private key is protected by a passphrase, you may be prompted to enter the passphrase (this is not a password for the remote machine, though.)
2. The machine you are logging in to will ask your SSH client to "prove" that it owns the (secret) private key that matches an authorized public key. To do this, the machine will send a random message to you.
3. Your SSH client will encrypt the random message with the private key and send it back to the remote machine.
5. The remote machine will decrypt the message with your public key. If the decrypted message matches the message it sent you, it has "proof" that you are in possession of the private key for that key pair, and will grant you access (without using an account password on the remote machine.)

Of course, this relies on you keeping your private key a secret. Never share your private key with anyone else, and never post it online.

On your laptop, you're going to generate a key pair and upload the public key to the GENI portal. Then, you'll use that key from now on to log in to GENI resources.

If you are using Windows, download and install [Git Bash](https://git-scm.com/downloads) and use its terminal. If you are using a Mac or Linux-based laptop, open a terminal.

Generate a key with:

```
ssh-keygen -t rsa
```

and follow the prompts to generate and save the key pair. The output should look something like this:

```
$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/users/ffund01/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /users/ffund01/.ssh/id_rsa.
Your public key has been saved in /users/ffund01/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:z1W/psy05g1kyOTL37HzYimECvOtzYdtZcK+8jEGirA ffund01@example.com
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|                 |
|           .  .  |
|          + .. . |
|    .   S .*.o  .|
|     oo. +ooB o .|
|    E .+.ooB+* = |
|        oo+.@+@.o|
|        ..o==@ =+|
+----[SHA256]-----+
```

In a safe place, make a note of:

* The passphrase you used,
* The full path to your private key (`/users/ffund01/.ssh/id_rsa` in the example above) - copy and paste this from your terminal output,
* The full path to your public key (`/users/ffund01/.ssh/id_rsa.pub` in the example above) - copy and paste this from your terminal output.

If you forget these, you won't be able to access resources on GENI - so hold on to this information!

Next, upload your public key to the SSH Keys section of your profile on the GENI portal: in the menu, click on your name, then on "[SSH Keys](https://portal.geni.net/secure/profile.php#ssh)", and upload your public key to that page.

> **Note**: If you are having trouble uploading your public key to the portal because you aren't able to find it in the file browser, you can copy it to a more convenient location and upload it from there.
>
> * Open a terminal.
> * Run `cp /path/to/key.pub /path/to/new/location` but substituting the path to your key and the path to a more convenient location (e.g. your Desktop) for the two arguments.
> * Upload the public key from the new location.
> * You can delete the copy of the public key from the new location (the original key is still located at the original location).

Once your key is in the portal, every time you reserve GENI resources, your key will automatically be placed in the "authorized keys" list so that you can access the resource. 

Note that this only applies to resources you reserved after uploading a key. If you lose access to your key and have to generate and upload a new key, you will lose the ability to log on to resources you have reserved in the past.

In general, a common mistake students make is to delete or replace their keys if they are having trouble logging in to a resource. This is usually not helpful, and in most cases makes things worse. Deleting a key is like forgetting a password - don't do it!


### Exercise 3


GENI users are organized into projects (read more [here](http://groups.geni.net/geni/wiki/GENIConcepts#Project).) 
Anyone can create an account on GENI, but unless you are part of a project 
(supervised by a responsible Project Lead), you won't be able to access any 
GENI resources or run experiments. 

Your course instructor should have already set up a project for your course, and shared with you the name of the project. You'll join this project and become a Project Member in order to run experiments.

In the GENI Portal, click on "Home > Projects" in the menu at the top, then click "[Join a Project](https://portal.geni.net/secure/join-project.php)". Type the project name that your instructor gave you into the box where it says "Enter a Project Name", click "Join", and proceed to send the join request. 

Requests to join a project are pending until they are approved by the Project Lead (your instructor!); understand that it may take some time for the Project Lead to review and approve your request, so plan accordingly.

Once you have completed all of the exercises on this page and your account has been approved, you can proceed to the next lesson.


> **Note**: In this and future lab exercises, you will often have to have multiple terminal windows open and logged in to the same host. It can be useful to have a terminal that lets you split one window into parts, like [this](https://witestlab.poly.edu/blog/content/images/2017/01/protocol-stack-application-1.gif) - for example,
> * [cmder](http://cmder.net/) for Windows
> * [terminator](https://launchpad.net/terminator) for Linux
> * [iTerm2](https://www.iterm2.com/) for Mac

