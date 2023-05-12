# m_matschiner Thu Jan 6 12:41:24 CET 2022

# import modules
import sys

# Get the command-line arguments.
mutations_file_name = sys.argv[1]
res_file_name = sys.argv[2]

# Define arrays to hold a collection of values.
positions = []
times = []
ancestral_states = []
branches = []
derived_states = []

# Read the mutations file line by line.
n_reversals_P1_P2_P3__P1 = 0
n_reversals_P1_P2_P3__P2 = 0
n_reversals_P1_P2_P3__P1_P2 = 0
n_reversals_P1_P2_P3__P3 = 0
n_reversals_P1_P2__P1 = 0
n_reversals_P1_P2__P2 = 0
n_homoplasies_P4__P1_P2_P3 = 0
n_homoplasies_P4__P1_P2 = 0
n_homoplasies_P4__P1 = 0
n_homoplasies_P4__P2 = 0
n_homoplasies_P4__P3 = 0
n_homoplasies_P3__P1_P2 = 0
n_homoplasies_P3__P1 = 0
n_homoplasies_P3__P2 = 0
n_homoplasies_P2__P1 = 0
n_sites_with_two_mutations = 0
n_sites_with_three_mutations = 0
n_sites_with_four_mutations = 0
n_sites_with_more_than_four_mutations = 0
line_index = 0
with open(mutations_file_name) as mutations_file:
	for line in mutations_file:
		line_index += 1
		line_ary = line.split()
		if line_ary[0] == "position":
			continue
		else:
			# Parse the line.
			pos = int(float(line_ary[0]))
			time = float(line_ary[1])
			ancestral_state = line_ary[2]
			branch = line_ary[3]
			derived_state = line_ary[4]

			if positions == [] or pos == positions[0]:
				# Add to collection.
				positions.append(pos)
				times.append(time)
				ancestral_states.append(ancestral_state)
				branches.append(branch)
				derived_states.append(derived_state)
			else:
				# Get the number of mutations at the position corresponding to the current collection.
				n_mutations_at_collection_position = len(branches)
				if n_mutations_at_collection_position == 2:
					n_sites_with_two_mutations += 1
				elif n_mutations_at_collection_position == 3:
					n_sites_with_three_mutations += 1
				elif n_mutations_at_collection_position == 4:
					n_sites_with_four_mutations += 1
				elif n_mutations_at_collection_position > 4:
					n_sites_with_more_than_four_mutations += 1

				# Sort the collection by mutation time.
				is_sorted = False
				while is_sorted == False:
					is_sorted = True
					for x in range(len(positions)-1):
						if times[x] < times[x+1]:
							pos[x], pos[x+1] = pos[x+1], pos[x]
							times[x], times[x+1] = times[x+1], times[x]
							ancestral_states[x], ancestral_states[x+1] = ancestral_states[x+1], ancestral_states[x]
							branches[x], branches[x+1] = branches[x+1], branches[x]
							derived_states[x], derived_states[x+1] = derived_states[x+1], derived_states[x]
							is_sorted = False

				# If two mutations occurred on the same branch, delete the older one.
				if len(set(branches)) < len(branches):
					keep_mutations = []
					for x in range(n_mutations_at_collection_position):
						keep_mutations.append(True)
					for x in range(0,n_mutations_at_collection_position-1):
						for y in range(x+1,n_mutations_at_collection_position):
							if branches[x] == branches[y]:
								if times[x] > times[y]:
									keep_mutations[x] = False
								else:
									print("ERROR: Unexpected mutation time!")
									sys.exit(1)
					n_mutations_popped = 0
					for x in range(n_mutations_at_collection_position):
						if keep_mutations[n_mutations_at_collection_position-x-1] == False:
							positions.pop(n_mutations_at_collection_position-x-1)
							times.pop(n_mutations_at_collection_position-x-1)
							ancestral_states.pop(n_mutations_at_collection_position-x-1)
							branches.pop(n_mutations_at_collection_position-x-1)
							derived_states.pop(n_mutations_at_collection_position-x-1)
							n_mutations_popped += 1
					n_mutations_at_collection_position -= n_mutations_popped

				# Process collection.
				for x in range(0,n_mutations_at_collection_position-1):
					for y in range(x+1,n_mutations_at_collection_position):
						if branches[x] != branches[y]:
							if branches[x] == "P2_P3":
								pass
							elif branches[y] == "P2_P3":
								pass
							elif branches[x] == "P1_P3":
								pass
							elif branches[y] == "P1_P3":
								pass
							elif derived_states[x] == derived_states[y]:
								if branches[x] == "P1_P2_P3" and branches[y] == "P1":
									n_reversals_P1_P2_P3__P1 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P2":
									n_reversals_P1_P2_P3__P2 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P3":
									n_reversals_P1_P2_P3__P3 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P4":
									n_homoplasies_P4__P1_P2_P3 += 1
								elif branches[x] == "P1" and branches[y] == "P4":
									n_homoplasies_P4__P1 += 1
								elif branches[x] == "P4" and branches[y] == "P1":
									n_homoplasies_P4__P1 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P3":
									n_homoplasies_P3__P1_P2 += 1
								elif branches[x] == "P3" and branches[y] == "P1_P2":
									n_homoplasies_P3__P1_P2 += 1
								elif branches[x] == "P4" and branches[y] == "P3":
									n_homoplasies_P4__P3 += 1
								elif branches[x] == "P3" and branches[y] == "P4":
									n_homoplasies_P4__P3 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P4":
									n_homoplasies_P4__P1_P2 += 1
								elif branches[x] == "P4" and branches[y] == "P1_P2":
									n_homoplasies_P4__P1_P2 += 1
								elif branches[x] == "P1" and branches[y] == "P3":
									n_homoplasies_P3__P1 += 1
								elif branches[x] == "P3" and branches[y] == "P1":
									n_homoplasies_P3__P1 += 1
								elif branches[x] == "P4" and branches[y] == "P2":
									n_homoplasies_P4__P2 += 1
								elif branches[x] == "P2" and branches[y] == "P4":
									n_homoplasies_P4__P2 += 1
								elif branches[x] == "P3" and branches[y] == "P2":
									n_homoplasies_P3__P2 += 1
								elif branches[x] == "P2" and branches[y] == "P3":
									n_homoplasies_P3__P2 += 1
								elif branches[x] == "P2" and branches[y] == "P1":
									n_homoplasies_P2__P1 += 1
								elif branches[x] == "P1" and branches[y] == "P2":
									n_homoplasies_P2__P1 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P4":
									n_homoplasies_P4__P1_P2_P3 += 1
								elif branches[x] == "P4" and branches[y] == "P1_P2_P3":
									n_homoplasies_P4__P1_P2_P3 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P1":
									n_reversals_P1_P2__P1 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P2":
									n_reversals_P1_P2__P2 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P1_P2":
									n_reversals_P1_P2_P3__P1_P2 += 1
								elif branches[x] == "P2" and branches[y] == "P1_P2_P3":
									n_reversals_P1_P2_P3__P2 += 1
								elif branches[x] == "P1" and branches[y] == "P1_P2_P3":
									n_reversals_P1_P2_P3__P1 += 1
								else:
									print("ERROR: Found the following unexpected data (1):")
									print(str(positions[x]) + " " + str(times[x]) + " " + ancestral_states[x] + " " + branches[x] + " " + derived_states[x])
									print(str(positions[y]) + " " + str(times[y]) + " " + ancestral_states[y] + " " + branches[y] + " " + derived_states[y])
									sys.exit(1)
							elif derived_states[x] == ancestral_states[0]:
								if branches[x] == "P1_P2_P3" and branches[y] == "P1_P2":
									n_reversals_P1_P2_P3__P1_P2 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P1":
									n_reversals_P1_P2_P3__P1 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P2":
									n_reversals_P1_P2_P3__P2 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P3":
									n_reversals_P1_P2_P3__P3 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P1":
									n_reversals_P1_P2__P1 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P2":
									n_reversals_P1_P2__P2 += 1
								elif branches[x] == "P4":
									pass
								elif branches[x] == "P1" and branches[y] == "P2":
									pass
								elif branches[x] == "P1" and branches[y] == "P3":
									pass
								elif branches[x] == "P1" and branches[y] == "P4":
									pass
								elif branches[x] == "P2" and branches[y] == "P1":
									pass
								elif branches[x] == "P2" and branches[y] == "P3":
									pass
								elif branches[x] == "P2" and branches[y] == "P4":
									pass
								elif branches[x] == "P3" and branches[y] == "P1":
									pass
								elif branches[x] == "P3" and branches[y] == "P2":
									pass
								elif branches[x] == "P3" and branches[y] == "P4":
									pass
								elif branches[x] == "P4" and branches[y] == "P1":
									pass
								elif branches[x] == "P4" and branches[y] == "P2":
									pass
								elif branches[x] == "P4" and branches[y] == "P3":
									pass
								elif branches[x] == "P1_P2" and branches[y] == "P3":
									pass
								elif branches[x] == "P1_P2" and branches[y] == "P4":
									pass
								elif branches[x] == "P3" and branches[y] == "P1_P2":
									pass
								elif branches[x] == "P4" and branches[y] == "P1_P2":
									pass
								elif branches[x] == "P1_P2_P3" and branches[y] == "P4":
									pass
								elif branches[x] == "P4" and branches[y] == "P1_P2_P3":
									pass
								else:
									print("ERROR: Found the following unexpected data (2):")
									print(str(positions[x]) + " " + str(times[x]) + " " + ancestral_states[x] + " " + branches[x] + " " + derived_states[x])
									print(str(positions[y]) + " " + str(times[y]) + " " + ancestral_states[y] + " " + branches[y] + " " + derived_states[y])
									sys.exit(1)
							elif derived_states[y] == ancestral_states[0]:
								if branches[y] == "P4":
									pass
								elif branches[x] == "P1_P2_P3" and branches[y] == "P1":
									n_reversals_P1_P2_P3__P1 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P2":
									n_reversals_P1_P2_P3__P2 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P3":
									n_reversals_P1_P2_P3__P3 += 1
								elif branches[x] == "P1_P2_P3" and branches[y] == "P1_P2":
									n_reversals_P1_P2_P3__P1_P2 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P1":
									n_reversals_P1_P2__P1 += 1
								elif branches[x] == "P1_P2" and branches[y] == "P2":
									n_reversals_P1_P2__P2 += 1
								elif branches[x] == "P1" and branches[y] == "P2":
									pass
								elif branches[x] == "P1" and branches[y] == "P3":
									pass
								elif branches[x] == "P1" and branches[y] == "P4":
									pass
								elif branches[x] == "P2" and branches[y] == "P1":
									pass
								elif branches[x] == "P2" and branches[y] == "P3":
									pass
								elif branches[x] == "P2" and branches[y] == "P4":
									pass
								elif branches[x] == "P3" and branches[y] == "P1":
									pass
								elif branches[x] == "P3" and branches[y] == "P2":
									pass
								elif branches[x] == "P3" and branches[y] == "P4":
									pass
								elif branches[x] == "P4" and branches[y] == "P1":
									pass
								elif branches[x] == "P4" and branches[y] == "P2":
									pass
								elif branches[x] == "P4" and branches[y] == "P3":
									pass
								elif branches[x] == "P1_P2" and branches[y] == "P3":
									pass
								elif branches[x] == "P1_P2" and branches[y] == "P4":
									pass
								elif branches[x] == "P3" and branches[y] == "P1_P2":
									pass
								elif branches[x] == "P4" and branches[y] == "P1_P2":
									pass
								elif branches[x] == "P1_P2_P3" and branches[y] == "P4":
									pass
								elif branches[x] == "P4" and branches[y] == "P1_P2_P3":
									pass

								else:
									print("ERROR: Found the following unexpected data (3):")
									print(str(positions[x]) + " " + str(times[x]) + " " + ancestral_states[x] + " " + branches[x] + " " + derived_states[x])
									print(str(positions[y]) + " " + str(times[y]) + " " + ancestral_states[y] + " " + branches[y] + " " + derived_states[y])
									sys.exit(1)
							else:
								alleles_at_this_site = [ancestral_states[0], derived_states[x], derived_states[y]]
								if len(set(alleles_at_this_site)) < len(alleles_at_this_site):
									if branches[x] == "P1_P2_P3" and branches[y] == "P1_P2":
										n_reversals_P1_P2_P3__P1_P2 += 1
									elif branches[x] == "P1_P2_P3" and branches[y] == "P1":
										n_reversals_P1_P2_P3__P1 += 1
									elif branches[x] == "P1_P2_P3" and branches[y] == "P2":
										n_reversals_P1_P2_P3__P2 += 1
									elif branches[x] == "P1_P2_P3" and branches[y] == "P3":
										n_reversals_P1_P2_P3__P3 += 1
									elif branches[x] == "P1_P2" and branches[y] == "P1":
										n_reversals_P1_P2__P1 += 1
									elif branches[x] == "P1_P2" and branches[y] == "P2":
										n_reversals_P1_P2__P2 += 1
									elif branches[x] == "P1" and branches[y] == "P2":
										pass
									elif branches[x] == "P1" and branches[y] == "P3":
										pass
									elif branches[x] == "P1" and branches[y] == "P4":
										pass
									elif branches[x] == "P2" and branches[y] == "P1":
										pass
									elif branches[x] == "P2" and branches[y] == "P3":
										pass
									elif branches[x] == "P2" and branches[y] == "P4":
										pass
									elif branches[x] == "P3" and branches[y] == "P1":
										pass
									elif branches[x] == "P3" and branches[y] == "P2":
										pass
									elif branches[x] == "P3" and branches[y] == "P4":
										pass
									elif branches[x] == "P4" and branches[y] == "P1":
										pass
									elif branches[x] == "P4" and branches[y] == "P2":
										pass
									elif branches[x] == "P4" and branches[y] == "P3":
										pass
									elif branches[x] == "P1_P2" and branches[y] == "P3":
										pass
									elif branches[x] == "P1_P2" and branches[y] == "P4":
										pass
									elif branches[x] == "P3" and branches[y] == "P1_P2":
										pass
									elif branches[x] == "P4" and branches[y] == "P1_P2":
										pass
									elif branches[x] == "P1_P2_P3" and branches[y] == "P4":
										pass
									elif branches[x] == "P4" and branches[y] == "P1_P2_P3":
										pass
									else:
										print("ERROR: Found the following unexpected data (4):")
										print(str(positions[x]) + " " + str(times[x]) + " " + ancestral_states[x] + " " + branches[x] + " " + derived_states[x])
										print(str(positions[y]) + " " + str(times[y]) + " " + ancestral_states[y] + " " + branches[y] + " " + derived_states[y])
										sys.exit(1)

				# Empty collection and add to it.
				positions = [pos]
				times = [time]
				ancestral_states = [ancestral_state]
				branches = [branch]
				derived_states = [derived_state]				

