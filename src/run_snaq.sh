# thore Tue Nov 9 14:36:42 CET 2021

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/snaq_20231212

# Make the log directory.
mkdir -p ../log/snaq_20231212

# Copy trees-files and add additional outgroup to obtain a > 4 taxon phylogeny.
for tree in ../res/quibl_20231209/*/*500.trees ###changed from *.trees to *500.trees
do
    tree_id1=`echo ${tree} | cut -d "/" -f 4`
    tree_id2=`echo ${tree} | cut -d "/" -f 5`
    prefix=../res/snaq_20231212/${tree_id1}/${tree_id2%.trees}_snaq
    if [ ! -f ${prefix}_sum.txt ]
    then
	new_tree_dir=../res/snaq_20231212/${tree_id1}
	mkdir -p ${new_tree_dir}
	new_tree=../res/snaq_20231212/${tree_id1}/${tree_id2}
	cat ${tree} | tr -d ";" | awk '{print "(" $0 ",tsk_20_1:1);"}' > ${new_tree}
	
	# Define log files and run SNaQ.
	mkdir -p ../log/snaq_20231212/${tree_id1}
	log=../log/snaq_20231212/${tree_id1}/${tree_id2%.trees}.txt
	
	# Check how many jobs running.
	n_runs=`squeue -u thore | tail -n +2 | wc -l`
	if (( ${n_runs} < 1351 ))
	then
            sbatch --account ${acct} -o ${log} run_snaq.slurm ${new_tree} ${prefix}
	fi
    fi
done
    



