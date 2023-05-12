# thore Mon Feb 13 14:34:21 CET 2023

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/bcftools

# Make the log directory.
mkdir -p ../log/bcftools

# Identify every single vcf-file.
for vcf in ../res/msprime/*vcf.gz
do

    # Get the file id.
    vcf_id=`basename ${vcf%.vcf.gz}`

    # Set the prefix.
    prefix=../res/bcftools/${vcf_id}

    if [ ! -f ${prefix}_stats.txt ]
    then

        # Check how many jobs running.
        n_runs=`squeue -u thore | tail -n +2 | wc -l`
        if (( ${n_runs} < 400 ))
        then

            # Set the log file.
            log=../log/bcftools/${vcf_id}.txt
            rm -f ${log}

            # Run slurm script.
            sbatch --account ${acct} -o ${log} get_vcf_stats.slurm ${vcf} ${prefix}
        fi
    fi
done
