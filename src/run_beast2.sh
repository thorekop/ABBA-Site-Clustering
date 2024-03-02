# thore Mon Sept 23 10:55:44 CEST 2021

# Set the account.
acct=nn9883k
          
# Make the result directory.
mkdir -p ../res/beast2_20231213

# Make the log directory.
mkdir -p ../log/beast2_20231213

# Check for every single gzvcf-file...

#for vcf in ../res/msprime/pop_size_1e5_div_time_1e7_*_mut_rate_2e-9*.vcf
#for vcf in ../res/msprime/pop_size_1e5_div_time_2e7_*_mut_rate_2e-9*.vcf # thore 22.10.2021 incomplete? Completed 29.10.2021
#for vcf in ../res/msprime/pop_size_1e5_div_time_3e7_*_mut_rate_2e-9*.vcf # thore 29.10.2021
for intr_rate in 0 1e-7 1e-8
do
    for P2_rate in 0.25 1 4
    do
	for gzvcf in ../res/msprime/pop_size_1e5_div_time_*_rec_rate_1e-8_mut_rate_2e-9_intr_rate_${intr_rate}_P2_rate_${P2_rate}*.vcf.gz
	do
	    # Get the file id.
	    gzvcf_id=`basename ${gzvcf%.vcf.gz}`
	    
	    #    # Get the file id.
	    #    vcf_id=`basename ${vcf%.vcf}`
	    
	    # Set the path.
	    path=../res/beast2_20231213/${gzvcf_id}
	    
	    for length in 500 #200 500 1000
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
		    if (( ${n_runs} < 1355 ))
		    then
			
			# Set the log file.
			log=../log/beast2_20231213/${gzvcf_id}_${prefix}.txt
			rm -f ${log}
			
			# Run Beast2.
			sbatch --account ${acct} -o ${log} run_beast2.slurm ${gzvcf} ${prefix} ${number} ${path} ${length}				
		    fi
		fi
	    done
	done
    done
done

