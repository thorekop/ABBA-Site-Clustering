# m_matschiner Tue Jan 30 05:56:59 PM CET 2024

# Set the account.
acct=nn9883k

# Get a script to convert a vcf to phylip format.
script=vcf2phylip.py
if [ ! -f ${script} ]
then
    wget https://raw.githubusercontent.com/edgardomortiz/vcf2phylip/master/vcf2phylip.py
fi

# Set the result directory.
res_dir=../res/site_concordance
mkdir -p ${res_dir}

# Make the log directory.
mkdir -p ../log/site_concordance

# Identify every single vcf-file.
for pop_size in 1e5
do
    for divergence_time in 1e7 2e7 3e7
    do
	for rec_rate in 1e-8
	do
	    for mut_rate in 2e-9
	    do
		for intr_rate in 0 1e-7 1e-8
		do
		    for P2_rate in 0.25 4 1
		    do
			for gzvcf in ../res/msprime/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r*.vcf.gz
			do
			    # Get the vcf id.
			    gzvcf_id=`basename ${gzvcf%.vcf.gz}`
			    
			    # Set the prefix.
			    prefix=${res_dir}/${gzvcf_id}
			    
			    # Set the output txt-file.
			    table=${prefix}_concordance_factors.txt

			    if [ ! -f ${table} ]
			    then
				
				# Check how many jobs running.
				n_runs=`squeue -u thore | tail -n +2 | wc -l`
				if (( ${n_runs} < 1400 ))
				then
				    # Get site-concordance factors with IQ-TREE.
				    log=../log/site_concordance/${gzvcf_id}_concordance_factors.txt
				    rm -f ${log}
				    sbatch -A ${acct} -o ${log} get_concordance_factors.slurm ${gzvcf} ${script} ${table}
				fi
			    fi
			done
		    done
		done
	    done
	done
    done
done

