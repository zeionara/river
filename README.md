# river

**R** **vi**sualiz**er** - a convenient tool for bringing the power and beauty of plotting facilities implemented in the R language libraries to your data

## Usage

Example of usage:

```sh
./source/main.r corpora/experiment
```

The command accepts two arguments - the first points to the folder with corpus data (the directory must contain at least two files - one with extension `yml` which declares desired plot properties and some corpus metadata and other contains the corpus data itself in the `tsv` format). The second parameter provides a path to the folder with images (may be omitted, by default this value is taken to be equal to `images`).

For the command above after the script execution a file with name `images/experiment.jpeg` will be generated.

## Prerequisities

The following instructions, commands and scripts are tested solely on Ubuntu 20.04. The installation must be executed only after setting your working directory to match the folder containing data from this repository.

1. Installing R itself 

```sh
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
```
2. Installing system-level dependencies
```sh
sudo apt-get update && sudo apt-get install libcairo2-dev -y # required for installing hrbrthemes on ubuntu, for other OSes there must be analogous packages
```
3. Installing R dependencies
```sh
./setup.sh # No output means that all required packages are already installed
```

## Examples

![electron-positions](images/electron-positions.jpeg)
![x-expectation-value-c-based-plot](images/x-expectation-value-c-based-plot.jpeg)
![sphere-volume-time-plot](images/sphere-volume-time-plot.jpeg)
![sphere-volume-error-plot](images/sphere-volume-error-plot.jpeg)
![x-expectation-value-n-based-plot](images/x-expectation-value-n-based-plot.jpeg)
