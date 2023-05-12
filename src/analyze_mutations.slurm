#!/bin/bash

# thore Thu Jan 02 18:03:41 CEST 2022

# Job name
#SBATCH --job-name=analyze_mutations
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
module load Python/3.9.6-GCCcore-11.2.0 #add module name

# Get the command line arguments.
file=${1}
res=${2}

# Run Analyze_mutations.py.
python3 analyze_mutations.py ${file} ${res}
