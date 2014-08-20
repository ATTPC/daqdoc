Ansible
=======

Ansible is a system for distributing commands to a large number of computers. It can be used to initially configure the systems and to run one-off commands on all of the Mac Minis.

For more information, see the Ansible documentation at http://docs.ansible.com

The rest of this page will give some basics on using Ansible in our setup.

..  _ansible-inventory:

Inventory
---------

The inventory is the list of computers Ansible knows about. Ansible keeps its list of hosts in the file :file:`/etc/ansible/hosts`. This has a listing of hostnames. The current version looks like this:

..  code-block:: ini

	[macminis]
	mm[0:9]

	[active]
	mm0
	mm1
	mm2
	#mm3
	#mm4
	#mm5
	mm6
	mm7
	mm8
	mm9

	[inactive]
	mm[3:5]

The group "macminis" refers to all of them, while "active" and "inactive" refer to the ones we're currently using.

..  _ansible-command:

Running a single command
------------------------

A single command can be run on a collection of machines with Ansible. To do this, try:

..	code-block:: bash
	
	$ ansible [target] -m command -a "[command to be run]"

For instance, to list the contents of :file:`/daq` on each computer, run

..  code-block:: bash

	$ ansible macminis -m command -a "ls /daq"

A command can be run with :command:`sudo` by using the option ``--sudo``. For example, to reboot all of the Mac Minis, run

..  code-block:: bash

	$ ansible macminis -m command -a "reboot" --sudo

..  note::
	
	Many commands could be done more efficiently by using Ansible's built-in modules. For information about this, see http://docs.ansible.com/modules.html.

Playbooks
---------

Ansible playbooks are reusable lists of tasks for Ansible to run. There are a variety of these in the directory :file:`~/ansible-attpc`, and they are all documented at :ref:`ansible-scripts-dir`.

Briefly, to run a playbook, use the command :command:`ansible-playbook`. Some important options are :option:`-l`, which limits the playbook to run on only the specified hosts, and :option:`-f`, which controls the parallelism of the run. More can be found in the man page for this command.