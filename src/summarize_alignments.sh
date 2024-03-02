# thore Sun Mar 19 18:41:41 CET 2023

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\talignment_length\tn_variable_sites\tn_pi_sites" > ../res/tables/variable_and_pi_sites.txt

# Take file IDs.
for pop_size in 1e5 1e4
do
    for div_time in 1e7 2e7 3e7
    do
	for rec_rate in 1e-8
	do
	    for mut_rate in 1e-9 2e-9
	    do
		for intr_rate in 0 1e-6 1e-7 1e-8 1e-9
		do
		    for P2_rate in 0.25 4 1 2 0.5
		    do
			for file in ../res/alignments/pop_size_${pop_size}_div_time_${div_time}_rec_rate_${rec_rate}_mut_rate_${mut_rate}_intr_rate_${intr_rate}_P2_rate_${P2_rate}*_variable_and_pi_sites.txt
			do
			    run=`echo ${file} | cut -d "_" -f 19`
			    alignment_length=`echo ${file} | cut -d "_" -f 20`
			    n_variable_sites=`cat ${file} | cut -f 8`
			    n_pi_sites=`cat ${file} | cut -f 9`
			    echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${alignment_length%.txt}\t${n_variable_sites}\t${n_pi_sites}" >> ../res/tables/variable_and_pi_sites.txt
			done
		    done
		done
	    done
	done
    done
done

