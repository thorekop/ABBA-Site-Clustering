# thore Thu Oct 14 14:17:49 CEST 2021

# Get the command line argumnets.
args <- commandArgs(trailingOnly = TRUE)
file <- args[1]
species_tree <- args[2]
library("quiblR")
                        
q_s_t <- read_speciesTree(species_tree)

q_out <- read_csv_quibl(file)
totalTrees <- sum(q_out$count)/length(unique(q_out$triplet))

isDiscordant = as.integer(! apply(q_out, 1, isSpeciesTree, sTree=q_s_t))
isSignificant = as.integer(apply(q_out, 1, testSignificance, threshold=10))
totalIntrogressionFractions=(q_out$mixprop2*q_out$count*isDiscordant)/totalTrees
maxTotalIntrogressionFraction=max(totalIntrogressionFractions)
max_index=match(maxTotalIntrogressionFraction,totalIntrogressionFractions)
significant=isSignificant[max_index]
cat(as.character(maxTotalIntrogressionFraction), as.character(significant), sep = '\t')
cat("\n")

