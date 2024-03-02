# thore Mon Jan 15 13:21:59 CET 2024

# Set the account.
acct=nn9883k

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\tdxy(P1,P2)\tdxy(P1,P3)\dxy(P2,P3)" > ../res/tables/genetic_distances.txt

# Select txt-files.
for intr_rate in 0 1e-7 1e-8
do
    for P2_rate in 0.25 1 4
    do
	for file in ../res/genetic_distances/pop_size_1e5_div_time_*_rec_rate_1e-8_mut_rate_2e-9_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r1.genetic_distances.txt
	do
	    python3 summarize_distance_matrix.py ${file} >> ../res/tables/genetic_distances.txt
	done
    done
done
	    
