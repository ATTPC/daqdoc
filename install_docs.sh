#!/bin/bash

make clean
make html

if [ $? == 0 ]; then
    cd build/html
    rsync -r --delete-before ./ attpc@fishtank.nscl.msu.edu:/soft/services/groups/attpc/doc/daq/
fi