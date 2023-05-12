#!/bin/bash

# thore Tue Jun 29 12:31:39 CEST 2021

# Job name
#SBATCH --job-name=dsuite
#
# Wall clock limit:
#SBATCH --time=1:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load Dsuite/20210309-GCC-9.3.0 #add module name

# Get the command-line arguments.
vcf=${1}
prefix=${2}

# Run simulation.
Dsuite Dtrios -o ${prefix} -t ../data/trees/dsuite_tree.nwk ${vcf} ../data/tables/dsuite_species.txt 

# Delete unnnecessary files.
rm ${prefix}_BBAA.txt ${prefix}_Dmin.txt ${prefix}_combine.txt ${prefix}_combine_stderr.txt
