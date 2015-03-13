#AT-TPC DAQ Documentation

This repository contains the reStructuredText source of the documentation for the AT-TPC's data acquisition software. 

##View Documentation

The compiled docs are online at: https://groups.nscl.msu.edu/attpc/doc/daq

##Editing

The documentation is written in reStructuredText format for processing by Sphinx (http://sphinx-doc.org). This means that the following are required to compile the documentation:

- sphinx (and its dependencies)
- sphinx-bootstrap-theme (the theme for the docs)
- python (sphinx runs on it)

Once the documentation has been written and compiled, it can be uploaded to the NSCL server where it's hosted by using the `install_docs.sh` script from inside the lab's network.