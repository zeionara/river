#!/bin/bash

# cat requirements.txt
# lib_names=$(paste -sd '", "' < requirements.txt)
# echo $lib_names
# echo '"'$names'"'
# echo "setdiff(c($requirements), rownames(installed.packages()))"

read_requirements() {
    echo $(echo '"'$(awk NF $1 | awk 'ORS="\", \""')'"') | sed 's/, ""//g'
}

requirements=$(read_requirements requirements.txt)
dev_requirements=$(read_requirements dev-requirements.txt | sed -E 's/"([^"]+)",?/devtools::install_github("\1");/g')

sudo R --slave -e "install.packages(setdiff(c($requirements), rownames(installed.packages()))); $dev_requirements"
