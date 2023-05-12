# m_matschiner Tue Mar 28 12:07:23 CEST 2023

for P2_rate in 1 # 0.25 0.5 2 4
do
    for intr_rate in 0 1e-9 1e-8 1e-7 1e-6
    do
        for div_time in 1e7 2e7 3e7
        do
            for alignment_length in 200 500 1000
            do
                echo -ne "${div_time}\t${P2_rate}\t${intr_rate}\t${alignment_length}\t"
                sum_p2_p3=0
                sum_p1_p3=0
                for res in ../res/iqtree/pop_size_1e5_div_time_${div_time}_rec_rate_1e-8_mut_rate_2e-9_intr_rate_${intr_rate}_P2_rate_${P2_rate}_r*/iqtree_${alignment_length}.txt
                do
                    this_n_p2_p3=`tail -n 1 ${res} | tr -s " " | cut -d " " -f 5`
                    this_n_p1_p3=`tail -n 1 ${res} | tr -s " " | cut -d " " -f 6`
                    sum_p2_p3=$(( ${sum_p2_p3} + ${this_n_p2_p3} ))
                    sum_p1_p3=$(( ${sum_p1_p3} + ${this_n_p1_p3} ))
                done
                avg_p2_p3=`echo "scale=3; ${sum_p2_p3} / 10" | bc`
                avg_p1_p3=`echo "scale=3; ${sum_p1_p3} / 10" | bc`
                echo -e "${avg_p2_p3}\t${avg_p1_p3}"
            done
        done
    done
done
