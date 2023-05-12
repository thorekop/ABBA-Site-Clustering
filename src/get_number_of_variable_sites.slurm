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
module load Python/3.8.2-GCCcore-9.3.0
module load BCFtools/1.10.2-GCC-9.3.0
module load Ruby/2.7.2-GCCcore-9.3.0

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
python make_alignments_from_vcf.py tmp.vcf tmp -n ${number} -c 20000000 -l ${length} -f phylip

# Convert alignments.
echo "Running convert.py."
for i in tmp*.phy
do
    python convert.py ${i} ${i%.phy}.nex -f nexus
done

# Open table.
echo -e "alignment\tn_variable_sites" > ${table}

# Get number of variable sites.
echo "Running get_number_of_variable_sites.rb."
for i in tmp*.nex
do
    echo -n -e "${i}\t" >> ${table}
    ruby get_number_of_variable_sites.rb ${i} >> ${table}
done
