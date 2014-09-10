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

The group "macminis" refers to all of them, while "active" and "inactive" refer to the ones that we're currently using and the ones that we aren't, respectively.

..  _ansible-command:

Running a single command
------------------------

A single task can be run on a target machine using the command :program:`ansible`. The basic usage of this command is [#f1]_

..  code-block:: bash

	ansible <host-pattern> [-f forks] [-m module_name] [-a args]

Arguments and Options
+++++++++++++++++++++

Following are a few useful options for the :program:`ansible` command. There are many more options, though, and these are documented in the command's manual page.

..  program:: ansible

..  option:: host-pattern

	The hosts to run the command on. This should be an element of the inventory file (see :ref:`ansible-inventory`).

..	option:: -f forks

	Specifies the degree of parallelism, or the number of hosts to run the command on at once. The default is 5. Use 10 to run the command on all ten Mac Minis at once.

..  option:: -m module_name

    Runs the specified module. Some examples are "command" or "shell". See http://docs.ansible.com/modules.html for a full list.

..	option:: -a args

	The arguments to be passed to the module. These should be given in quotes.

..  option:: -s, --sudo

	Uses :command:`sudo` to elevate privileges on the target machine

..  option:: -k, --ask-pass

	Ask for an SSH password instead of using public key authentication. This is useful when setting up a computer for the first time.

.. 	option:: -v, --verbose

	Gives more verbose output. Can be used a number of times. This is useful for debugging.

Examples
++++++++

To run a single terminal command on a collection of computers, execute this:

..	code-block:: bash
	
	$ ansible [target] -m command -a "[command to be run]"

For instance, to list the contents of :file:`/daq` on each computer, run

..  code-block:: bash

	$ ansible macminis -m command -a "ls /daq"

If you wanted to reboot all of the Mac Minis, you could run the following command. Note that we need to use :option:`--sudo` in this case.

..  code-block:: bash

	$ ansible macminis -m command -a "reboot" --sudo

..  note::
	
	Many commands can be done more efficiently by using Ansible's built-in modules. For information about this, see http://docs.ansible.com/modules.html.

Playbooks
---------

Ansible playbooks are reusable lists of tasks for Ansible to run. There are a variety of these in the directory :file:`~/ansible-attpc`, and they are all documented at :ref:`ansible-scripts-dir`.

To run a playbook, use the command :program:`ansible-playbook`:[#f2]_

..  code-block:: bash

	ansible-playbook <filename.yml> ... [options]

Arguments and Options
+++++++++++++++++++++

..  program:: ansible-playbook

..  option:: filename.yml

	The Ansible playbook file(s) to run.

..  option:: -f num

	The degree of parallelism to use. The default is 5.

..  option:: -l subset

	Limit the execution to a subset of the hosts specified in the playbook file. 

Additionally, the :command:`sudo`- and password-related options from :program:`ansible` apply for :program:`ansible-playbook` as well.

..  rubric:: Footnotes

..  [#f1] Taken from the manual page for :command:`ansible`.
..  [#f2] Taken from the manual page for :command:`ansible-playbook`.