
# thore Sun Sept 05 2021

# Load ggplot.
#library(ggplot2)

require(scales)

# Set working directory.
setwd("~/XXX") # set working directory

# Read table 'meyer_approach.txt'.
meyer_approach <- read.delim("meyer_approach.txt")
meyer_approach$div_time = as.factor(meyer_approach$div_time)
ymax = max(meyer_approach$mrca_reduction)
ymin = 0


pop_size = 1e5; mut_rate = 2e-9
rec_rate = 1e-8; align_length = 1000


paste0("meyer_approach_boxplots_pop_size_",pop_size, "_mut_rate_",mut_rate, "_rec_rate_", rec_rate, "_align_length_", align_length, ".pdf")



pdf(paste0("meyer_approach_boxplots_pop_size_",pop_size, "_mut_rate_",mut_rate, "_rec_rate_", rec_rate, "_align_length_", align_length, ".pdf"), width = 8, height =8)


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
  t = meyer_approach[(meyer_approach$pop_size==pop_size & meyer_approach$rec_rate==rec_rate & meyer_approach$mut_rate==mut_rate & meyer_approach$intr_rate==intr_rate & meyer_approach$P2_rate==P2_rate & meyer_approach$align_length==align_length),]

  t_TRUE = meyer_approach[(meyer_approach$pop_size==pop_size & meyer_approach$rec_rate==rec_rate & meyer_approach$mut_rate==mut_rate & meyer_approach$intr_rate==intr_rate & meyer_approach$P2_rate==P2_rate & meyer_approach$align_length==align_length & meyer_approach$topo_ok=="TRUE"),]
  t_FALSE = meyer_approach[(meyer_approach$pop_size==pop_size & meyer_approach$rec_rate==rec_rate & meyer_approach$mut_rate==mut_rate & meyer_approach$intr_rate==intr_rate & meyer_approach$P2_rate==P2_rate & meyer_approach$align_length==align_length & meyer_approach$topo_ok=="FALSE"),]
  
  screen(k)
  par(mar=c(2,2,0,0))
  plot(t_TRUE$div_time, abs(t_TRUE$mrca_reduction), las=1, ylim=c(ymin,ymax), col="white", axes=F, border=colbox_sig, boxwex=0.7, outline=F, ylab="" ,xlab="", lwd=0.5)
  points(jitter(as.numeric(t_TRUE$div_time),0.5), abs(t_TRUE$mrca_reduction), col=alpha(colbox_sig[t_TRUE$div_time],1), pch=16, cex=0.5 )
  points(jitter(as.numeric(t_FALSE$div_time),0.5), abs(t_FALSE$mrca_reduction), col=alpha(colbox_nonsig[t_FALSE$div_time],1), pch=3, cex=0.5 )
    
  box()
  mtext("Div-time", 1 , line=0.5, cex=0.6)
  axis(1, at=c(1:3), label=F, tck=-0.01,  cex.axis=0.5)
  mtext(levels(t$div_time), at=c(1:3), side= 1 , line=0, cex=0.4, las=1)
  
  if (k %in% screenmat[,1]) {
    axis(2, at=seq(0, ymax, by=1), label=F, las=1, tck=-0.01,  cex.axis=0.5)
    mtext(seq(0, ymax, by=1), at=seq(0, ymax, by=1), side= 2 , line=0.5, cex=0.4, las=1)
    mtext("mrca_reduction", 2 , line=1, cex=0.6)
    
  } else {
      axis(2, at=seq(0, ymax, by=1), label=F, tck=-0.01,  cex.axis=0.5)}
  
  
              
}

close.screen(all.screens=T)
dev.off()           







