..  highlight:: bash

:file:`fetch-data` -- Gets run data from the Mac Minis
======================================================

This Ansible playbook synchronizes the data directories on the Mac Minis with the :file:`/data/fetched` directory on the control computer. Since it uses :command:`rsync` internally, it will copy all files on the Mac Minis to the control computer. Therefore, it would be best to keep the data directories on the Mac Minis relatively clean.

To run this script, do this::

	$ cd ~/ansible-attpc/fetch-data
	$ ansible-playbook fetch.yml -f 10

This playbook is only configured to run on the active Mac Minis. For information about this, see :ref:`ansible-inventory`.