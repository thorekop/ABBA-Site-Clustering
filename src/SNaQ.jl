# thore Tue Nov 9 13:27:30 CET 2021

using PhyloNetworks

# Define command line arguments.
treefile = ARGS[1]
prefix_net0 = ARGS[2]
prefix_net1 = ARGS[3]
prefix_summary_file = ARGS[4]
summary_file = prefix_summary_file * "_sum.txt"

# Define starting tree.
startingTree = readTopology("((((tsk_0_1,tsk_5_1),tsk_10_1),tsk_15_1),tsk_20_1);")

treesCF = readTrees2CF(treefile)

# Run SNaQ for 0 and 1 hybrid node.
net0 = snaq!(startingTree, outgroup="tsk_20_1", treesCF, hmax=0, filename=prefix_net0, seed=1234)
net1 = snaq!(startingTree, outgroup="tsk_20_1", treesCF, hmax=1, filename=prefix_net1, seed=1234)

# Calculate the log likelihood difference.
loglik_diff = net1.loglik - net0.loglik

# Get the topologies.
top0 = writeTopology(net0)
top1 = writeTopology(net1)

# Prepare the output.
outstring1 = "loglik0\tloglik1\tloglik_diff\tnet0\tnet1"
outstring2 = "$(net0.loglik)\t$(net1.loglik)\t$(loglik_diff)\t$(top0)\t$(top1)"

# Write the output to file.
io = open(summary_file, "w")
println(io, outstring1)
println(io, outstring2)
close(io)
