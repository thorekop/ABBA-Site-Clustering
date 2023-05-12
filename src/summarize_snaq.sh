# thore Mon Nov 15 13:49:20 CET 2021

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\talign_length\trun\tloglik_dif\ttopo_ok\tnetwork" > ../res/tables/snaq.txt

# Take iqtree file IDs.
for align_length in 200 500 1000
do
    for file in ../res/snaq/*/iqtree_${align_length}_snaq_sum.txt
    do
        pop_size=`echo ${file} | cut -d "_" -f 3`
        div_time=`echo ${file} | cut -d "_" -f 6`
        rec_rate=`echo ${file} | cut -d "_" -f 9`
        mut_rate=`echo ${file} | cut -d "_" -f 12`
        intr_rate=`echo ${file} | cut -d "_" -f 15`
        P2_rate=`echo ${file} | cut -d "_" -f 18`
        run=`echo ${file} | cut -d "_" -f 19 | cut -d "/" -f 1`
        loglik_dif=`tail -n 1 ${file} | cut -f 3`
        topo_ok=`python check_topology.py ${file}`
        echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${align_length}\t${run}\t${loglik_dif}\t${topo_ok}" >> ../res/tables/snaq.txt
    done
done
