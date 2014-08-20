``daq-config`` -- Ansible playbook for configuring the Mac Minis
================================================================

This directory contains the configuration information for the Mac Minis. It handles a variety of tasks:

	- Installing dependencies for the DAQ system and the GET software
	- Configuring firewall rules to allow communications
	- Setting up RSA encryption keys for SSH on each machine to allow access without a password (necessary for NARVAL to work)
	- Configuring the environment on each computer to load the correct variables for the DAQ system
	- Installing the DAQ and GET packages themselves

The actual tasks are automated by Ansible, and they can all be easily read in the YAML files in the directory.

To apply this configuration, run the following in the terminal **as root** (or using sudo):

..  code-block:: bash
	
	# cd ~/ansible-attpc/daq-config
	# ansible-playbook site.yml -f 10

Note that the ``site.yml`` file is set to apply the configuration to *all* mac minis. To change this, either change the ``hosts`` directive in ``site.yml`` or use the option ``-l`` in the ``ansible-playbook`` command. For example, to just apply the configuration to ``mm1``, run (as root)

..  code-block:: bash
	
	# ansible-playbook site.yml -l mm1