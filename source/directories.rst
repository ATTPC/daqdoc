
Files and Directories
=====================

This page describes some of the installed files and directories for the system.

``/daq`` Directory
------------------

All of the files used by the DAQ system are installed under ``/daq``. This choice of location isn't particularly important, but it is provided to Narval at compile-time, so once the system has been compiled, the files cannot be moved.

The scripts used by the DAQ system to launch different components are particular about where each file is located. To make this easier to deal with, the computers have a structure of symbolic links instead of just installing the files in place. 

The files are organized as follows:

- ``/daq`` -- This is the root of the daq system tree.

  - ``ACQ_HOST`` -- Holds the symbolic link structure.
  
    - ``latest`` -- A link to the latest version. This should be updated for each new version.
    
    - ``[date]`` -- The version of the system released on [date]. The contents are all symlinks.
    
      - ``RCC``
      
      - ``RCC_GUI``
      
      - ``Narval``
      
      - ``RCLOG``
      
      - ``Scripts``
    
    - More versions
      
  - ``packages`` -- This is where the actual packages are installed. The symlinks should point to subdirectories of this folder.
  
  - ``GET`` -- The GET software, such as ``cobo-frame-viewer`` and ``getEccSoapServer``.
  
    - ``latest`` -- A link to the latest version.
    
    - ``GET-[date]`` -- An installed version of the GET software.
    
    - More versions
    
``/data`` Directory
-------------------

This structure exists solely because of the way Fedora partitioned the hard disks at installation. Each subdirectory of ``/data`` is a symlink to a directory in the attpc user's home directory. This is convenient since the filesystem mounted at ``/home`` is much larger (around 1.2 TB total) than the one mounted at ``/`` (which is only around 50 GB). 

The path ``/data`` was chosen since it is the default for the DAQ system, and it's easier to just make a symlink than to change all of GANIL's scripts.

``/data`` is organized as follows:

- ``/data`` -- The root: this is a real folder in ``/`` which must belong to the attpc user.

  - ``attpcX`` -- This points to ``/home/attpc/data``. It is the default path used by the DAQ system. If data were to be taken using just the control computer and no Mac Minis, then this is where it would be stored. Additionally, this is where the data can be found on each Mac Mini.
  
  - ``fetched`` -- This points to ``/home/attpc/fetched_data``. This is where data is stored after being synced from each Mac Mini. There is a folder inside for each Mac Mini, and the Ansible data fetching script will create a directory tree in each of these subfolders for each computer.
  
  - ``cleaned`` -- This points to ``/home/attpc/cleaned_data``. This is where reorganized data files are stored. Its contents are sorted by experiment name and run. These files are organized by the script :file:`rearrange_data` script.

``~/ansible-attpc`` Scripts directory
-------------------------------------

This directory contains several scripts and Ansible playbooks for configuring the system, copying files, and other tasks. Any new scripts should be stored here for consistency.

The contents of this directory are kept under version control using Git. Any changes should be committed to the repository using ``git commit`` and pushed to the remote repository using ``git push``. The local repository pushes to a remote repository hosted at https://bitbucket.org/jbradt/ansible-attpc which is publicly visible.

The current contents of this folder are the following scripts:

.. toctree::
   :maxdepth: 1

   daq-config
   distrib-root-pubkey
   distrib-experiment
   fetch-data
   rearrange_data

