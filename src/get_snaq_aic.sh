# michaelm Sun Apr 16 14:13:43 CEST 2023

for P2_rate in 0.25 1 4 # 0.5 2
do
    for intr_rate in 0 1e-8 1e-7 #1e-9 1e-6
    do
        for div_time in 1e7 2e7 3e7
        do
            for alignment_length in 500 #200 500 1000
            do
                sum_log_lik_diff=0
                #echo -ne "${div_time}\t${P2_rate}\t${intr_rate}\t${alignment_length}\t"
                for res in ../res/snaq_20231212/pop_size_1e5_div_time_${div_time}_rec_rate_1e-8_mut_rate_2e-9_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r*/iqtree_${alignment_length}_snaq_sum.txt #folder Snaq changed
                do
                    this_log_lik_diff=`tail -n 1 ${res} | cut -f 3`
                    echo -e "${div_time}\t${P2_rate}\t${intr_rate}\t${alignment_length}\t${this_log_lik_diff}"
                    #sum_log_lik_diff=`awk "BEGIN { print ${sum_log_lik_diff} - ${this_log_lik_diff} }"`
                done
                #avg_log_lik_diff=`echo "scale=3; ${sum_log_lik_diff} / 10" | bc`
                #echo -e "${avg_log_lik_diff}"
            done
        done
    done
done
