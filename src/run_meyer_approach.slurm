#!/bin/bash

# thore Thu Nov 25 13:11:52 CET 2021

# Job name
#SBATCH --job-name=meyer
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
module load Ruby/2.7.2-GCCcore-9.3.0
module load R/4.0.0-foss-2020a

# Get the command line arguments.
trees=${1}
species_table=${2}
prefix=${3}

# Prepare a table of mrca ages for each gene tree file.
trees_base=`basename ${trees}`
Rscript get_mrca_table.r ${trees} > ${prefix}.mrca.txt
ruby summarize_mrca_table.rb ${prefix}.mrca.txt ${species_table} ${prefix}
