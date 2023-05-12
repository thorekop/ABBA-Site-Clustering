# thore Thu Oct 14 14:00:02 CEST 2021

# Load module.
module load R/4.1.0-foss-2021a

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\talign_length\tintrogression_rate\tsignificant" > ../res/tables/quibl.txt
cat ../data/trees/Quibl_species_tree.nwk | tr -d "_" > tmp_species_tree.nwk
species_tree=tmp_species_tree.nwk

# Take dsuite file IDs.
for folder in ../res/quibl/*/
do
    pop_size=`echo ${folder} | cut -d "_" -f 3`
    div_time=`echo ${folder} | cut -d "_" -f 6`
    rec_rate=`echo ${folder} | cut -d "_" -f 9`
    mut_rate=`echo ${folder} | cut -d "_" -f 12`
    intr_rate=`echo ${folder} | cut -d "_" -f 15`
    P2_rate=`echo ${folder} | cut -d "_" -f 18`
    run=`echo ${folder} | cut -d "_" -f 19 | cut -d "/" -f 1`

    for file in ${folder}/quibl_results_*.txt
    do
	align_length=`basename ${file%.txt} | cut -d "_" -f 3`
	echo -ne "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${align_length}\t" >> ../res/tables/quibl.txt
	cat ${file} | sed "s/tsk_/tsk/g" | sed "s/_1/1/g" > tmp_file.txt
	Rscript get_quibl_stats.r tmp_file.txt ${species_tree} >> ../res/tables/quibl.txt
	rm tmp_file.txt
   done
done

rm tmp_species_tree.nwk
