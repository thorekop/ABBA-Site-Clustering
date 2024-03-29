# m_matschiner Fri Aug 5 14:05:29 CEST 2022

# Set the account.
acct=nn9883k

# Load modules.
module purge &> /dev/null
module load GCCcore/10.3.0
module load GSL/2.7-GCC-10.3.0

# Make the bin directory.
mkdir -p ../bin

# Make the results and log directories.
mkdir -p ../res/dsuite_p-val1.2/
mkdir -p ../log/dsuite_p-val1.2/

# Download dsuite.
if [ ! -d ../bin/Dsuite ]
then
    git clone https://github.com/millanek/Dsuite.git
    cd Dsuite
    make
    cd ..
    mv Dsuite ../bin
fi

# Run the test for clustering of abba sites with dsuite.
#for gzvcf in ../res/msprime/pop_size_*_div_time_*_rec_rate_*.vcf.gz
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
			for gzvcf in ../res/msprime/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}*.vcf.gz
			do
	    
			    # Get the file id.
			    gzvcf_id=`basename ${gzvcf%.vcf.gz}`
			    
			    # Set the prefix.
			    prefix=../res/dsuite_p-val1.2/${gzvcf_id}_ks
			    
			    # Check if the results are already available.
			    if [ ! -f ${prefix}_tree.txt ]
			    then
				
				# Check how many jobs running.
				n_runs=`squeue -A ${acct} | tail -n +2 | wc -l`
				if (( ${n_runs} < 1700 ))
				then
				    
				    # Set the log file.
				    log=../log/dsuite_p-val1.2/${gzvcf_id}_ks.txt
				    rm -f ${log}
				    
				    # Run dsuite.
				    sbatch --account ${acct} -o ${log} run_dsuite_ks.slurm ${gzvcf} ${prefix}
				fi
			    fi
			done
		    done
		done
	    done
	done
    done
done

