Components of the DAQ system
============================

The GANIL DAQ system is made up of several interacting components.

..  _narval:

NARVAL
------

NARVAL does the majority of the work in the system, as it is the program that actually acquires the data. It should run on all of the computers in the system (both the Mac Minis and the control computer). You don't really interact with NARVAL directly; instead, it is controlled by the :ref:`rcc`. 

..  warning::

	NARVAL communicates with itself internally using SSH. Therefore, SSH host key authentication *must* be configured on all computers running NARVAL. 

..  warning::

	NARVAL subsystems will not launch correctly if :command:`tcsh` is not the default shell. Additionally, the :file:`SetEnvACQ_ATTPC` script must be sourced by default in :file:`~/.tcshrc`.

..  _rcc:

Run Control Core (RCC) Server
-----------------------------

This part of the system controls runs and sends the commands to start and stop hardware and NARVAL. It knows about the topology of the DAQ setup, but it isn't aware of how each component works. It controls devices through the :ref:`ecc`. 

This should only be run on the control computer.

..  _rccgui:

RCC GUI
-------

This Java GUI is the main way to interact with the system. The interface can be used to start and stop runs and to describe the topology of the system. This program can be run from any computer, but should mainly be used on the control computer. 

..  image:: images/rccgui.png

RCLOG
-----

This collects log messages from the RCC server. It should be launched automatically on the control computer, and that's all that really needs to be done with it.

..  _ecc:

GET Electronics Control Core (ECC) Server
-----------------------------------------

This is a program from the GET software that controls the electronics. It is compiled separately from the rest of the DAQ system, and it's installed under :file:`/daq/GET`. It should be run on the control computer. 

..  note::

	In this DAQ system, the ECC server is responsible for managing all of the config files for the CoBos. Since we're only running one instance of the ECC server, all of the configurations for all CoBos can now be kept in one file.

..  _scripts:

GANIL Scripts
-------------

GANIL provides a collection of scripts to start and stop the various components of the system. These provide a menu for starting the software.

..  image:: images/acqmenu.png