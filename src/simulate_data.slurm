#!/bin/bash

# thore Wed May 5 14:15:01 CEST 2021

# Job name
#SBATCH --job-name=simdata
#
# Wall clock limit:
#SBATCH --time=168:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=20G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load Python/3.8.6-GCCcore-10.2.0 #add module name

# Get the command-line arguments.
rs=${1}
pop_size=${2}
div_time=${3}
rec_rate=${4}
mut_rate=${5}
intr_rate=${6}
P2_rate=${7}

seed=$RANDOM
echo "seed: ${seed}"

# Run simulation.
python3 simulate_data.py $rs $pop_size $div_time $rec_rate $mut_rate $intr_rate $P2_rate $seed


