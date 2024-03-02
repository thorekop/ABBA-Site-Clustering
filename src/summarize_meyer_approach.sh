# thore Thu Dec 9 14:38:14 CET 2021

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\talign_length\trun\tmrca_reduction\ttopo_ok" > ../res/tables/mms17_FINAL.txt

# Take iqtree file IDs.
for align_length in 200 500 1000
do
    for file in ../res/mms17_FINAL/*/beast2_${align_length}.mrca_reductions_all_max.txt
    do
	pop_size=`echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 3`
	div_time=`echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 6`
	rec_rate=`echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 9`
	mut_rate=`echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 12`
	intr_rate=`echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 15`
	P2_rate=`echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 18`
	run=`echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 19 | cut -d "/" -f 1`
	mrca_reduction_A=`head -n 4 ${file} | tail -n 1 | tr -s " " | cut -d " " -f 3`
	mrca_reduction_B=`head -n 5 ${file} | tail -n 1 | tr -s " " | cut -d " " -f 3`
	
	if (( $(echo "${mrca_reduction_B} > ${mrca_reduction_A}" | bc -l) ))
	then
	    mrca_reduction_AB=${mrca_reduction_B}
	else
	    mrca_reduction_AB=${mrca_reduction_A}
	fi
	
	#Check if topology changed by using the .mrca_pairwise_means.txt files.
	file2=${file%.mrca_reductions_all_max.txt}.mrca_pairwise_means.txt   
	pairwise_means_1=`head -n 4 ${file2} | tail -n 1 | tr -s " " | cut -d " " -f 5`
	pairwise_means_2=`head -n 3 ${file2} | tail -n 1 | tr -s " " | cut -d " " -f 4`
	pairwise_means_3=`head -n 3 ${file2} | tail -n 1 | tr -s " " | cut -d " " -f 5`
	
	if (( $(echo "${pairwise_means_2} < ${pairwise_means_1}" | bc -l) ))
	then
	    topo_ok=FALSE
	elif (( $(echo "${pairwise_means_3} < ${pairwise_means_1}" | bc -l) ))
	then
	    topo_ok=FALSE
	else
	    topo_ok=TRUE
	fi
	
	echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${align_length}\t${run}\t${mrca_reduction_AB}\t${topo_ok}" >> ../res/tables/mms17_FINAL.txt
    done
done
