#!/bin/bash

# m_matschiner Tue Jan 30 06:06:26 PM CET 2024

# Job name:
#SBATCH --job-name=get_concordance_factors
#
# Wall clock limit:
#SBATCH --time=1:00:00
#
# Processor and memory usage:
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G

# Set up job environment.
set -o errexit
set -o nounset
module purge &> /dev/null
module load IQ-TREE/2.2.2.3-gompi-2022a
module load Python/3.10.4-GCCcore-11.3.0
module load BCFtools/1.15.1-GCC-11.3.0

# Get the comman-line arguments.
vcf=`readlink -f ${1}`
script=`readlink -f ${2}`
table=`readlink -f ${3}`

# Change to the temporary directory.
cd ${SCRATCH}

# Make a subset of the vcf with a single (diploid) individual per species.
bcftools view ${vcf} -s "tsk_0,tsk_5,tsk_10,tsk_15" > tmp.vcf

# Convert the vcf file to phylip format.
python3 ${script} -i tmp.vcf

ls -l

# Reduce the phylip file to a single sequence per individual.
cat tmp.min4.phy | cut -d " " -f 1

# Write a treefile for IQ-TREE (assuming the correct tree).
echo "(((tsk_0,tsk_5),tsk_10),tsk_15);" > tmp.tre

# Use IQ-TREE to get the concordance factors.
iqtree2 -te tmp.tre -s tmp.min4.phy --scfl 100 --prefix scfl

ls -l

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tsCF_N\tsDF1_N\tsDF2_N" > ${table}

# Write settings into txt-file.
pop_size=`echo ${vcf} | cut -d "_" -f 4`
div_time=`echo ${vcf} | cut -d "_" -f 7`
rec_rate=`echo ${vcf} | cut -d "_" -f 10`
mut_rate=`echo ${vcf} | cut -d "_" -f 13`
intr_rate=`echo ${vcf} | cut -d "_" -f 16`
P2_rate=`echo ${vcf} | cut -d "_" -f 19`
run=`echo ${vcf} | cut -d "_" -f 20 | cut -d "." -f 1`

# Write concordance factors into txt-file.
sCF_N=`tail -n 1 scfl.cf.stat | cut -f 3`
sDF1_N=`tail -n 1 scfl.cf.stat | cut -f 5`
sDF2_N=`tail -n 1 scfl.cf.stat | cut -f 7`

echo -e -n "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${sCF_N}\t${sDF1_N}\t${sDF2_N}" >> ${table}

#cp scfl.cf.branch ${SUBMITDIR}
#cp scfl.cf.stat ${SUBMITDIR}
#cp scfl.cf.tree ${SUBMITDIR}
#cp scfl.treefile ${SUBMITDIR}
