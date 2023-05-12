# michaelm Tue Jul 19 14:51:40 CEST 2022

# Set the account.
acct=nn9883k

# Make the result directory.
mkdir -p ../res/msprime

# Make the log directory.
mkdir -p ../log/msprime

# Make a data directory.
mkdir -p ../data/maps

# Get and truncate the recombination map.
if [ ! -f ../data/maps/GRCh37_chr20_truncated.txt ]
then
    wget -O tmp.map.txt https://raw.githubusercontent.com/johnbowes/CRAFT-GP/master/source_data/genetic_map_HapMapII_GRCh37/genetic_map_GRCh37_chr20.txt
    cat tmp.map.txt | awk '$2<20000000' > ../data/maps/GRCh37_chr20_truncated.txt
    last_cm=`tail -n 1 ../data/maps/GRCh37_chr20_truncated.txt | cut -f 4`
    echo -e "chr20\t20000000\t0\t${last_cm}" >> ../data/maps/GRCh37_chr20_truncated.txt
    rm -f tmp.map.txt
fi

# Simulate data with msprime.
for r in 1 2 3 4 5 6 7 8 9 10
do
    for pop_size in 1e5 # 1e4 1e5
    do 
	for divergence_time in 1e7 2e7 3e7
	do
	    for rec_rate in var
	    do
		for mut_rate in 2e-9 # 1e-9 2e-9
		do
		    for intr_rate in 0 1e-7 # 1e-6 1e-8 1e-9
		    do
			for P2_rate in 0.25 1 4 # 0.25 0.5 1 2 4
			do
			    # echo "Population size: ${pop_size}, divergence time: ${divergence_time}, recombination rate: ${rec_rate}, mutation rate: ${mut_rate}, introgression rate: ${intr_rate}, P2 rate: ${P2_rate}."
			
			    # Set log file.
			    log=../log/msprime/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r${r}.4.log

			    # Set output file.
                            rs=../res/msprime/pop_size_${pop_size}_div_time_${divergence_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r${r}.vcf

			    # Submit slurm script.
                            if [ ! -f ${rs} ]
                            then
                                rm -f ${log}
                                sbatch --account ${acct} -o ${log} simulate_data.slurm ${rs} ${pop_size} ${divergence_time} ${rec_rate} ${mut_rate} ${intr_rate} ${P2_rate}
                            fi

			done
		    done
		done
	    done
	done
    done
done
