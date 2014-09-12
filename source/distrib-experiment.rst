..  highlight:: bash

:file:`distrib-experiment` -- Copies the DAQ experiment directory to the Mac Minis
==================================================================================

This Ansible playbook syncs the given experiment directory to the Mac Minis. This should be done when a new experiment is created.

The script can be run like this::

	$ cd ~/ansible-attpc/distrib-experiment
	$ sudo ansible-playbook distribute.yml -f 10 --extra-vars "exp_name=[experiment]"

where ``[experiment]`` should be replaced by the appropriate experiment name.
