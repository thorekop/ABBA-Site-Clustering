
# thore Sun Sept 05 2021

# Load ggplot.
#library(ggplot2)

require(scales)

# Set working directory.
setwd("~/XXX") #Set working directory

# Read table 'abba_clustering.txt'.
abba_clustering <- read.delim("abba_clustering_dsuite.txt")
abba_clustering$div_time = as.factor(abba_clustering$div_time)

pop_size = 1e5; mut_rate = 1e-9
rec_rate = 1e-8; 


abba_clustering$p_value[is.na(abba_clustering$p_value)] =0.9999
abba_clustering$p_value[is.infinite(abba_clustering$p_value)] = 0.000000001




paste0("abba_clustering_dsuite_pvalue_boxplots_pop_size_",pop_size, "_mut_rate_",mut_rate, "_rec_rate_", rec_rate, ".pdf")



pdf(paste0("abba_clustering_dsuite_pvalue_boxplots_pop_size_",pop_size, "_mut_rate_",mut_rate, "_rec_rate_", rec_rate, ".pdf"), width = 8, height =8)


screenmat = matrix(c(1:25) ,5,5, byrow=T)

split.screen(c(5,5))

p2vec=rep(c(0.25,0.5,1,2,4),each=5)
intvec= rep(c(0,1e-9, 1e-8,1e-7,1e-6),5)


colbox_sig= c("deepskyblue4", "darkred", "grey40")
colbox_nonsig= c("#a3c9d6", "#d4a4a2", "#c8c8c8")
k=25




for (k in 1:25){
  
  intr_rate=intvec[k]
  P2_rate=p2vec[k]
  t = abba_clustering[(abba_clustering$pop_size==pop_size & abba_clustering$rec_rate==rec_rate & abba_clustering$mut_rate==mut_rate & abba_clustering$intr_rate==intr_rate & abba_clustering$P2_rate==P2_rate),]
  
  threshold = 0.05
  t_sig = abba_clustering[(abba_clustering$pop_size==pop_size & abba_clustering$rec_rate==rec_rate & abba_clustering$mut_rate==mut_rate & abba_clustering$intr_rate==intr_rate & abba_clustering$P2_rate==P2_rate & abba_clustering$p_value<threshold),]
  t_nonsig = abba_clustering[(abba_clustering$pop_size==pop_size & abba_clustering$rec_rate==rec_rate & abba_clustering$mut_rate==mut_rate & abba_clustering$intr_rate==intr_rate & abba_clustering$P2_rate==P2_rate & abba_clustering$p_value>=threshold),]

  screen(k)
  par(mar=c(2,2,0,0))
  plot(t_sig$div_time, log(t_sig$p_value), las=1, ylim=c(0,-50), col="white", axes=F, border=colbox_sig, boxwex=0.7, outline=F, ylab="" ,xlab="", lwd=0.5)
  if(dim(t_sig)[1] > 0) {
    points(jitter(as.numeric(t_sig$div_time),0.5), log(t_sig$p_value), col=alpha(colbox_sig[t_sig$div_time],1), pch=16, cex=0.5 )
  }
  if(dim(t_nonsig)[1] > 0) {
    points(jitter(as.numeric(t_nonsig$div_time),0.5), log(t_nonsig$p_value), col=alpha(colbox_nonsig[t_nonsig$div_time],0.6), pch=16, cex=0.5 )
  }
    
  box()
  mtext("Div-time", 1 , line=0.5, cex=0.6)
  axis(1, at=c(1:3), label=F, tck=-0.01,  cex.axis=0.5)
  mtext(levels(t$div_time), at=c(1:3), side= 1 , line=0, cex=0.4, las=1)
  
  if (k %in% screenmat[,1]) {
    axis(2, at=seq(0, -50, by=-10), label=F, las=1, tck=-0.01,  cex.axis=0.5)
    mtext(seq(0, -50, by=-10), at=seq(0, -50, by=-10), side= 2 , line=0.5, cex=0.4, las=1)
    mtext("log(p-value)", 2 , line=1, cex=0.6)
    
  } else {
      axis(2, at=seq(0, -50, by=-10), label=F, tck=-0.01,  cex.axis=0.5)}
  
  
              
}

close.screen(all.screens=T)
dev.off()           






