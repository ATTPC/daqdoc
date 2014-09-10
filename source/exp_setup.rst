Setting up an experiment
========================

It takes a bit of work to set up an experiment the first time. The main tasks are to:

  - Set up the required directories
  - Describe the components of the system
  - Describe the connections between these components
  - Distribute this information to the Mac Minis
  
Most of this can be done within the RCC GUI.

..  warning::

    Some of this information is a bit preliminary, and it could change in the near future if we discover a better way to configure the system.
    
..  note::
    
    Throughout this process, make sure to save frequently with :kbd:`Ctrl-s`.

Initializing the experiment
---------------------------

Start by running the script :file:`start_ACQ` (located in the :file:`/daq/ACQ_HOST/latest/Scripts` directory). This should be in the environment's :envvar:`PATH` variable already, so it can be run from any working directory. The script takes one argument: the name of the experiment to be created. For example, to start an experiment called "demo", run this command in a terminal:

..  code-block:: bash
    
    $ start_ACQ demo
    
This will ask a series of questions. Respond as follows:

  #. Say yes to create the root directory of the experiment (under :file:`~/ganacq_manip`)
  #. Accept the default data storage path (:file:`/data/attpcX`)
  #. Press enter to finish
  
Now you should see the main menu:

..  image:: images/acqmenu.png

Type :kbd:`pa Enter` to edit some experiment variables. This will bring up a :command:`nedit` window.

..  image:: images/acqparams.png

Scroll down and find the following section:

..  code-block:: perl

    # Main computer definition :
    # ACQ_SERV_NAME defines the name of the main computer on which 
    # you want to launch your acquisition.
    # This enable to have several client computers to run command
    # and/or visu sessions
    # If this variable is not defined, the main computer is the one on which
    # you launch the start_acq menu. In this case, take care to not launch the same experiment 
    # on several computers at the time!
    #
    #$ENV{'ACQ_SERV_NAME'} = "ganp670";
    
Uncomment the last line of this and change it to say

..  code-block:: perl

    $ENV{'ACQ_SERV_NAME'} = "control";
    
This tells the system that the computer with the hostname "control" will be running RCC server and controlling the experiment. Save this file and close it to return to the main menu.

At this point, we're ready to launch the rest of the system. Type :kbd:`rc Enter` to launch NARVAL, RCC, the RCC GUI, and the rest of the components. Be patient as this takes a moment and opens a lot of windows.

Describing the equipment
------------------------

Once the RCC GUI window appears, we can start to describe the DAQ topology. Initially, the window will be empty:

..  image:: images/empty_rccgui.png

Adding NARVAL subsystems
++++++++++++++++++++++++

Start by adding a NARVAL subsystem for each Mac Mini. Click on :guilabel:`Narval sub-systems` at the top of the window and then click :guilabel:`New` in the window that appears. Then fill in information for each subsystem as follows:

+----------------+-------------------------+
|Item            | Value                   |
+================+=========================+
|Name            | :samp:`NARVAL{X}`       |
+----------------+-------------------------+
|Hostname        | :samp:`192.168.41.6{X}` |
+----------------+-------------------------+
|Coordinator CPU | :samp:`192.168.41.6{X}` |
+----------------+-------------------------+

Here, ``X`` is to be replaced with the index of the Mac Mini in question. Here is a completed window for ``mm0``:

..  image:: images/new_narval_subsys.png

Repeat this process for each Mac Mini.

Adding components
+++++++++++++++++

To add a component, click anywhere in the grid and then click the green :guilabel:`OK` button. 

..  image:: images/add_component.png

Start by adding the ECC server. In the :guilabel:`Choose equipment type` window, choose "Electronics Control Core" and press :guilabel:`OK`. Name it "ECC" (or anything else reasonable), give it the HostName ``192.168.41.10`` (the IP address of the control computer), and leave the port as ``8083``. Press :guilabel:`Add 1 ECC` and the server will appear on the grid.

..  image:: images/ecc_on_grid.png

Next we need to add the components that collect data from each CoBo. Start by clicking on the grid and adding a component of the type "Narval actor defined by a template file". Enter these values:

