..  highlight:: bash

``distrib-experiment`` -- Copy the DAQ experiment directory to the Mac Minis
============================================================================

This Ansible playbook syncs the given experiment directory to the Mac Minis. This should be done after any change to the configuration in RCC-GUI so that NARVAL can know about all of the components.

The script can be run like this::

	$ cd ~/ansible-attpc/distrib-experiment
	$ ansible-playbook distribute.yml -f 10 --extra-vars "exp_name=[experiment]"

where ``[experiment]`` should be replaced by the appropriate experiment name.