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
mkdir -p ../res/dsuite
mkdir -p ../log/dsuite

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
for gzvcf in ../res/msprime/pop_size_1e5_div_time_*_mut_rate_1e-9_*.vcf.gz
do

    # Get the file id.
    gzvcf_id=`basename ${gzvcf%.vcf.gz}`

    # Set the prefix.
    prefix=../res/dsuite/${gzvcf_id}_ks

    # Check if the results are already available.
    if [ ! -f ${prefix}_tree.txt ]
    then

	    # Check how many jobs running.
	    n_runs=`squeue -A ${acct} | tail -n +2 | wc -l`
	    if (( ${n_runs} < 800 ))
	    then

	        # Set the log file.
	        log=../log/dsuite/${gzvcf_id}_ks.txt
	        rm -f ${log}

	        # Run dsuite.
	        sbatch --account ${acct} -o ${log} run_dsuite_ks.slurm ${gzvcf} ${prefix}

	    fi
    fi
done
