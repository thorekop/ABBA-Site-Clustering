# thore Fri Feb 24 14:35:18 CET 2023

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/alignments

# Make the log directory.
mkdir -p ../log/alignments

# Identify every single vcf-file.
for pop_size in 1e5 1e4
do
    for divergence_time in 1e7 2e7 3e7
    do
	for rec_rate in 1e-8
	do
	    for mut_rate in 1e-9 2e-9
	    do
		for intr_rate in 0 1e-6 1e-7 1e-8 1e-9
		do
		    for P2_rate in 0.25 4 1 2 0.5
		    do
			for vcf in ../res/msprime/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r*.vcf.gz
			do
			    
			    # Get the file id.
			    vcf_id=`basename ${vcf%.vcf.gz}`
			    
			    for length in 200 500 1000
			    do
				
				# Set the prefix.
				table=../res/alignments/${vcf_id}_${length}_variable_and_pi_sites.txt
				
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
				    if (( ${n_runs} < 1200 ))
				    then
					
					# Set the log file.
					log=../log/alignments/${vcf_id}_${length}_variable_and_pi_sites.txt
					rm -f ${log}
					
					# Run slurm script.
					sbatch --account ${acct} -o ${log} get_number_of_variable_and_pi_sites.slurm ${vcf} ${table} ${number} ${length}
				    fi
				fi
			    done
			done
		    done
		done
	    done
	done
    done
done
