#!/bin/bash

# thore Tue Aug 31 14:23:41 CEST 2021

# Job name
#SBATCH --job-name=quibl
#
# Wall clock limit:
#SBATCH --time=10:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load Python/3.11.3-GCCcore-12.3.0 ### module updated from Python/2.7.18-GCCcore-9.3.0 #add module name

# Get the command line arguments.
quibl_settings=${1}

# Run Quibl.
python QuIBL.py ${quibl_settings} 
