#!/bin/bash

# thore Fri Jan 12 13:43:53 CET 2024

# Job name
#SBATCH --job-name=genetic_distances
#
# Wall clock limit:
#SBATCH --time=03:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load Python/3.11.3-GCCcore-12.3.0 #add module name

# Get the command line arguments.
file=`readlink -f ${1}`
res=`readlink -f ${2}`

cd ${SCRATCH}
cp /cluster/work/users/thore/dstats/simulation_data/src/get_distances_from_vcf.py .
cp ${file} tmp.vcf.gz
gunzip tmp.vcf.gz

# Run Analyze_mutations.py.
python3 get_distances_from_vcf.py tmp.vcf ${res} -l 20000000
