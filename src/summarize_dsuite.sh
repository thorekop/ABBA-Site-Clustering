# thore Tue Aug 3 14:10:42 CEST 2021

# Make folder "tables".
mkdir -p ../res/tables

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tD_stat\tp_value\tf4_ratio\tclustering_KS_p_val1\tclustering_KS_p_val2\tBBAA\tABBA\tBABA" > ../res/tables/dsuite_FINAL.txt

# Take dsuite file IDs.
for file in ../res/dsuite_FINAL/*ks_tree.txt 
do
   pop_size=`echo ${file} | cut -d "_" -f 4`
   div_time=`echo ${file} | cut -d "_" -f 7`
   rec_rate=`echo ${file} | cut -d "_" -f 10`
   mut_rate=`echo ${file} | cut -d "_" -f 13`
   intr_rate=`echo ${file} | cut -d "_" -f 16`
   P2_rate=`echo ${file} | cut -d "_" -f 19`
   run=`echo ${file} | cut -d "_" -f 20`
   D_stat=`tail -n 1 ${file} | cut -f 4`
   p_value=`tail -n 1 ${file} | cut -f 6`
   f4_ratio=`tail -n 1 ${file} | cut -f 7`
   p_value1=`tail -n 1 ${file} | cut -f 8`
   p_value2=`tail -n 1 ${file} | cut -f 9`
   BBAA=`tail -n 1 ${file} | cut -f 10`
   ABBA=`tail -n 1 ${file} | cut -f 11`
   BABA=`tail -n 1 ${file} | cut -f 12`
   echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${D_stat}\t${p_value}\t${f4_ratio}\t${p_value1}\t${p_value2}\t${BBAA}\t${ABBA}\t${BABA}" >> ../res/tables/dsuite_FINAL.txt
done
