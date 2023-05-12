# thore Mon Sept 23 10:55:44 CEST 2021

# Set the account.
acct=nn9883k
          
# Make the result directory.
mkdir -p ../res/beast2

# Make the log directory.
mkdir -p ../log/beast2

# Check for every single vcf-file if dsuite-file present.

#for vcf in ../res/msprime/pop_size_1e5_div_time_1e7_*_mut_rate_2e-9*.vcf # thore 08.10.2021 + 20.10.2021 FOR SOME beast_200.txt still missing?
#for vcf in ../res/msprime/pop_size_1e5_div_time_2e7_*_mut_rate_2e-9*.vcf # thore 22.10.2021 incomplete? Completed 29.10.2021
for vcf in ../res/msprime/pop_size_1e5_div_time_3e7_*_mut_rate_2e-9*.vcf # thore 29.10.2021
do

    # Get the file id.
    vcf_id=`basename ${vcf%.vcf}`

    # Set the path.
    path=../res/beast2/${vcf_id}

    for length in 200 500 1000
    do
	
	# Set the prefix.
	prefix="beast2_${length}"

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

	if [ ! -f ${path}/${prefix}.trees ]
	then

            # Check how many jobs running.
	    me=`whoami`
            n_runs=`squeue -u ${me} | tail -n +2 | wc -l`
            if (( ${n_runs} < 1000 ))
            then

		# Set the log file.
		log=../log/beast2/${vcf_id}_${prefix}.txt
		rm -f ${log}

		# Run Beast2.
		sbatch --account ${acct} -o ${log} run_beast2.slurm ${vcf} ${prefix} ${number} ${path} ${length}
	    fi
        fi
    done
done

