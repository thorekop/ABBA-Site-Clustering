# thore Tue Jan 16 14:34:10 CET 2024

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tp_value1\tp_value2" > ../res/tables/abba_clustering_very_high_ils.txt

# Take file IDs.
for file in ../res/dsuite/very_high_ils/pop_size_*_div_time_*_rec_rate_*_ks_tree.txt
do
    pop_size=`echo ${file} | cut -d "_" -f 5`
    div_time=`echo ${file} | cut -d "_" -f 8`
    rec_rate=`echo ${file} | cut -d "_" -f 11`
    mut_rate=`echo ${file} | cut -d "_" -f 14`
    intr_rate=`echo ${file} | cut -d "_" -f 17`
    P2_rate=`echo ${file} | cut -d "_" -f 20`
    run=`echo ${file} | cut -d "_" -f 21 | cut -d "." -f 1`
    p_value1=`tail -n 1 ${file} | cut -f 8`
    p_value2=`tail -n 1 ${file} | cut -f 9`
    echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${p_value1}\t${p_value2}" >> ../res/tables/abba_clustering_very_high_ils.txt
done
