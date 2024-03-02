# thore 02 Feb 2024

# Set the account.
acct=nn9883k

# Set the log file.
log=../log/concordance_factors_summary.log
rm -f ${log}

# Run slurm script.
sbatch --account ${acct} -o ${log} summarize_concordance_factors.slurm

			    
