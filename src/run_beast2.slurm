#!/bin/bash

# thore Mon Sept 23 15:09:31 CEST 2021

# Job name
#SBATCH --job-name=beast2
#
# Wall clock limit:
#SBATCH --time=168:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1G

## Set up job environment:
set -o errexit # Exit the script on any error
set -o nounset # Treat any unset variables as an error
module --quiet purge # Reset the modules to the system default

# Load modules.
module load R/4.0.0-foss-2020a
module load Python/3.8.2-GCCcore-9.3.0
module load Beast/2.6.4-GCC-9.3.0 #add module name
module load BCFtools/1.10.2-GCC-9.3.0
module load Ruby/2.7.2-GCCcore-9.3.0

# Get the command-line arguments.
vcf=${1}
prefix=${2}
number=${3} # 5000, 2000, 1000
path=${4}
length=${5} # 200, 500, 1000

# If the trees results file already exists, then, just run the script to analyze tree asymmetry and quit.
if [ -f ${path}/${prefix}.trees ]
then
    ruby analyze_tree_asymmetry.rb ${path}/${prefix}.trees ${path}/${prefix}.txt "tsk_0_1,tsk_5_1,tsk_10_1"
    exit 0
fi

# Get the number of fasta and newick files in the directory with the right prefix.
n_fastas=`ls ${path}/${prefix}*.fasta | wc -l`
n_nwks=`ls ${path}/${prefix}*.nwk | wc -l`
n_fastas_and_nwks=$((${n_fastas} + ${n_nwks}))

# Check if the number of fastas and newicks is identical to the target number of markers.
if [ ${n_fastas_and_nwks} == ${number} ]
then
    echo "Found sufficient alignments and newick files."
    
# If neither fasta files nor newick files are found then fasta files are generated from the vcf file.
elif [ ${n_fastas_and_nwks} == 0 ]
then
    # Reduce individuals from vcf-file.
    mkdir -p ${path}
    bcftools view -s tsk_0,tsk_5,tsk_10,tsk_15 -o ${path}/${prefix}.tmp.vcf ${vcf}

    # Generate alignments.
    python make_alignments_from_vcf.py ${path}/${prefix}.tmp.vcf ${prefix} -n ${number} -c 20000000 -l ${length} -p ${path} -f fasta

    # Delete vcf.
    rm -f ${path}/${prefix}.tmp.vcf

    # Reduce sequences from fasta-files.
    for fasta in ${path}/${prefix}*.fasta
    do   
	cat ${fasta} | grep -A 1 -e tsk_0_1 -e tsk_5_1 -e tsk_10_1 -e tsk_15_1 --no-group-separator >> ${path}/${prefix}.tmp.fasta
	mv -f ${path}/${prefix}.tmp.fasta ${fasta}
    done

# In any other case, throw an error and quit.
else
    echo "ERROR: Found an unexpected number of fasta (${n_fastas}) and newick (${n_nwks}) files!"
    exit 1
fi

# Run babette and beast2 and treeannotator.
for fasta in ${path}/${prefix}*.fasta
do
    xml=${fasta%.fasta}.xml
    div_time=`basename ${path} | cut -d "_" -f 6`

    # Run babette.
    Rscript make_xml.r ${fasta} ${xml} ${div_time} 

    # Run Beast2.
    cd ${path}
    xml_base=`basename ${xml}`
    beast -overwrite ${xml_base}
    cd -

    # Run TreeAnnotator.
    treeannotator -burnin 20 -heights mean ${fasta%.fasta}.trees ${fasta%.fasta}.tre

    # Convert to Newick format.
    Rscript convert_to_newick.r ${fasta%.fasta}.tre ${fasta%.fasta}.nwk

    # Delete alignments and beast2 output files.
    rm -f ${fasta}
    rm -f ${fasta%.fasta}.trees
    rm -f ${fasta%.fasta}.tre
    rm -f ${xml}
    rm -f ${xml}.state
    rm -f ${fasta%.fasta}.log
done

# Combine inferred phylogenies into single file.
cat ${path}/${prefix}*.nwk > ${path}/${prefix}.trees 

# Remove tree files.
rm -f ${path}/${prefix}*.nwk

# Analyze tree asymmetry.
ruby analyze_tree_asymmetry.rb ${path}/${prefix}.trees ${path}/${prefix}.txt "tsk_0_1,tsk_5_1,tsk_10_1"
