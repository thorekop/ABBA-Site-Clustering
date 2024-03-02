# thore Mon Feb 13 16:16:55 CET 2023

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tnumber_of_SNPs\tnumber_of_multiallelic_sites\tnumber_of_biallelic_sites" > ../res/tables/vcf_stats.txt

# Take bcftools file IDs.
for file in ../res/bcftools/*.txt
do
   pop_size=`echo ${file} | cut -d "_" -f 3`
   div_time=`echo ${file} | cut -d "_" -f 6`
   rec_rate=`echo ${file} | cut -d "_" -f 9`
   mut_rate=`echo ${file} | cut -d "_" -f 12`
   intr_rate=`echo ${file} | cut -d "_" -f 15`
   P2_rate=`echo ${file} | cut -d "_" -f 18`
   run=`echo ${file} | cut -d "_" -f 19`
   number_of_SNPs=`cat ${file} | grep 'number of SNPs:' | cut -f 4`
   number_of_multiallelic_sites=`cat ${file} | grep 'number of multiallelic sites:' | cut -f 4`
   number_of_biallelic_sites=`cat ${file} | grep 'Number of bi-allelic sites:' | cut -d " " -f 5`
   echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${run}\t${number_of_SNPs}\t${number_of_multiallelic_sites}\t${number_of_biallelic_sites}" >> ../res/tables/vcf_stats.txt
done

