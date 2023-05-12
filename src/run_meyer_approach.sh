# thore Thu Nov 25 13:20:24 CET 2021

# Set the account.
acct=nn9883k

# Set the directory with gene tree files (that end in .trees).
trees_dir="../res/beast2"

# Set the species table.
species_table="../data/tables/species.txt"

# Set and make the directory with tables of mrca ages.
res_dir="../res/meyer_et_al"
mkdir -p ${res_dir}

# Make the log directory.
log_dir="../log/meyer_et_al"
mkdir -p ${log_dir}

# Run the meyer et al. approach for each trees file.

# Define align_length.
for align_length in 200 500 1000
do

    for trees in ${trees_dir}/*/beast2_${align_length}.trees
    do

	# Get the setting from the trees file name.
	setting=`ls ${trees} | cut -d "/" -f 4`
	
	# Get the alignment length from the tree file name.
	alignment_length=`basename ${trees%.trees} | cut -d "_" -f 2`

	# Check if file is present.
	if [ ! -f ${res_dir}/${setting}/beast2_${align_length}.mrca_pairwise_means.txt ]
	then

	    # Check how many jobs running.
	    me=`whoami`
	    n_runs=`squeue -u ${me} | tail -n +2 | wc -l`
	    if (( ${n_runs} < 1000 ))
	    then
		
		# Set the log file.
		log=${log_dir}/${setting}_beast2_${alignment_length}.txt
		rm -f ${log}
		
		# Set the prefix for result files and make their directory.
		prefix=${res_dir}/${setting}/beast2_${alignment_length}
		mkdir -p ${res_dir}/${setting}
		
		# Run Meyer et al. approach.
		sbatch --account ${acct} -o ${log} run_meyer_approach.slurm ${trees} ${species_table} ${prefix}
	    fi
	fi    
    done
done

