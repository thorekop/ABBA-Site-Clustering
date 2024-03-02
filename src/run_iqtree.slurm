#!/bin/bash

# thore Mon Aug 23 10:27:31 CEST 2021

# Job name
#SBATCH --job-name=iqtree
#
# Wall clock limit:
#SBATCH --time=96:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load Python/3.10.4-GCCcore-11.3.0 #Python/3.8.2-GCCcore-9.3.0
module load IQ-TREE/2.2.2.3-gompi-2022a #IQ-TREE/2.1.2-foss-2020a #add module name
module load BCFtools/1.15.1-GCC-11.3.0 #BCFtools/1.10.2-GCC-9.3.0
module load Ruby/3.0.5-GCCcore-11.3.0 #Ruby/2.7.2-GCCcore-9.3.0
module load R/4.2.1-foss-2022a #R/4.0.0-foss-2020a

# Get the command-line arguments.
vcf=${1}
prefix=${2}
number=${3} # 5000, 2000, 1000
path=${4}
length=${5} # 200, 500, 1000

# Reduce individuals from vcf-file.
mkdir -p ${path}
bcftools view -s tsk_0,tsk_5,tsk_10,tsk_15 -o ${path}/${prefix}.tmp.vcf ${vcf}

# Generate alignments.
python make_alignments_from_vcf.py ${path}/${prefix}.tmp.vcf ${prefix} -n ${number} -c 20000000 -l ${length} -p ${path}

# Delete vcf.
rm -f ${path}/${prefix}.tmp.vcf

# Reduce sequences from phylip-files.
for phy in ${path}/${prefix}*.phy
do
    echo "4 ${length}" > ${path}/${prefix}.tmp.phy
    cat ${phy} | grep -e tsk_0_1 -e tsk_5_1 -e tsk_10_1 -e tsk_15_1 >> ${path}/${prefix}.tmp.phy
    mv -f ${path}/${prefix}.tmp.phy ${phy}
    sleep 1
done

# Run iqtree and collapse nodes with short branches to polytomies..
echo "Run iqtree."
for phy in ${path}/${prefix}*.phy
do
    # Run iqtree.
    iqtree2 -s ${phy} -o tsk_15_1 -m HKY

    # Collapse all nodes connected by short branch lenths, overwrite original iqtree file.
    Rscript collapse_short_branches.r ${phy}.treefile ${path}/${prefix}.tmp.collapsed.tre 0.001

    # Delete alignments and iqtree output files.
    rm -f ${phy}*

    # Convert all branch lengths from scientific to decimal notation.
    ruby convert_branch_lengths_to_decimal_notation.rb ${path}/${prefix}.tmp.collapsed.tre ${phy}.treefile
    rm -f ${path}/${prefix}.tmp.collapsed.tre
done

# Combine inferred phylogenies into single file.
cat ${path}/${prefix}*.treefile > ${path}/${prefix}.trees 

# Remove tree files.
rm -f ${path}/${prefix}*.treefile

# Analyze tree asymmetry.
ruby analyze_tree_asymmetry.rb ${path}/${prefix}.trees ${path}/${prefix}.txt "tsk_0_1,tsk_5_1,tsk_10_1"


