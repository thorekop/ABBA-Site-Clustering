# thore Sun Mar 19 18:41:41 CET 2023

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\talignment_length\tn_variable_sites" > ../res/tables/variable_sites.txt

# Take file IDs.
for file in ../res/alignments/*.txt
do
    pop_size=`echo ${file} | cut -d "_" -f 3`
    div_time=`echo ${file} | cut -d "_" -f 6`
    rec_rate=`echo ${file} | cut -d "_" -f 9`
    mut_rate=`echo ${file} | cut -d "_" -f 12`
    intr_rate=`echo ${file} | cut -d "_" -f 15`
    P2_rate=`echo ${file} | cut -d "_" -f 18`
    run=`echo ${file} | cut -d "_" -f 19`
    alignment_length=`echo ${file} | cut -d "_" -f 20`
    n_variable_sites=`cat ${file} | awk '{ total += $2 } END { print total/NR }'`
    echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${alignment_length%.txt}\t${n_variable_sites}" >> ../res/tables/variable_sites.txt
done
