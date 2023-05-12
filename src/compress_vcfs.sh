# m_matschiner Wed Aug 17 17:14:18 CEST 2022

# Set the vcf directory.
vcf_dir=../res/msprime

# Set the log file.
log=../log/misc/compress_vcfs.txt

# Set the account.
acct=nn9883k

# Compress all vcf files.
sbatch -A ${acct} -o ${log} compress_vcfs.slurm ${vcf_dir}
