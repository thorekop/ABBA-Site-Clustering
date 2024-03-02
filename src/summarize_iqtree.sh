# thore Mon Aug 30 13:29:43 CEST 2021

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\talign_length\trun\tD_stat\tp_value" > ../res/tables/dtree_FINAL.txt

# Take iqtree file IDs.
for align_length in 200 500 1000
do
    for file in ../res/dtree_FINAL/*/iqtree_${align_length}.txt
    do
	pop_size=`echo ${file} | cut -d "_" -f 4`
	div_time=`echo ${file} | cut -d "_" -f 7`
	rec_rate=`echo ${file} | cut -d "_" -f 10`
	mut_rate=`echo ${file} | cut -d "_" -f 13`
	intr_rate=`echo ${file} | cut -d "_" -f 16`
	P2_rate=`echo ${file} | cut -d "_" -f 19`
	run=`echo ${file} | cut -d "_" -f 20 | cut -d "/" -f 1`
	D_stat=`tail -n 1 ${file} | tr -s " " | cut -d " " -f 7`
	p_value=`tail -n 1 ${file} | tr -s " " | cut -d " " -f 8`
	echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${align_length}\t${run}\t${D_stat}\t${p_value}" >> ../res/tables/dtree_FINAL.txt
    done
done
