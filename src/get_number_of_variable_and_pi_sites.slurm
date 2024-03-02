#!/bin/bash

# thore Fri Feb 24 14:35:27 CET 2023

# Job name
#SBATCH --job-name=alignments
#
# Wall clock limit:
#SBATCH --time=15:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load Python/3.10.8-GCCcore-12.2.0
module load BCFtools/1.17-GCC-12.2.0
module load Ruby/3.2.2-GCCcore-12.2.0

# Get the command-line arguments.
vcf=`readlink -f ${1}`
table=`readlink -f ${2}`
number=${3} # 5000, 2000, 1000
length=${4} # 200, 500, 1000

# Copy script to SCRATCH.
cp make_alignments_from_vcf.py ${SCRATCH}
cp get_number_of_variable_sites.rb ${SCRATCH}
cp convert.py ${SCRATCH}

# Enter temporary directory.
cd ${SCRATCH}

# Reduce individuals from vcf-file.
echo "Running bcftools."
bcftools view -s tsk_0,tsk_5,tsk_10,tsk_15 -o tmp.vcf ${vcf}

# Generate alignments.
echo "Running make_alignments_from_vcf.py."
pop_size=`echo ${vcf} | cut -d "_" -f 4`
div_time=`echo ${vcf} | cut -d "_" -f 7`
rec_rate=`echo ${vcf} | cut -d "_" -f 10`
mut_rate=`echo ${vcf} | cut -d "_" -f 13`
intr_rate=`echo ${vcf} | cut -d "_" -f 16`
P2_rate=`echo ${vcf} | cut -d "_" -f 19`
run=`echo ${vcf} | cut -d "_" -f 20 | cut -d "." -f 1`
echo -e -n "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t" >> ${table}
python make_alignments_from_vcf.py tmp.vcf tmp -n ${number} -c 20000000 -l ${length} -s >> ${table}
