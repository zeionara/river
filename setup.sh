#!/bin/bash

# cat requirements.txt
# lib_names=$(paste -sd '", "' < requirements.txt)
# echo $lib_names
# echo '"'$names'"'
# echo "setdiff(c($requirements), rownames(installed.packages()))"

requirements=$(echo $(echo '"'$(awk NF requirements.txt | awk 'ORS="\", \""')'"') | sed 's/, ""//g')
sudo R --slave -e "install.packages(setdiff(c($requirements), rownames(installed.packages())))"
