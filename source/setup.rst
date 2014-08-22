Setting up the system
=====================

This page attempts to describe how to set up the DAQ system from scratch. There is a bit of work involved in doing this, but fortunately quite a bit of it can be automated.

Installing Fedora on the Mac Minis
----------------------------------

To run the DAQ system, the Mac Minis need to be running Linux (at least for the time being). After trying several different distributions, Fedora was chosen since it runs on Apple's hardware and works with the DAQ software. There are many tutorials online that describe how to install Linux, but the basics are given below. You'll need a USB flash drive that's at least 2 GB in size.

..  danger::

	This procedure will destroy **all** data on the USB drive.

1. Download an installer ISO from http://fedoraproject.org/en/get-fedora. The 64-bit, Intel-compatible version should be fine. Use a Live Media image for faster downloads.
2. On a Mac, format the flash drive as HFS+ with a GUID partition table (click :guilabel:`Options` in Disk Utility). 
3. Make a note of the device node of the disk. (For this example, I'll assume it's :file:`/dev/sdb`.) You can find this by running ::

	$ diskutil list

4. Open a terminal and unmount the disk using ::

	$ sudo diskutil unmountDisk /dev/disk1

5. Copy the image to the disk using :command:`dd`::

	$ sudo dd if=/path/to/image.iso of=/dev/rdisk1 bs=1m

..  danger::

	Be *absolutely certain* to use the correct device node here in the ``of=...`` argument. Choosing the wrong device node could lead to overwriting your computer's hard disk, destroying data and preventing it from booting.

..  note::
	
	Using *rdisk1* here rather than *disk1* will likely make the process faster.

6. Eject the flash drive by running ::

	$ sudo diskutil eject /dev/disk1

7. If necessary, shrink the OS X partition on the target Mac by using Disk Utility. Leave the rest of the disk as empty space.
8. Plug the flash drive into the target Mac and hold :kbd:`Option` while booting it. Choose the flash drive on the boot menu, and install Fedora on the hard disk as usual. Allow the installer to partition the disks automatically.

Compiling the software
----------------------

The DAQ software has to be compiled before it can be used. It's easiest to do this on the control computer and then copy it to the Mac Minis. 

In addition to a compiler, the packages needed to compile the software:

	- gsoap
	- gsoap-devel
	- log4cxx
	- log4cxx-devel
	- xerces-c
	- xerces-c-devel
	- tcsh
	- nedit
	- xterm
	- libtool
	- monotone
	- autoconf
	- uuid-devel
	- subversion
	- expat
	- expat-devel
	- perl-CPAN
	- log4j

In addition, you will need these Perl modules:

	- Fatal
	- XML::Parser
	- XML::Parser::Wrapper
	- XML::SAX

To run RCC, Java must be installed. GANIL recommends downloading and using Oracle Java rather than relying on the OpenJDK Java version installed by default. Download this from the Oracle website and install it. You may need to use the :command:`alternatives` command to make it the default.

After installing these packages, follow the directions in the source code's README files to compile and install the software. Start with NARVAL, then compile RCC, RCLOG, and RCC GUI, and copy the Scripts to the destination directory. 

..  note::

	Before compiling NARVAL, make sure to set the install directory as described in the README.


Configuring the Mac Minis
-------------------------

After compiling the software and making sure it runs, the Mac Minis need to be configured. This is done using Ansible playbooks (see :doc:`ansible`). 

First, create an RSA key pair for root on the control computer using :command:`ssh-keygen`. Copy this to the Mac Minis using the :doc:`distrib-root-pubkey <distrib-root-pubkey>` playbook. 

After that finishes, run the :doc:`daq-config <daq-config>` playbook. This will automatically install all dependencies on the Mac Minis, configure them, and install the DAQ software. 


Enabling/disabling the GUI on the Mac Minis
-------------------------------------------

To reduce the overhead on the Mac Minis, it might be good to disable the GUI by default. This does *not* prevent graphical programs from running via X forwarding, but it does stop the Gnome interface from being run. 

The default state of the system is defined by which "target" it loads at boot. The two relevant ones here are:

graphical.target
	Starts the GUI

multi-user.target
	Doesn't start the GUI

To see which is currently the default, run ::

	$ systemctl get-default

To temporarily switch targets (until the next reboot), run ::

	$ sudo systemctl isolate [target]

To change the default target, run ::

	$ sudo systemctl set-default [target]


Enabling/disabling the internet gateway
---------------------------------------

The left-hand iMac functions as an internet gateway by passing through internet packets from the 192.168.41.XX network and modifying them to make them look as if they originated at the iMac (see http://en.wikipedia.org/wiki/Network_address_translation). This took two steps to enable. (This is based on directions from http://support.apple.com/kb/HT200188.)

First, we need to enable packet forwarding. This was done by editing the file :file:`/etc/sysctl.conf` and adding the line ::

	net.inet.ip.forwarding=1

This can also be done on a temporary basis using the command

..  code-block:: bash

	$ sudo sysctl -w net.inet.ip.forwarding=1

however this will be reset on the next reboot. The forwarding can be disabled by setting the value back to 0.

The next step is to create packet filtering rules to perform the NAT. First, enable the packet filtering program :command:`pfctl` by modifying the file :file:`/System/Library/LaunchDaemons/com.apple.pfctl.plist` to include the flag :option:`-e` when running :command:`pfctl`. It should look like this: (note the line with the comment)

..  code-block:: xml

	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
	        <key>Disabled</key>
	        <false/>
	        <key>Label</key>
	        <string>com.apple.pfctl</string>
	        <key>WorkingDirectory</key>
	        <string>/var/run</string>
	        <key>UserName</key>
	        <string>root</string>
	        <key>GroupName</key>
	        <string>wheel</string>
	        <key>Program</key>
	        <string>/sbin/pfctl</string>
	        <key>ProgramArguments</key>
	        <array>
	                <string>pfctl</string>
	                <string>-e</string>            <!-- ADD THIS LINE -->
	                <string>-f</string>
	                <string>/etc/pf.conf</string>
	        </array>
	        <key>RunAtLoad</key>
	        <true/>
	</dict>
	</plist>

Now we need to make the rules for packet forwarding. Go to the directory :file:`/etc/pf.anchors` and open the file :file:`com.apple`. Add these lines near the top::

	nat-anchor "100-attpcNATRules/*"
	rdr-anchor "100.attpcNATRules/*"
	load anchor "100.attpcNATRules" from "/etc/pf.anchors/attpcNATRules"

Save this and then create the file :file:`/etc/pf.anchors/attpcNATRules` with the following contents::

	# NAT Rules for the attpc network

	nat on en1 from 192.168.41.0/8 to any -> (en1)
	pass from {lo0, 192.168.41.0/8} to any

Save this and reboot the computer, and the internet gateway should be working.