+------------------+----------------------------------+
|Item              | Value                            |
+==================+==================================+
|Name              | :samp:`CoBo[{X}]`                |
+------------------+----------------------------------+
|HostName          | :samp:`192.168.41.6{X}`          |
+------------------+----------------------------------+
|Log Level         | (any)                            |
+------------------+----------------------------------+
|Template file     | ``gnarval_mfm_catcher.template`` |
+------------------+----------------------------------+
|Narval sub-system | :samp:`NARVAL{X}`                |
+------------------+----------------------------------+

Again, replace the ``X`` with the index of the Mac Mini. The window should look like this (for ``mm0``):

..  image:: images/new_mfm_catcher.png

..  warning::
    
    The name of the MFM catcher *must* match the name of a CoBo in the configuration files given to ECC server. Generally, the file calls the CoBos ``CoBo`` and then indexes them, hence ``CoBo[0]``, ``CoBo[1]`` etc. are appropriate names.
    
Next, add a component of the type "MFM Narval Watcher actor". Fill in

+------------------+----------------------------------+
|Item              | Value                            |
+==================+==================================+
|Name              | :samp:`Watcher{X}`               |
+------------------+----------------------------------+
|HostName          | :samp:`192.168.41.6{X}`          |
+------------------+----------------------------------+
|Log Level         | (any)                            |
+------------------+----------------------------------+
|Narval sub-system | :samp:`NARVAL{X}`                |
+------------------+----------------------------------+

And finally add a component of the type "MFM Narval Storage actor" with the same settings as the watcher actor, but with the name :samp:`Storage{X}`.

Repeat this process for each Mac Mini.

Linking components
++++++++++++++++++

Once we've added all of the components, we need to tell RCC how they're connected to each other. Do this by adding links. At the top of the window, choose :guilabel:`Add link`. This changes the behavior of the mouse so that clicking in the grid area will add a link between components.

..  image:: images/radio_buttons.png

Click and drag from one component to another to add a link. The links between the ECC and the MFM Catchers need to be set up using these options:

..  image:: images/link_ecc.png

Note that I've selected ``eth1`` for both ports and added two zeros to the buffer size. The rest of the settings are the defaults.

For links between NARVAL components, use these settings:

..  image:: images/link_narval.png

This time, everything is left as the default except for the buffer size.

When you've finished linking components, the setup should look something like this:

..  image:: images/full_rccgui.png

..  note::

    I've used different names for the NARVAL subsystems in this image. It doesn't matter what they're called as long as it's meaningful and consistent. The only constraint is that each subsystem must have a unique name.
    
Start and stop configurations
-----------------------------

Next, we must tell RCC what order to start and stop the components in when we start and stop runs. In the menu bar, choose :guilabel:`Configuration->Start configuration`. Add components to the list such that all of the NARVAL subsystems start *before* ECC starts. That way, the computers will be ready when data starts to flow.

..  image:: images/start_config.png

Now, choose :guilabel:`Configuration->Stop configuration` and arrange the components in the opposite order (or, just make sure that ECC stops first):

..  image:: images/stop_config.png


Distributing the configuration to the Mac Minis
-----------------------------------------------

Now we need to trick the system into producing the NARVAL configuration files. Do this by clicking :guilabel:`Mode->Monitoring mode`. This puts the RCC server into a mode where it's ready to take commands, and it should also try to communicate with the NARVAL processes on the Mac Minis. 

..  note::
    
    This will produce error messages if NARVAL is not running on the Mac Minis or ECC server is not running on the control computer. These messages can be ignored.
    
After waiting a moment, put the system back into :guilabel:`Editing mode`. 

..  warning::

    To be on the safe side, it is probably best to save and quit the DAQ system on the control computer before continuing. Do this by going back to the main menu and pressing :kbd:`tk Enter kall Enter`.
    
Now open a terminal and execute the following commands:

..  code-block:: bash

    $ cd ~/ansible-attpc/distrib-experiment
    $ ansible-playbook distribute.yml -f 10 --extra-vars "exp_name=[experiment name]"

Replace ``[experiment name]`` with the name of your experiment. This will sync the RCC and NARVAL configuration files to the Mac Minis. (This is described in more detail in :doc:`distrib-experiment`.)

Once this finishes, you should be ready to take data.
    

