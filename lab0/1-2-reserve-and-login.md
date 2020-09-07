## 0.2 Reserve and log in to resources on GENI

Whenever you run an experiment on GENI, you will

1. Create a _slice_, a kind of logical "container" for your experiment.
2. Set up the particular configuration of resources (hosts and links) that you need on the GENI Portal.
3. Submit a request to reserve that configuration for use in your experiment.
4. Log in to the hosts that you have reserved to execute your experiment.

Also, when you finish an experiment and have saved all the data somewhere safe, you will _delete_ the resources in your experiment to free them for use by other experimenters.

### Exercise 4 - Create a slice


To do anything on GENI, you need to create a *slice*. A slice is a "container" for the resources that will be used in an experiment (read more [here](http://groups.geni.net/geni/wiki/GENIConcepts#Slice)).

Slices have _members_; anyone who has is a member of a slice will have their keys installed on all resources that have been reserved since they were added as a member. As project lead, your instrutor has access to all resources on all slices in the project. When you create a slice, you will have access to the resources in your slice, as long as you don't lose your key!

Create a slice by clicking [New Slice](https://portal.geni.net/secure/createslice.php) in the portal: then enter a slice name and click "Create Slice". All slices in a project must have a unique name. To make your slices easy to distinguish from your classmates', please include your username in your slice name. For example, for this assignment, I might call my slice "lab1-ff524."

**Slices expire**. That's OK - they are supposed to expire if you're finished with an experiment. But pay special attention to your slice expiration date! When your slice expires, you will lose access to all of the resources in your slice. Individual resources have their own expiration date, which may be different than, but not later than, the slice expiration date. You must make sure to retrieve any data saved on your resources before they expire.


### Exercise 5 - Set up resources

Once you have created your slice, you will be presented with a blank canvas that allows you to manage resources in your slice. You can click on "Add resources" to add resources (hosts and links) in your desired configuration to your slice. This will open a web-based tool called Jacks. Jacks is a graphical tool for creating a Resource Specification document (RSpec) and submitting a request for the resources described in the RSpec.

After you click on "Add Resources" inside your slice page, Jacks will be open in Edit mode, which looks something like this:

![](1-jacks-edit.png)

There are two ways to set up the hosts and links you want for an experiment:

* By drawing the configuration on the canvas yourself. Jacks will automatically create the RSpec based on your drawing.
* By loading an already-prepared RSpec.

In most of the lab exercises in this course, you will load an already-prepared RSpec. But in this exercise, you will practice setting up an experiment both ways.

First, draw the configuration on your canvas.  Click on the black "VM" icon and drag it onto the white canvas. This icon represents a generic default virtual machine, suitable for general-purpose tasks. Repeat the above step two more times. You should now see three VM boxes on the canvas.

To edit the hostname of the VM, click the VM box. In the "Name" field at the top, replace "node-0" with "romeo" (use all lowercase for hostnames, by convention.) Name the other nodes "router" and "juliet".

Now click near the "romeo" VM box on the canvas, then click and drag towards the "router" VM. Release when you reach the "router" VM. You should now see a line and a box representing a link connecting the two VMs. Repeat this step to connect the "router" to the "juliet". Your canvas should now look like this:

![](1-jacks-topology.png)

You can customize the details of your topology further in Jacks - e.g. you can set the characteristics (capacity, for example) of each of the network links, or change the hosts' software resources (disk image, operating system), or network configuration (IP address, netmask) of the hosts. All of these customizations will also be reflected in the RSpec. For today's experiment, we won't need many customizations. We will, however, assign IP addresses and netmasks to each network interface.

To assign IP addresses and netmasks to the interfaces that connect romeo and the router, click on the small box on the link between these two hosts. Look for the section titled "Interface to **romeo**". In the IP section, fill in the address **10.0.0.2** and in the netmask section, fill in  **255.255.255.0**. It should look like this:

![](1-jacks-network.png)

Then look for the section titled "Interface to **router**" and fill in the IP address **10.0.0.1** and netmask **255.255.255.0**.

Click on the small box on the link between the router and juliet, and follow a similar procedure to assign IP addresses to the interfaces on _this_ link: use IP **10.0.1.2** with netmask **255.255.255.0** for the juliet, and IP **10.0.1.1** with netmask **255.255.255.0** for the router.

The configuration of VMs and links is typically referred to as a "topology". Behind the scenes, Jacks is creating an RSpec that completely describes the topology you have just drawn and configured. To see the RSpec that you have just generated, click on "View RSpec":

![](1-jacks-rspec.png)

An RSpec is a very useful document, because once you have an RSpec for a particular toplogy, you can use it to reserve the same topology many times (or share a topology) without having to go through the trouble of specifying the topology and configuration details by hand in the portal. 

Try this out for yourself: use the "Download RSpec" button below the canvas to save your RSpec to a file. Once you have done that, use the "X" button in the Jacks editor to return to the canvas view. Then use the "Delete All" button in the Jacks editor to clear your canvas. 

Now that you have an empty canvas, we'll load the same configuration you created previously, from the file that you downloaded. Below the canvas, you'll see a "Choose RSpec" section with a few choices (portal, file, URL, text box) that allows you to provide an RSpec document in several ways. Choose the "file" option and choose the file that you've just saved your RSpec to. You should see your three-node topology displayed on the canvas.


### Exercise 6 - Reserve resources


At this point, your RSpec is still _unbound_. This means that it is a "generic" document that doesn't specify which GENI _aggregate_ (host site) the resources in your topology will be on. 

Before you can reserve your topology, you need to bind your RSpec to a particular aggregate. To do this, click on the "Site 1" box on the canvas and choose an aggregate from the dropdown list in the sidebar. There are different types of GENI aggregates - for this course, we will always use the InstaGENI type, so choose a site that has InstaGENI in the name.

You might assume that you should choose the aggregate associated with the university where you are a student - for example, NYU InstaGENI if you are an NYU student. But since an aggregate has a limited number of VMs, CPU cores, memory, and network capacity, if all NYU students only used the NYU InstaGENI site, it would become completely overloaded! Instead, use "load balancing" by selecting a different InstaGENI site each time you use the GENI Portal. 

Once your resource request is bound to a particular aggregate, you will be able to reserve your resources; scroll down to the bottom of the page and click on "Reserve Resources." This will submit your RSpec to the aggregate you've selected, which will attempt to satisfy your request. If the aggregate believes it is able to give you the resources you've requested, then you'll see that your reservation has finished:

![](1-jacks-status.png)

> **Note**: If your request fails at this point, you should try again with a different aggregate. If you continue to get failed requests, 
>
> * You may have a problem with your RSpec and you should double-check your work from Exercise 2. (For example, if you put an IP address in the "Capacity" field instead of the "IP Address" field, your reservation request will fail.) If you can't find your mistake, ask an instructor for help.
> * There may be a system-wide maintenance window or outage - check with your instructor to find out if this is the case.

### Exercise 7 - Log in to resources

Once you have successfully reserved your resources, it will still take some time before your resources are ready for you to log in. To see resource status, go to the slice page: in the menu bar at the top of the page, choose Home > Slices and then click on the name of the slice.

On your slice page, the canvas will automatically refresh to show you the status of your VMs - each VM will turn green as it becomes available for log in:

![](1-jacks-some-resources-ready.png)

This may take some time. 

> **What if it fails?** If the aggregate is unable to bring up the VMs you requested (even if the request "finishes"), it may say "Resources at X have failed" on the slice page, and you may get an email telling you that your VMs failed to boot. If this happens, delete the resources (use the "Delete" button at the bottom of the canvas). Then, try to reserve your resources again with a different aggregate.

Once all of your resources are ready to log in, you will need to find out the details of each host (its hostname and the port number that you will use for SSH access). To get this information, click on "Details" at the bottom of the canvas. This will take you to a page that lists login details for each host in your experiment.

To log in to a host on GENI, you will need to specify your GENI username, the hostname of the host, the port number, and the location of your private key. Open a terminal, and run

```
ssh USERNAME@HOSTNAME -p PORT -i /PATH/TO/id_rsa
```

where `USERNAME` is your GENI username, `HOSTNAME` is the hostname of the VM you are logging in to, `PORT` is the port number specified in the portal for that VM, and `/PATH/TO/id_rsa` is the full path to the private half of your key pair. (The default location is `~/.ssh/id_rsa` if you generated your key with `ssh-keygen` and didn't specify a different location.)

For example, if the GENI Portal shows the following login details for me for the "romeo" host in my experiment:

![](1-jacks-login-details.png)

and my key was located in the default location, `~/.ssh/id_rsa`, I would run

```
ssh ffund01@pc3.instageni.maxgigapop.net -p 25107 -i ~/.ssh/id_rsa
```

in a terminal window to log in.

The first time you log in to each new host, your computer will display a warning similar to the following:

```
The authenticity of host '[pc3.instageni.maxgigapop.net]:25107 ([206.196.180.202]:25107)' can't be established.
RSA key fingerprint is SHA256:FUNco2udT/ur2rNb2NnZnUc8s2v6xvNdOFhFFxcWGYA.
Are you sure you want to continue connecting (yes/no)?
```

and you will have to type the work `yes` and hit Enter to continue. If you have specified your key path and other details correctly, it won't ask you for a password when you log in to the node. (It may ask for the passphrase for your private key if you've set one.)

Once you are done with this part of the lab , proceed to the [next part](1-3-network-interfaces.md)
