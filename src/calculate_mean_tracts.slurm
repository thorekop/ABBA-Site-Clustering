#!/bin/bash

# thore Wed Jan 12 11:52:38 CET 2022

# Job name
#SBATCH --job-name=means_cgenes_tracts_length
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
#add module name (here no modules required)

# Get the command line arguments.
folder=${1}

# Calculate means for tract lengths.
for file in ${folder}/*.tracts.txt
do
	pop_size=`echo ${file} | cut -d "_" -f 3`
	div_time=`echo ${file} | cut -d "_" -f 6`
	rec_rate=`echo ${file} | cut -d "_" -f 9`
	mut_rate=`echo ${file} | cut -d "_" -f 12`
	intr_rate=`echo ${file} | cut -d "_" -f 15`
	P2_rate=`echo ${file} | cut -d "_" -f 18`
	run=`echo ${file} | cut -d "_" -f 19 | cut -d "." -f 1`
	means_c_genes_length=`cat ${file%.tracts.txt}.c_genes.txt | tail -n +2 | cut -f 3 | awk '{ total_1 += $1; count_1++ } END { print total_1/count_1 }'`
    means_tracts_length=`cat ${file} | tail -n +2 | cut -f 3 | awk '{ total_2 += $1; count_2++ } END { print total_2/count_2 }'`
	n_introgressed_tracts=`cat ${file} | grep "11_21__1_11_21" | wc -l`
	if [[ ${n_introgressed_tracts} > 0 ]]
	then
	    means_introgressed_tracts_length=`cat ${file} | grep "11_21__1_11_21" | cut -f 3 | awk '{ total_3 += $1; count_3++ } END { print total_3/count_3 }'`
	else
	    means_introgressed_tracts_length="NA"
	fi
	echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${means_c_genes_length}\t${means_tracts_length}\t${n_introgressed_tracts}\t${means_introgressed_tracts_length}" >> ../res/tables/means_cgenes_tracts_length.txt
done

