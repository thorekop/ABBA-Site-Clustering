# thore Fri Jan 12 13:33:33 CET 2024

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/genetic_distances

# Make the log directory.
mkdir -p ../log/genetic_distances

# Analyse mutations.
for file in ../res/msprime/pop_size_1e5*mut_rate_2e-9*r1.vcf.gz
do
    file_base=`basename ${file}`
    
    if [ ! -f ../res/genetic_distances/${file_base%.vcf.gz}.genetic_distances.txt ]
    then
	
	res=../res/genetic_distances/${file_base%.vcf.gz}.genetic_distances.txt
	
	# Define log files and run python script..
	log=../log/genetic_distances/${file_base%.vcf.gz}.log.txt
	rm -f ${log}
	
	# Check how many jobs running.
	n_runs=`squeue -u thore | tail -n +2 | wc -l`
	if (( ${n_runs} < 1352 ))
	then
	    sbatch --account ${acct} -o ${log} get_distances_from_vcf.slurm ${file} ${res}
	fi
    fi
done
