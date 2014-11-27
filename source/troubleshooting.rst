..  highlight:: bash

Troubleshooting
===============

This page lists some troubleshooting tips for a few common problems that the DAQ system may have. It's organized into a section for each major problem.

NARVAL Died
-----------

If you get messages in RCC GUI that say **"Narval Communication Error"**, then the NARVAL processes have most likely died. 

..  Note::
	"Narval Communication Error" messages are common after clicking "Exit." This is probably a bug. Wait a few minutes, and you should see a series of messages for the ssh commands killing the NARVAL processes on the Mac Minis. After this, everything should be back to normal.

At this point, try to end the run if possible. Then it's probably best to restart all NARVAL processes. 

    #. Go to the Main Menu (in the terminal window) and use the :guilabel:`Toolkit` to kill the NARVAL controlling processes on the Control computer.
    #. Check if there are any NARVAL actors still running on the Mac Minis. Execute the following::

    	$ ansible macminis -m shell -a "ps -e | grep gnarval"

    #. If any Mac Mini returned a result other than "Failed," then there are still NARVAL processes running on that computer. In this case, kill all NARVAL processes by executing this::

    	$ sudo ansible macminis -m shell -a "pkill gnarval"

    #. Now you should be able to restart NARVAL's controlling processes on the Control computer using the appropriate option in the Main Menu's :guilabel:`Toolkit`.

If this fails, restart the whole DAQ system.

RCC Died
--------

A message saying "RCC Communication Error" may indicate that RCC has died. In this case, just restart the whole DAQ system.

An ECC Server is not responsive
-------------------------------

If an ECC server stops communicating with the DAQ system, it may need to be restarted. 

	#. Try to stop the run if possible. This should at least preserve the data from the other CoBos. 

	#. Try to communicate with the unresponsive ECC server using the terminal. (This is unlikely to help, but it's worth a try.) Try to use the ``getEccSoapClient`` command to probe the server's status and send it a stop command. The commands to try are the following::

		$ getEccSoapClient --host=[IP of Mac Mini] status
		$ getEccSoapClient --host=[IP of Mac Mini] stop
		$ getEccSoapClient --host=[IP of Mac Mini] exit

	#. If this doesn't do anything, then restart the ECC server on the Mac Mini in question. Connect to the Mac Mini with ssh and run::

		$ sudo systemctl restart ecc

	#. At this point the CoBo associated with the rebooted ECC server is probably stuck in an indeterminate state. It would be best to power-cycle it.

In the very unfortunate and hopefully unlikely case that *all* of the ECC servers are unresponsive, it will probably be impossible to stop the run. Try anyway, and then use the following Ansible command to do the same thing as above, but on *all* of the Mac Minis::

	$ sudo ansible macminis -m command -a "systemctl restart ecc"

Now power-cycle all of the CoBos, just for good measure.

NARVAL cannot reach a particular Mac Mini
-----------------------------------------

If, during the initialization process for NARVAL, it fails for a particular Mac Mini, try checking the firewall settings on the Mac Minis::

	$ sudo ansible macminis -m command -a "firewall-cmd --get-active-zones"

This prints out information on the firewall zone that each Mac Mini's network interface is assigned to. These should all say "Trusted." If one says anything other than "Trusted" (and especially if the problematic Mac Mini says anything other than "Trusted"), then this may be the cause of the problem. Connect to each Mac Mini with an incorrect zone assignment and run::

	$ sudo firewall-cmd --change-interface=[interface name] --zone=trusted
	$ sudo firewall-cmd --change-interface=[interface name] --zone=trusted --permanent

The first command changes the current setting, and the next one sets it for the next boot of the computer.


