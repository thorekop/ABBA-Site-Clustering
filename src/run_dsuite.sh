# thore Tue Jun 29 12:26:39 CEST 2021

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/dsuite_20231030

# Make the log directory.
mkdir -p ../log/dsuite_20231030

# Check for every single vcf-file if dsuite-file present.
for vcf in ../res/msprime/*vcf
do

    # Get the file id.
    vcf_id=`basename ${vcf%.vcf}`

    # Set the prefix.
    prefix=../res/dsuite_20231030/${vcf_id}

    if [ ! -f ${prefix}_tree.txt ]
    then
	
	# Check how many jobs running.
	n_runs=`squeue -u thore | tail -n +2 | wc -l`
	if (( ${n_runs} < 400 ))
	then

	    # Set the log file.
	    log=../log/dsuite_20231030/${vcf_id}.txt
	    rm -f ${log}

	    # Run Dsuite.
	    sbatch --account ${acct} -o ${log} run_dsuite.slurm ${vcf} ${prefix}
	fi
    fi
done
