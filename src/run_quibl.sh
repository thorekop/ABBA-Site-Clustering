# thore Tue Aug 31 14:23:27 CEST 2021

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/quibl_20231209

# Make the log directory.
mkdir -p ../log/quibl_20231209

# Prepare directories for quibl.
for dir in ../res/iqtree20231101/* ### Changed from: iqtree/*
do
    dir_base=`basename ${dir}`
    mkdir -p ../res/quibl_20231209/${dir_base}
    
    if [ ! -f ../res/quibl_20231209/${dir_base}/quibl_200.trees ]
    then
	cp ${dir}/*.trees ../res/quibl_20231209/${dir_base}
	cp ../data/settings/quibl_settings_*00.txt ../res/quibl_20231209/${dir_base}
    fi
done

# Copy slurm scripts, define log files and run Quibl.
for dir in ../res/quibl_20231209/*
do
    dir_base=`basename ${dir}`

    if [ ! -f ${dir}/run_quibl.slurm ]
    then
	cp run_quibl.slurm ${dir}
    fi

    if [ ! -f ${dir}/QuIBL.py ]
    then
	cp QuIBL.py ${dir}
    fi

    # Go into directory where quibl settings are located.
    cd ${dir}

    # Check how many jobs running.
    n_runs=`squeue -u thore | tail -n +2 | wc -l`
    if (( ${n_runs} < 676 ))
    then
	# Define log files and run Quibl.
#	if [ ! -f quibl_results_200.txt ]
#	then
#	    log=../../../log/quibl_20231209/${dir_base}_200.txt
#	    sbatch --account ${acct} -o ${log} run_quibl.slurm quibl_settings_200.txt
#	fi

	if [ ! -f quibl_results_500.txt ]
        then
	    log=../../../log/quibl_20231209/${dir_base}_500.txt
	    sbatch --account ${acct} -o ${log} run_quibl.slurm quibl_settings_500.txt
	fi

#	if [ ! -f quibl_results_1000.txt ]
#       then
#	    log=../../../log/quibl_20231209/${dir_base}_1000.txt
#	    sbatch --account ${acct} -o ${log} run_quibl.slurm quibl_settings_1000.txt
#	fi
    fi	
    # Return to src directory.
    cd -
done
