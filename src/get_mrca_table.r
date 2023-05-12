

library(ape)

args <- commandArgs(trailingOnly = TRUE)

tree_file_name <- args[1]
mrca_table_file_name <- args[2]

trees <- read.tree(tree_file_name)
# mrca(trees)

options(width=1000)

for (tree in trees) {
    ancestors = mrca(tree)
    cat("\n")
    cat("#ancestors\n")
    print(ancestors)
    node_ages = branching.times(tree)
    cat("\n")
    cat("#node_ages\n")
    print(node_ages)
}
