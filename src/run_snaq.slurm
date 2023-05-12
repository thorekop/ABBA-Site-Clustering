#!/bin/bash

# thore Tue Nov 9 14:33:51 CET 2021

# Job name
#SBATCH --job-name=snaq
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
module load Julia/1.6.1-linux-x86_64 #add module name

# Get the command line arguments.
treefile=${1}
prefix=${2}

# Run SNaQ.
julia SNaQ.jl ${treefile} ${prefix}.net0 ${prefix}.net1 ${prefix}
