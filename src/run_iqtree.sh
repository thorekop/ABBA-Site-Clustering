# thore Mon Aug 23 10:55:44 CEST 2021

# Set the account.
acct=nn9883k
          
# Make the result directory.
mkdir -p ../res/iqtree

# Make the log directory.
mkdir -p ../log/iqtree

# Check for every single vcf-file if dsuite-file present.
for vcf in ../res/msprime/pop_size_1e5*mut_rate_2e-9*.vcf
do

    # Get the file id.
    vcf_id=`basename ${vcf%.vcf}`

    # Set the path.
    path=../res/iqtree/${vcf_id}

    for length in 200 500 1000
    do
	
	# Set the prefix.
	prefix="iqtree_${length}"

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

	if [ ! -f ${path}/${prefix}.txt ]
	then

            # Check how many jobs running.
            n_runs=`squeue -u thore | tail -n +2 | wc -l`
            if (( ${n_runs} < 400 ))
            then

		# Set the log file.
		log=../log/iqtree/${vcf_id}_${prefix}.txt
		rm -f ${log}

		# Run IQ-TREE.
		sbatch --account ${acct} -o ${log} run_iqtree.slurm ${vcf} ${prefix} ${number} ${path} ${length}
	    fi
        fi
    done
done