# Prepare the output string.
outstring = ""
outstring += "n_sites_with_two_mutations:" + str(n_sites_with_two_mutations) + "\n"
outstring += "n_sites_with_three_mutations:" + str(n_sites_with_three_mutations) + "\n"
outstring += "n_sites_with_four_mutations:" + str(n_sites_with_four_mutations) + "\n"
outstring += "n_sites_with_more_than_four_mutations:" + str(n_sites_with_more_than_four_mutations) + "\n"
outstring += "n_reversals_P1_P2_P3__P1: " + str(n_reversals_P1_P2_P3__P1) + "\n"
outstring += "n_reversals_P1_P2_P3__P2: " + str(n_reversals_P1_P2_P3__P2) + "\n"
outstring += "n_reversals_P1_P2_P3__P1_P2: " + str(n_reversals_P1_P2_P3__P1_P2) + "\n"
outstring += "n_reversals_P1_P2_P3__P3: " + str(n_reversals_P1_P2_P3__P3) + "\n"
outstring += "n_reversals_P1_P2__P1: " + str(n_reversals_P1_P2__P1) + "\n"
outstring += "n_reversals_P1_P2__P2: " + str(n_reversals_P1_P2__P2) + "\n"
outstring += "n_homoplasies_P4__P1_P2_P3: " + str(n_homoplasies_P4__P1_P2_P3) + "\n"
outstring += "n_homoplasies_P4__P1_P2: " + str(n_homoplasies_P4__P1_P2) + "\n"
outstring += "n_homoplasies_P4__P1: " + str(n_homoplasies_P4__P1) + "\n"
outstring += "n_homoplasies_P4__P2: " + str(n_homoplasies_P4__P2) + "\n"
outstring += "n_homoplasies_P4__P3: " + str(n_homoplasies_P4__P3) + "\n"
outstring += "n_homoplasies_P3__P1_P2: " + str(n_homoplasies_P3__P1_P2) + "\n"
outstring += "n_homoplasies_P3__P1: " + str(n_homoplasies_P3__P1) + "\n"
outstring += "n_homoplasies_P3__P2: " + str(n_homoplasies_P3__P2) + "\n"
outstring += "n_homoplasies_P2__P1: " + str(n_homoplasies_P2__P1) + "\n"

# Write the output file.
with open(res_file_name, "w") as res_file:
	res_file.write(outstring)
