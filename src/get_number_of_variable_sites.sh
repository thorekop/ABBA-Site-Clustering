# thore Fri Feb 24 14:35:18 CET 2023

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/alignments

# Make the log directory.
mkdir -p ../log/alignments

# Identify every single vcf-file.
for vcf in ../res/msprime/*vcf.gz
do

    # Get the file id.
    vcf_id=`basename ${vcf%.vcf.gz}`

    for length in 200 500 1000
    do

	# Set the prefix.
	table=../res/alignments/${vcf_id}_${length}.txt	

        # Set the number.
        if [ ${length} == 200 ]
        then
            number=5000
        elif [ ${length} == 500 ]
        then
            number=2000
        elif [ ${length} == 1000 ]
        then
            number=1000
        fi

	if [ ! -f ${table} ]
	then

            # Check how many jobs running.
            n_runs=`squeue -u thore | tail -n +2 | wc -l`
            if (( ${n_runs} < 800 ))
            then
		
		# Set the log file.
		log=../log/alignments/${vcf_id}_${length}.txt
		rm -f ${log}
		
		# Run slurm script.
		sbatch --account ${acct} -o ${log} get_number_of_variable_sites.slurm ${vcf} ${table} ${number} ${length}
            fi
	fi
    done
done
