# thore Mon Feb 13 16:16:55 CET 2023

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\tn_variable_sites_vcf\tn_biallelic_sites_vcf\tn_multiallelic_sites_vcf\tn_variable_sites_200bp\tn_variable_sites_500bp\tn_variable_sites_1000bp\tn_pi_sites_200bp\tn_pi_sites_500bp\tn_pi_sites_1000bp" > ../res/tables/dataset_stats.txt

# Read vcf stats table.
for pop_size in 1e5 1e4
do
    for div_time in 1e7 2e7 3e7
    do
	for rec_rate in 1e-8
	do
	    for mut_rate in 1e-9 2e-9
	    do
		for intr_rate in 0 1e-6 1e-7 1e-8 1e-9
		do
		    for P2_rate in 0.25 4 1 2 0.5
		    do
			n_variable_sites_vcf=`cat ../res/tables/vcf_stats.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6' | awk '{ sum += $8; n++ } END { if (n > 0)  print sum / n; }'`
			n_biallelic_sites_vcf=`cat ../res/tables/vcf_stats.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6' | awk '{ sum += $10; n++ } END { if (n > 0)  print sum / n; }'`
			n_multiallelic_sites_vcf=`cat ../res/tables/vcf_stats.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6' | awk '{ sum += $9; n++ } END { if (n > 0)  print sum / n; }'`
			n_variable_sites_200bp=`cat ../res/tables/variable_and_pi_sites.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6 && $8 == 200' | awk '{ sum += $9; n++ } END { if (n > 0)  print sum / n; }'`
			n_variable_sites_500bp=`cat ../res/tables/variable_and_pi_sites.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6 && $8 == 500' | awk '{ sum += $9; n++ } END { if (n > 0)  print sum / n; }'`
			n_variable_sites_1000bp=`cat ../res/tables/variable_and_pi_sites.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6 && $8 == 1000' | awk '{ sum += $9; n++ } END { if (n > 0)  print sum / n; }'`
			n_pi_sites_200bp=`cat ../res/tables/variable_and_pi_sites.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6 && $8 == 200' | awk '{ sum += $10; n++ } END { if (n > 0)  print sum / n; }'`
			n_pi_sites_500bp=`cat ../res/tables/variable_and_pi_sites.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6 && $8 == 500' | awk '{ sum += $10; n++ } END { if (n > 0)  print sum / n; }'`
			n_pi_sites_1000bp=`cat ../res/tables/variable_and_pi_sites.txt | awk -v val1="${pop_size}" -v val2="${div_time}" -v val3="${rec_rate}" -v val4="${mut_rate}" -v val5="${intr_rate}" -v val6="${P2_rate}" '$1 == val1 && $2 == val2 && $3 == val3 && $4 == val4 && $5 == val5 && $6 == val6 && $8 == 1000' | awk '{ sum += $10; n++ } END { if (n > 0)  print sum / n; }'`
			echo -e "${pop_size}\t${div_time}\t${rec_rate}\t${mut_rate}\t${intr_rate}\t${P2_rate}\t${n_variable_sites_vcf}\t${n_biallelic_sites_vcf}\t${n_multiallelic_sites_vcf}\t${n_variable_sites_200bp}\t${n_variable_sites_500bp}\t${n_variable_sites_1000bp}\t${n_pi_sites_200bp}\t${n_pi_sites_500bp}\t${n_pi_sites_1000bp}" >> ../res/tables/dataset_stats.txt	
		    done
		done
	    done
	done
    done
done

