..  highlight:: bash

``distrib-root-pubkey`` -- Copy root user's public key to Mac Minis
===================================================================

This is a very simple Ansible playbook that copies root's RSA public key (``id_rsa.pub``) to the Mac Minis. This makes configuring them easier.

Specifically, this allows root to ssh into the Mac Minis *as root*.

To run this on a Mac Mini, do the following **as root** or using ``sudo``::
	
	# cd ~/ansible-attpc/distrib-root-pubkey
	# ansible-playbook distrib-root-pubkey.yml -k

The option ``-k`` will force Ansible to ask for an SSH password (which is the root password for the target computer). This is necessary since, presumably, the target computer does not yet have the root public key installed, and otherwise the script will fail.

By default, this will run on all Mac Minis. To limit it, use the option ``-l [hostname]``.