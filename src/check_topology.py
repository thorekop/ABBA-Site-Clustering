# m_matschiner Mon Nov 15 15:49:07 CET 2021

# Import libraries.
import sys
import re

# Read the tree file.
tree_file_name = sys.argv[1]
with open(tree_file_name) as tree_file:
    lines = tree_file.readlines()

    # Remove branch lengths and introgression edges from the network.
    network = lines[1].strip().split()[4]
    network = re.sub(r",?\#H\d+:::[\d\.]+,?", "", network)
    network = re.sub(r":[\d\.]+", "", network)
    network = network.replace("(tsk_0_1)", "tsk_0_1")
    network = network.replace("(tsk_5_1)", "tsk_5_1")
    network = network.replace("(tsk_10_1)", "tsk_10_1")
    network = network.replace("(tsk_15_1)", "tsk_15_1")

    # Find the indices of all tip labels in the network string.
    tsk_0_index = network.find("tsk_0_1")
    tsk_5_index = network.find("tsk_5_1")
    tsk_10_index = network.find("tsk_10_1")
    tsk_15_index = network.find("tsk_15_1")

    # Calculate the depths (numbers of parentheses open) per char in the network string.
    depths = []
    current_depth = 0
    for char in network:
    	if char == "(":
    		current_depth = current_depth - 1
    	elif char == ")":
    		current_depth = current_depth + 1
    	depths.append(current_depth)

    # Find the depths for tip labels.
    tsk_0_depth = depths[tsk_0_index]
    tsk_5_depth = depths[tsk_5_index]
    tsk_10_depth = depths[tsk_10_index]
    tsk_15_depth = depths[tsk_15_index]

    # Check if the depths of tip labels are as expected.
    if tsk_0_depth == tsk_5_depth and tsk_10_depth > tsk_0_depth and tsk_15_depth > tsk_10_depth:
    	print("TRUE\t" + network)
    else:
    	print("FALSE\t" + network)