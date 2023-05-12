#!/bin/bash

# michaelm Wed Aug 17 17:10:11 CEST 2022

# Job name
#SBATCH --job-name=compr
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
vcf_dir=${1}

# Compress all vcf files.
for vcf in ${vcf_dir}/*.vcf
do
    bgzip ${vcf}
done
