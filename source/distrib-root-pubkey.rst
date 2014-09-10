..  highlight:: bash

:file:`distrib-root-pubkey` -- Copies root user's public key to Mac Minis
=========================================================================

This is a very simple Ansible playbook that copies root's RSA public key (:file:`/root/.ssh/id_rsa.pub`) to the Mac Minis. This makes configuring them easier.

Specifically, this allows root to ssh into the Mac Minis *as root*.

To run this on a Mac Mini, do the following::
	
	$ cd ~/ansible-attpc/distrib-root-pubkey
	$ sudo ansible-playbook distrib-root-pubkey.yml -k

The option :option:`-k` will force Ansible to ask for an SSH password (which is the root password for the target computer). This is necessary since, presumably, the target computer will not yet have the root public key installed, and otherwise the script will fail.

By default, this will run on all Mac Minis. To limit it, use :option:`ansible-playbook -l`.