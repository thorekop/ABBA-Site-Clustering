# thore Mon Aug 30 17:09:03 CEST 2021

# Read table 'iqtree.txt'.
iqtree <- read.delim("../res/tables/iqtree.txt")

filename <- "../res/tables/iqtree_stats.txt"
line <- paste("pop_size", "div_time", "rec_rate", "mut_rate", "intr_rate", "P2_rate", "align_length", "mean_D", "stdev_D", "n_significant", sep = '\t')
write(line, file=filename)

for (pop_size in 1e5){
    for (div_time in c(1e7,2e7,3e7)){
        for (rec_rate in 1e-8){
            for (mut_rate in 2e-9){
                for (intr_rate in c(0,1e-6,1e-7,1e-8,1e-9)){
                    for (P2_rate in c(0.25,0.5,1,2,4)){
		    	for (align_length in c(200,500,1000)){

                        # Select parameters to be included in a subset.
                        t = iqtree[(iqtree$pop_size==pop_size & iqtree$div_time==div_time & iqtree$rec_rate==rec_rate & iqtree$mut_rate==mut_rate & iqtree$intr_rate==intr_rate & iqtree$P2_rate==P2_rate & iqtree$align_length==align_length),]

			mean_D=mean(abs(t$D_stat))
                        stdev_D=sd(abs(t$D_stat))
                        n_significant=0
                        for (p in t$p_value){
                            if (p <= 0.05){
                               n_significant=n_significant+1
}}

                        # Write content to new file.
                        line <- paste(as.character(pop_size), as.character(div_time), as.character(rec_rate), as.character(mut_rate), as.character(intr_rate), as.character(P2_rate), as.character(align_length), as.character(mean_D), as.character(stdev_D), as.character(n_significant), sep = '\t')
                        write(line, file=filename, append=TRUE)

}}}}}}}
