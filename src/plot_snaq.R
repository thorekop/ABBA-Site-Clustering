
# thore Sun Sept 05 2021

# Load ggplot.
#library(ggplot2)

require(scales)

# Set working directory.
setwd("~/XXX") # set working directory

# Read table 'snaq.txt'.
snaq <- read.delim("snaq.txt")
snaq$div_time = as.factor(snaq$div_time)
snaq$loglik_dif = (-1)*snaq$loglik_dif
snaq$dAIC = 2*snaq$loglik_dif-2
ymin = min(snaq$dAIC)


pop_size = 1e5; mut_rate = 2e-9
rec_rate = 1e-8; align_length = 500


paste0("snaq_boxplots_pop_size_",pop_size, "_mut_rate_",mut_rate, "_rec_rate_", rec_rate, "_align_length_", align_length, "TEST.pdf")



pdf(paste0("snaq_boxplots_pop_size_",pop_size, "_mut_rate_",mut_rate, "_rec_rate_", rec_rate, "_align_length_", align_length, "TEST.pdf"), width = 8, height =8)

screenmat = matrix(c(1:25) ,5,5, byrow=T)

split.screen(c(5,5))

p2vec=rep(c(0.25,0.5,1,2,4),each=5)
intvec= rep(c(0,1e-9, 1e-8,1e-7,1e-6),5)


colbox_sig= c("deepskyblue4", "darkred", "grey40")
colbox_nonsig= c("#a3c9d6", "#d4a4a2", "#c8c8c8")
k=6
for (k in 1:25){
  
  intr_rate=intvec[k]
  P2_rate=p2vec[k]
  t = snaq[(snaq$pop_size==pop_size & snaq$rec_rate==rec_rate & snaq$mut_rate==mut_rate & snaq$intr_rate==intr_rate & snaq$P2_rate==P2_rate & snaq$align_length==align_length),]

  threshold=10
  t_TRUE_sig = snaq[(snaq$pop_size==pop_size & snaq$rec_rate==rec_rate & snaq$mut_rate==mut_rate & snaq$intr_rate==intr_rate & snaq$P2_rate==P2_rate & snaq$align_length==align_length & snaq$topo_ok=="TRUE" & snaq$dAIC>=threshold),]
  t_TRUE_nonsig = snaq[(snaq$pop_size==pop_size & snaq$rec_rate==rec_rate & snaq$mut_rate==mut_rate & snaq$intr_rate==intr_rate & snaq$P2_rate==P2_rate & snaq$align_length==align_length & snaq$topo_ok=="TRUE" & snaq$dAIC<threshold),]
  t_FALSE = snaq[(snaq$pop_size==pop_size & snaq$rec_rate==rec_rate & snaq$mut_rate==mut_rate & snaq$intr_rate==intr_rate & snaq$P2_rate==P2_rate & snaq$align_length==align_length & snaq$topo_ok=="FALSE"),]
  
  screen(k)
  par(mar=c(2,2,0,0))
  plot(t_TRUE_sig$div_time, abs(t_TRUE_sig$dAIC), las=1, ylim=c(ymin,20), col="white", axes=F, border=colbox_sig, boxwex=0.7, outline=F, ylab="" ,xlab="", lwd=0.5)
  points(jitter(as.numeric(t_TRUE_sig$div_time),0.5), abs(t_TRUE_sig$dAIC), col=alpha(colbox_sig[t_TRUE_sig$div_time],1), pch=16, cex=0.5 )
  points(jitter(as.numeric(t_TRUE_nonsig$div_time),0.5), abs(t_TRUE_nonsig$dAIC), col=alpha(colbox_sig[t_TRUE_nonsig$div_time],0.3), pch=16, cex=0.5 )
  points(jitter(as.numeric(t_FALSE$div_time),0.5), abs(t_FALSE$dAIC), col=alpha(colbox_nonsig[t_FALSE$div_time],1), pch=3, cex=0.5 )
  
  box()
  mtext("Div-time", 1 , line=0.5, cex=0.6)
  axis(1, at=c(1:3), label=F, tck=-0.01,  cex.axis=0.5)
  mtext(levels(t$div_time), at=c(1:3), side= 1 , line=0, cex=0.4, las=1)
  
  if (k %in% screenmat[,1]) {
    axis(2, at=seq(0, 20, by=10), label=F, las=1, tck=-0.01,  cex.axis=0.5)
    mtext(seq(0, 20, by=10), at=seq(0, 20, by=10), side= 2 , line=0.5, cex=0.4, las=1)
    mtext("dAIC", 2 , line=1, cex=0.6)
    
  } else {
      axis(2, at=seq(0, 20, by=10), label=F, tck=-0.01,  cex.axis=0.5)}
  
  
              
}

close.screen(all.screens=T)
dev.off()           







