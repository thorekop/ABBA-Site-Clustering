# thore Mon Feb 13 14:34:21 CET 2023

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/bcftools

# Make the log directory.
mkdir -p ../log/bcftools

# Identify every single vcf-file.
for pop_size in 1e4 1e5
do
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
				
				# Set the prefix.
				prefix=../res/bcftools/${vcf_id}

				if [ ! -f ${prefix}_stats.txt ]
				then
				    
				    # Check how many jobs running.
				    n_runs=`squeue -u thore | tail -n +2 | wc -l`
				    if (( ${n_runs} < 1300 ))
				    then
					
					# Set the log file.
					log=../log/bcftools/${vcf_id}.txt
					rm -f ${log}
					
					# Run slurm script.
					sbatch --account ${acct} -o ${log} get_vcf_stats.slurm ${vcf} ${prefix}
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
