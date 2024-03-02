#!/bin/bash

# thore Mon Feb 13 14:34:34 CET 2023

# Job name
#SBATCH --job-name=conc_stats
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
module load Python/3.9.6-GCCcore-11.2.0

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tsCF_N\tsDF1_N\tsDF2_N\tD_stat\tp_value" > ../res/tables/concordance_factors.txt

# Take iqtree file IDs.
for file in ../res/site_concordance/*.txt
    do
	pop_size=`tail -n 1 ${file} | cut -f 1`
	div_time=`tail -n 1 ${file} | cut -f 2`
	rec_rate=`tail -n 1 ${file} | cut -f 3`
	mut_rate=`tail -n 1 ${file} | cut -f 4`
	intr_rate=`tail -n 1 ${file} | cut -f 5`
	P2_rate=`tail -n 1 ${file} | cut -f 6`
	run=`tail -n 1 ${file} | cut -f 7`
	sCF_N=`tail -n 1 ${file} | cut -f 8`
	sDF1_N=`tail -n 1 ${file} | cut -f 9`
	sDF2_N=`tail -n 1 ${file} | cut -f 10`
	res_line=`python3 analyze_scf_asymmetry.py ${file}`
	D_stat=`echo ${res_line} | tr -s " " | cut -d " " -f 1`
	p_value=`echo ${res_line} | tr -s " " | cut -d " " -f 2`
	echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${sCF_N}\t${sDF1_N}\t${sDF2_N}\t${D_stat}\t${p_value}" >> ../res/tables/concordance_factors.txt
    done
done
