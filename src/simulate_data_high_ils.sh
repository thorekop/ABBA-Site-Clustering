# thore Wed May 5 11:34:46 CEST 2021

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/msprime/high_ils

# Make the log directory.
mkdir -p ../log/msprime/high_ils

# Simulate data with msprime.
for r in `seq 1 10`
do
    for pop_size in 1e4 1e5
    do 
	    for divergence_time in 1e7 2e7 3e7
	    do
	        for rec_rate in 1e-8
	        do
		        for mut_rate in 1e-9 2e-9
		        do
		            for intr_rate in 0 # 1e-6 1e-7 1e-8 1e-9
		            do
			            for P2_rate in 1 # 0.25 0.5 1 2 4
			            do
			                echo "Population size: ${pop_size}, divergence time: ${divergence_time}, recombination rate: ${rec_rate}, mutation rate: ${mut_rate}, introgression rate: ${intr_rate}, P2 rate: ${P2_rate}."

			                # Set log file.
			                log=../log/msprime/high_ils/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r${r}.log
			
			                # Set output file.
			                rs=../res/msprime/high_ils/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r${r}.vcf
			
			                # Submit slurm script.
			                if [ ! -f ${rs} ]
			                then 
				                rm -f ${log}
				                sbatch --account ${acct} -o ${log} simulate_data_high_ils.slurm ${rs} ${pop_size} ${divergence_time} ${rec_rate} ${mut_rate} ${intr_rate} ${P2_rate}
			                fi
			            done
		            done
		        done
	        done
	    done
    done
done
