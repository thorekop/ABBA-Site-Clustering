# thore Tue Aug 3 14:10:42 CEST 2021

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tD_stat\tp_value\tf4_ratio" > ../res/tables/dsuite.txt

# Take dsuite file IDs.
for file in ../res/dsuite/*.txt 
do
   pop_size=`echo ${file} | cut -d "_" -f 3`
   div_time=`echo ${file} | cut -d "_" -f 6`
   rec_rate=`echo ${file} | cut -d "_" -f 9`
   mut_rate=`echo ${file} | cut -d "_" -f 12`
   intr_rate=`echo ${file} | cut -d "_" -f 15`
   P2_rate=`echo ${file} | cut -d "_" -f 18`
   run=`echo ${file} | cut -d "_" -f 19`
   D_stat=`tail -n 1 ${file} | cut -f 4`
   p_value=`tail -n 1 ${file} | cut -f 6`
   f4_ratio=`tail -n 1 ${file} | cut -f 7`
   echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${D_stat}\t${p_value}\t${f4_ratio}" >> ../res/tables/dsuite.txt
done
