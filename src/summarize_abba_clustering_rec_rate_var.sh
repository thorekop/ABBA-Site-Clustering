# thore Wed Jan 5 14:11:34 CET 2022

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tp_value" > ../res/tables/abba_clustering_rec_rate_var.txt

# Take file IDs.
for file in ../res/dsuite/pop_size_*_div_time_*_rec_rate_var*_ks_rep_tree.txt
do
    pop_size=`echo ${file} | cut -d "_" -f 3`
    div_time=`echo ${file} | cut -d "_" -f 6`
    rec_rate=`echo ${file} | cut -d "_" -f 9`
    mut_rate=`echo ${file} | cut -d "_" -f 12`
    intr_rate=`echo ${file} | cut -d "_" -f 15`
    P2_rate=`echo ${file} | cut -d "_" -f 18`
    run=`echo ${file} | cut -d "_" -f 19 | cut -d "." -f 1`
    p_value=`tail -n 1 ${file} | cut -f 8`
    echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${p_value}" >> ../res/tables/abba_clustering_rec_rate_var.txt
done

