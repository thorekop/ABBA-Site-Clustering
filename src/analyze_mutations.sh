# m_matschiner Thu Jan 6 12:54:25 CET 2022

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/analyze_mutations

# Make the log directory.
mkdir -p ../log/analyze_mutations

# Analyse mutations.
for file in ../res/msprime/*.mutations.txt
do
    file_base=`basename ${file}`

    if [ ! -f ../res/analyze_mutations/${file_base%.txt}.summary.txt ]
    then

	res=../res/analyze_mutations/${file_base%.txt}.summary.txt

	# Define log files and run SNaQ.
	log=../log/analyze_mutations/${file_base%.txt}.log.txt
	
	# Check how many jobs running.
	n_runs=`squeue -u thore | tail -n +2 | wc -l`
	if (( ${n_runs} < 750 ))
	then
            sbatch --account ${acct} -o ${log} analyze_mutations.slurm ${file} ${res}
	fi
    fi
done
