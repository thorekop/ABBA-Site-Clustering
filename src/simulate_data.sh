# thore Wed May 5 11:34:46 CEST 2021

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/msprime

# Make the log directory.
mkdir -p ../log/msprime

# Simulate data with msprime.
for r in `seq 11 50` # || 2 3 (1e6)-> not complete!!!; Already done: 1 (5, 1e4, 1e5, 1e6); 2 (5, 1e4, 1e5); 3 (5, 1e4, 1e5); 4 (5, 1e4, 1e5); 5 (5, 1e4, 1e5); 6 (5, 1e4, 1e5); 7 (5, 1e4, 1e5); 8 (5, 1e4, 1e5); 9 (5, 1e4, 1e5); 10 (5, 1e4, 1e5);
do
    for pop_size in 1e5 #1e4 1e5 1e6 5
    do 
	for divergence_time in 3e7 #1e7 2e7 3e7 # XXX CONTINUE WITH 2e7 and 3e7 when 1e7 is done.
	do
	    for rec_rate in 1e-8
	    do
		for mut_rate in 2e-9 # 1e-9 2e-9
		do
		    for intr_rate in 0 1e-7  1e-8 # 0 1e-6 1e-7 1e-8 1e-9
		    do
			for P2_rate in 0.25 4 1 #2 4 0.5
			do
			    echo "Population size: ${pop_size}, divergence time: ${divergence_time}, recombination rate: ${rec_rate}, mutation rate: ${mut_rate}, introgression rate: ${intr_rate}, P2 rate: ${P2_rate}."
			
			    # Set log file.
			    log=../log/msprime/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r${r}.log
			
			    # Set output file.
			    rs=../res/msprime/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r${r}.vcf
			
			    # Submit slurm script.
			    if [ ! -f ${rs} ]
			    then 
				rm -f ${log}
				sbatch --account ${acct} -o ${log} simulate_data.slurm ${rs} ${pop_size} ${divergence_time} ${rec_rate} ${mut_rate} ${intr_rate} ${P2_rate}
			    fi	    
			done
		    done
		done
	    done
	done
    done
done
