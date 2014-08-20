.. highlight:: perl

``rearrange_data.pl`` -- Script to rearrange fetched data
=========================================================

This script rearranges the data that has been fetched to the local computer using the Ansible playbook :file:`fetch-data`. The Ansible playbook leaves data in the directory ``/data/fetched`` in an inconvenient, nested set of directories. This script will instead move those files into a subdirectory of ``/data/cleaned`` for the current experiment.

There are a few variables that are important in this script::

	my $fetchdir = "/data/fetched"; # Where the fetched files are located
	my $cleandir = "/data/cleaned"; # Where the rearranged files should go
	my $expname = $ARGV[0];         # The name of the experiment

	# The subpath of $fetchdir where the data files are located.
	my $subpath = "ganacq_manip/$expname/acquisition/run";

	# The output location for the files.
	my $finalpath = "$cleandir/$expname";

These should be changed as necessary to reflect changes to the system.

To run the script, execute it on the command line and give the name of the current experiment as an argument. Assuming the name of the experiment is "experiment", the data could be rearranged as follows:

..  code-block:: bash

	$ cd ~/ansible-attpc
	$ ./rearrange_data.pl experiment