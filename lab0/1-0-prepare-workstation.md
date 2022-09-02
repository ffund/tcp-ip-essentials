## Prepare your workstation

You'll need to prepare your workstation with all the software necessary to complete the lab assignments in this course. You will primarily need two pieces of software:

* Wireshark
* An appropriate terminal application

### Wireshark

Wireshark is a software application for capturing, viewing, and analyzing network packets. Download Wireshark from [the Wireshark website](https://www.wireshark.org/download.html).

Then, follow the instructions to install for your system:

* [Instructions for installing Wireshark on Windows](https://www.wireshark.org/docs/wsug_html_chunked/ChBuildInstallWinInstall.html). (Note: you only need Wireshark, not the extra components that are bundled along with it.)
* [Instructions for installing Wireshark on Mac](https://www.wireshark.org/docs/wsug_html_chunked/ChBuildInstallOSXInstall.html).
* [Instructions for installing Wireshark on Linux](https://www.wireshark.org/docs/wsug_html_chunked/ChBuildInstallUnixInstallBins.html).

### Terminal software

The primary software application you'll need is a terminal, which you will use to log in to remote hosts over SSH and carry out various exercises.

You may have a terminal application already on your workstation, but it may not be ideal for this course. To complete these lab exercises, you will often have to run and monitor the output of multiple commands in several independent terminal sessions. It is therefore *strongly recommended* to use a terminal that lets you split one terminal window into multiple panes - for example,

* [cmder](https://cmder.app/) for Windows. (Get the full version, not the mini version.)
* [iTerm2](https://www.iterm2.com/) for Mac
* [terminator](https://launchpad.net/terminator) for Linux

Once you have downloaded and installed your terminal application, open it up and practice using it. Make sure you know:

* How to split the pane in your terminal. 
* How to copy text from your terminal and paste into another application. This will be helpful when you need to save some terminal output for your lab report.
* How to copy text from another application and paste into your terminal. This will be helpful when you need to copy a command from the lab instructions into your terminal, in order to run it.

### cmder on Windows

If you are using cmder on Windows, you can split the pane as follows:

1. Click on the green + symbol near the bottom right side of the window. This will open a "Create new console" dialog.
2. Where it says "New console split", choose "to bottom" or "to right". You can leave other options at their default settings.
3. Click "Start".

Note that if you need to split more than once, click on the pane that you want to split (so that it is the active pane) before using the green + symbol to split it again. 

To copy text from the terminal, select the text you want to copy. It will be automatically copied to your clipboard, and you can then paste it into any other application.

To paste text into the terminal, place your cursor where you want to paste, and right click.


#### iTerm2 on Mac

If you are using iTerm2 on Mac, you can split the pane as follows:

1. To create a new vertical pane, use ⌘+D
2. To create a new horizontal pane, use ⌘+Shift+D

To copy text from the terminal, select the text you want to copy and use ⌘+C to copy.

To paste text into the terminal, place your cursor where you want to paste, and use ⌘+V to paste.

#### Terminator on Linux

If you are using `terminator` on Linux, you can split the pane either vertically or horizontally as follows:

1. Right-click anywhere inside the terminal window
2. Choose "Split pane horizontally" or "Split pane vertically"
3. You can resize panes by dragging the divider between panes

To copy text from the terminal, select the text you want to copy and either

* right-click, and choose Copy, or
* use Ctrl+shift+C to copy

To paste text into the terminal, place your cursor where you want to paste, and either

* right-click, and choose Paste, or
* use Ctrl+shift+P to paste

