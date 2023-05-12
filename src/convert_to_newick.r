# Load the ape library.
library("ape")
  
# Get the command-line arguments.
args <- commandArgs(trailingOnly = TRUE)
nexus <- args[1]
nwk <- args[2]
 
# Read the file with a tree in nexus format.
tree <- read.nexus(nexus)
  
# Write a new file with a tree in newick format.
write.tree(tree, nwk)