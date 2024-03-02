#!/bin/bash

# thore Mon Feb 13 14:34:34 CET 2023

# Job name
#SBATCH --job-name=vcf_stats
#
# Wall clock limit:
#SBATCH --time=168:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=2G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load BCFtools/1.14-GCC-11.2.0

# Get the command-line arguments.
vcf=${1}
prefix=${2}

# Run simulation.
bcftools stats ${vcf} > ${prefix}_stats.txt
echo -n "Number of bi-allelic sites: " >> ${prefix}_stats.txt
bcftools view -H -m 2 -M2 ${vcf} | wc -l >> ${prefix}_stats.txt

