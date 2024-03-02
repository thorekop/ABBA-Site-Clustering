# thore Tue Sep 7 14:14:36 CEST 2021

# 1) Simulate data with msprime for different settings.
bash simulate_data.sh

# 2) Dstats with Dsuite from vcf files.
bash run_dsuite.sh

# 3) Summarize Dsuite analysis and write results into table.
bash summarize_dsuite.sh

# 4) Identify the number of replicates with significant D statistics based on the Dsuite analysis for each simulated setting.
bash get_dsuite_stats.sh 

# 5) Plot results of Dsuite analysis.
Rscript plot_dsuite_dstats.R

# 6) Inference of gene trees by using IQTREE for three different alignment lengths, and applying tree topology tests (Dtree) on these gene trees obtained.
bash run_iqtree.sh

# 7) Summarize Dtree analysis and write results into table.
bash summarize_iqtree.sh

# 8) Identify the number of replicates with significant D statistics based on the Dtree analysis for each simulated setting.
bash get_iqtree_stats.sh

# 9) Plot results of Dtree analysis.
RScript plot_iqtree.R

# 8) Run QuIBL based on gene trees already obtained by using IQTREE.
bash run_quibl.sh

# 9) Analyze and summarize QuIBL results.
bash get_quibl_stats.sh

# 10) Plot results of QuIBL analysis.
Rscript plot_quibl.R

# 11) Run SNaQ analysis based on gene trees already obtained by using IQTREE (as done for QuIBL).
bash run_snaq.sh

# 12) Summarize SNaQ analysis and write results into table.
bash summarize_snaq.sh

# 13) Analyze SNaQ results, calculate AIC values, and write them into table.
bash get_snaq_aic.sh

# 14) Run BEAST to creat BEAST trees for Meyer et al. approach.
bash run_beast2.sh

# 15) Run approach of Meyer et al. using BEAST trees.
bash run_meyer_approach.sh

# 16) Analyze and summarize Meyer et al. approach.
bash summarize_meyer_approach.sh

# 17) Plot results of Meyer et al. approach.
Rscript plot_meyer_et_al.R 

# 18) Run ABBA clustering (test for clustering of ABBA sites) implemented in Dsuite.
bash run_dsuite_ks.sh

# 19) Compress vcf files.
bash compress_vcfs.sh

# 20) Summarize the results of the ABBA clustering test.
bash summarize_abba_clustering.sh

# 21) Plot ABBA clustering results.
Rscript plot_abba_clustering.R

# 22) Repeat simulations with msprime to record mutations.
bash simulate_data2.sh

# 23) Analyze mutations to count homoplasies and reversals.
bash analyze_mutations.sh

# 24) Repeat simulations with msprime to record lengths of c-genes and single-topology tracts.
bash simulate_data3.sh

# 25) Analyze the lengths of c-genes and single-topology tracts.
bash calculate_mean_tracts.sh

# 26) Repeat some simulations with msprime to test the effect of recombination-rate variation on the ABBA clustering test.
bash simulate_data4.sh

# 27) Run ABBA clustering test for simulations with recombination-rate variation.
bash run_dsuite_ks_rec_rate_var.sh

# 28) Summarize ABBA Clustering results with recombination-rate variation.
bash summarize_abba_clustering_rec_rate_var.sh

# 29) Plot ABBA Clustering results with recombination-rate variation.
Rscript plot_abba_clustering_rec_rate_var.R

# 30) Simulate data with ILS using msprime.
bash simulate_data_ils.sh

# 31) Analyze the lengths of c-genes and single-topology tracts for data with ILS.
bash simulate_data_ils_tracts.sh

# 32) Simulate data with high ILS using msprime.
bash simulate_data_high_ils.sh

# 33) Analyze the lengths of c-genes and single-topology tracts for data with high ILS.
bash simulate_data_high_ils_tracts.sh

# 34) Simulate data with very high ILS using msprime.
bash simulate_data_very_high_ils.sh

# 35) Analyze the lengths of c-genes and single-topology tracts for data with very high ILS.
bash simulate_data_very_high_ils_tracts.sh

# 36) Repeat some simulations with msprime to test the effect of mutation-rate variation on the ABBA clustering test.
bash simulate_data5.sh

# 37) Summarize ABBA Clustering results with mutation-rate variation.
bash summarize_abba_clustering_mut_rate_var.sh

# 38) Summarize ABBA Clustering results with mutation-rate variation.
Rscript plot_abba_clustering_mut_rate_var.R
