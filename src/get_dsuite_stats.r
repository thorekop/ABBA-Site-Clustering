# thore Mon Aug 9 11:43:26 CEST 2021

# Read table 'dsuite_FINAL.txt'.
dsuite <- read.delim("../res/tables/dsuite_FINAL.txt")

filename <- "../res/tables/dsuite_stats_FINAL.txt"
line <- paste("pop_size", "div_time", "rec_rate", "mut_rate", "intr_rate", "P2_rate", "mean_D", "stdev_D", "mean_f4", "stdev_f4", "n_significant_p_value", "n_significant_clustering_KS_A", "n_significant_clustering_KS_B", sep = '\t')
write(line, file=filename)

for (pop_size in c(1e5,1e4)){ 
    for (div_time in c(1e7,2e7,3e7)){
    	for (rec_rate in c(1e-8)){
	    for (mut_rate in c(1e-9,2e-9)){
	    	for (intr_rate in c(0,1e-7,1e-8,1e-6,1e-9)){
		    for (P2_rate in c(0.25,1,4,0.5,2)){ 

		    	# Select parameters to be included in a subset.
			t = dsuite[(dsuite$pop_size==pop_size & dsuite$div_time==div_time & dsuite$rec_rate==rec_rate & dsuite$mut_rate==mut_rate & dsuite$intr_rate==intr_rate & dsuite$P2_rate==P2_rate),]

			mean_D=mean(t$D_stat)
			stdev_D=sd(t$D_stat)
			mean_f4=mean(t$f4_ratio)
                        stdev_f4=sd(t$f4_ratio)      
			n_significant_p_value=0
			for (p in t$p_value){
			    if (p <= 0.05){
			       n_significant_p_value=n_significant_p_value+1
}}
			n_significant_clustering_KS_A=0
			for (p in t$clustering_KS_p_val1){
			    if (p <= 0.05){
			       n_significant_clustering_KS_A=n_significant_clustering_KS_A+1
}}
			n_significant_clustering_KS_B=0
                        for (p in t$clustering_KS_p_val2){
                            if (p <= 0.05){
			       n_significant_clustering_KS_B=n_significant_clustering_KS_B+1
}}

			# Write content to new file.
			line <- paste(as.character(pop_size), as.character(div_time), as.character(rec_rate), as.character(mut_rate), as.character(intr_rate), as.character(P2_rate), as.character(mean_D), as.character(stdev_D), as.character(mean_f4), as.character(stdev_f4), as.character(n_significant_p_value), as.character(n_significant_clustering_KS_A), as.character(n_significant_clustering_KS_B), sep = '\t')
			write(line, file=filename, append=TRUE)

}}}}}}


