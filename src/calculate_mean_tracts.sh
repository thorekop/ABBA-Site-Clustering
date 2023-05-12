# thore Wed Jan 12 11:41:08 CET 2022

# Set the account.
acct=nn9883k

# Make folder "tables".
mkdir -p ../res/tables

# Make the log directory.
mkdir -p ../log/means_cgenes_tracts_length

# Write headerline.
echo -e "pop_size\tdiv_time\trec_rate\tmut_rate\tintr_rate\tP2_rate\trun\tmeans_c_genes_length\tmeans_tracts_length\t\tn_introgressed_tracts\tmeans_introgressed_tracts_length" > ../res/tables/means_cgenes_tracts_length.txt

# Define folder.
folder=../res/msprime

# Define log files.
log=../log/means_cgenes_tracts_length/means_cgenes_tracts_length.txt
rm -f ${log}
    
sbatch --account ${acct} -o ${log} calculate_mean_tracts.slurm ${folder}
