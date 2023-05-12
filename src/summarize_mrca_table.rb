# Michael Matschiner, 2015-11-10

# Get the command-line arguments.
table_file_name = ARGV[0]
species_ids_file_name = ARGV[1]
prefix = ARGV[2]

# Read the species list.
species_ids_file = File.open(species_ids_file_name)
species_ids_lines = species_ids_file.readlines
species_ids = []
species_ids_lines.each do |l|
	species_ids << l.strip
end

# If a summary table does not exist yet, prepare it.
summary_table = []
species_ids.size.times do |x|
	summary_table << []
	species_ids.size.times do |y|
		summary_table.last << []
	end
end

# Read the table file.
table_file = File.open(table_file_name)
table_lines = table_file.readlines
table_file.close
sets_of_gene_tree_table_lines = []
gene_tree_table_lines = []
valid_line_count = 0
table_lines.size.times do |x|
	if table_lines[x].strip != "" and table_lines[x].strip != "WARNING: ignoring environment value of R_HOME"
		valid_line_count += 1
		if table_lines[x].strip == "#ancestors" and valid_line_count > 1
			sets_of_gene_tree_table_lines << gene_tree_table_lines
			gene_tree_table_lines = [table_lines[x]]
		elsif x == table_lines.size-1
			gene_tree_table_lines << table_lines[x]
			sets_of_gene_tree_table_lines << gene_tree_table_lines
		else
			gene_tree_table_lines << table_lines[x]
		end
	end
end

# Analyse each of the 100 gene tree's mrca tables, and add the mrca times to the summary table.
sets_of_gene_tree_table_lines.each do |set_lines|
	ancestor_table_lines = []
	node_ages_table_lines = []
	in_ancestors_table = false
	in_node_ages_table = false
	set_lines.each do |l|
		if l.strip == "#ancestors"
			in_ancestors_table = true
		elsif l.strip == "#node_ages"
			in_ancestors_table = false
			in_node_ages_table = true
		elsif in_ancestors_table
			ancestor_table_lines << l
		elsif in_node_ages_table
			node_ages_table_lines << l
		end
	end
	node_ages_table_keys = node_ages_table_lines[0].split
	node_ages_table_values = node_ages_table_lines[1].split
	# column names and row names are always the same, therefore only column
	# names are considered.
	ancestor_table_species_ids = ancestor_table_lines[0].split
	# Make sure all table species ids are found in the species ids read from species.txt.
	ancestor_table_species_ids.each do |sid|
		raise "ERROR! Unknown species id: #{sid}!" unless species_ids.count(sid) == 1
	end
	if ancestor_table_lines[1..-1].size != ancestor_table_species_ids.size
		raise "ERROR! The number of table body lines does not match that of the species ids of that table!"
	end
	1.upto(ancestor_table_lines.size-1) do |y|
		line_ary = ancestor_table_lines[y].split[1..-1]
		row_num = y-1
		if line_ary.size != ancestor_table_species_ids.size
			raise "ERROR! The number of items on a table line does not match that of the species ids of that table!"
		end
		line_ary.size.times do |x|
			col_num = x
			unless col_num == row_num
				descendant_species_ids = [ancestor_table_species_ids[col_num],ancestor_table_species_ids[row_num]]
				if descendant_species_ids[0] == descendant_species_ids[1]
					raise "ERROR: Two identical species ids found as descendants!"
				end
				mrca_key = line_ary[x]
				unless node_ages_table_keys.count(mrca_key) == 1
					raise "ERROR: Ambiguous node age table key: #{mrca_key}!"
				end
				node_age = node_ages_table_values[node_ages_table_keys.index(mrca_key)].to_f
				species_ids_index1 = species_ids.index(descendant_species_ids[0])
				species_ids_index2 = species_ids.index(descendant_species_ids[1])
				summary_table[species_ids_index1][species_ids_index2] << node_age
				summary_table[species_ids_index2][species_ids_index1] << node_age
			end
		end
	end
end

# Make a reduced table containing only the mean node ages.
summary_table_means = []
species_ids.size.times do |y|
	summary_table_means << []
	species_ids.size.times do |x|
		if x == y
			summary_table_means[y][x] = 0
		else
			node_ages = summary_table[y][x]
			node_ages_sum = 0
			node_ages.each {|i| node_ages_sum += i}
			node_ages_mean = node_ages_sum/node_ages.size.to_f
			summary_table_means[y][x] = node_ages_mean
		end
	end
end			

# Print the summary table.
cell_width = 10
outstring = "".rjust(cell_width)
species_ids.size.times do |x|
	outstring << "#{species_ids[x].rjust(cell_width)}"
end
outstring << "\n"
species_ids.size.times do |y|
	outstring << "#{species_ids[y].ljust(cell_width)}"
	species_ids.size.times do |x|
		node_age_string = "%.2f" % summary_table_means[y][x]
		outstring << "#{node_age_string.rjust(cell_width)}"
	end
	outstring << "\n"
end
summary_table_means_file_name = "#{prefix}.mrca_pairwise_means.txt"
summary_table_means_file = File.open(summary_table_means_file_name,"w")
summary_table_means_file.write(outstring)
summary_table_means_file.close

# Find a species trio, for which the difference between the second-oldest and oldest divergence is greatest.
max_mrca_reductions = []
species_ids.size.times do |x|
	max_mrca_reduction = 0
	table_string = "".rjust(cell_width)
	species_ids.size.times do |y|
		table_string << "#{species_ids[y].rjust(cell_width)}"
	end
	table_string << "\n"
	species_ids.size.times do |y|
		table_string << "#{species_ids[y].ljust(cell_width)}"
		species_ids.size.times do |z|
			# mrca_reduction = -1 * [([summary_table_means[x][y],summary_table_means[x][z]].max-summary_table_means[y][z]),0].min
			if y == z
				mrca_reduction = 0
			elsif summary_table_means[x][z] > summary_table_means[x][y]
				mrca_reduction = [(summary_table_means[y][z]-summary_table_means[x][z]),0].max
			else
				mrca_reduction = 0
			end
			max_mrca_reduction = mrca_reduction if mrca_reduction > max_mrca_reduction
			mrca_reduction_string = "%.2f" % mrca_reduction
			table_string << "#{mrca_reduction_string.rjust(cell_width)}"
		end
		table_string << "\n"
	end
	table_file_name = "#{prefix}.mrca_reductions_#{species_ids[x]}.txt"
	table_file = File.open(table_file_name,"w")
	table_file.write(table_string)
	table_file.close
	puts "Wrote file #{table_file_name}."
	max_mrca_reductions << max_mrca_reduction
end

# Write a table of the maximum and overall mrca reductions per species.
table_string = ""
species_ids.size.times do |x|
	table_string << "#{species_ids[x]}\t#{max_mrca_reductions[x]}\n"
end
table_file_name = "#{prefix}.max_mrca_reductions.txt"
table_file = File.open(table_file_name,"w")
table_file.write(table_string)
table_file.close
puts "Wrote file #{table_file_name}."

# Produce two table with the maximum and sum of mrca reductions for any combination of species A and C.
table_string1 = "".ljust(cell_width)
table_string2 = "".ljust(cell_width)
table_last_line_string1 = "max".ljust(cell_width)
species_ids.size.times do |a|
	table_string1 << "#{species_ids[a].ljust(cell_width)}"
	table_string2 << "#{species_ids[a].ljust(cell_width)}"
end
table_string1 << "max".ljust(cell_width)
table_string1 << "\n"
table_string2 << "\n"
species_ids.size.times do |a|
	table_string1 << "#{species_ids[a].ljust(cell_width)}"
	table_string2 << "#{species_ids[a].ljust(cell_width)}"
	max_max_mrca_reduction_pairwise_ac = 0
	species_ids.size.times do |c|
		max_mrca_reduction_pairwise_ac = 0
		sum_mrca_reduction_pairwise_ac = 0
		species_ids.size.times do |b|
			mrca_ab_mean_age = summary_table_means[a][b]
			mrca_ac_mean_age = summary_table_means[a][c]
			mrca_bc_mean_age = summary_table_means[b][c]
			if mrca_ab_mean_age < [mrca_ac_mean_age,mrca_bc_mean_age].min
				mrca_reduction = [mrca_bc_mean_age-mrca_ac_mean_age,0].max
			else
				mrca_reduction = 0
			end
			max_mrca_reduction_pairwise_ac = mrca_reduction if mrca_reduction > max_mrca_reduction_pairwise_ac
			sum_mrca_reduction_pairwise_ac += mrca_reduction
		end
		max_mrca_reduction_pairwise_ac_string = "%.2f" % max_mrca_reduction_pairwise_ac
		max_max_mrca_reduction_pairwise_ac = max_mrca_reduction_pairwise_ac if max_max_mrca_reduction_pairwise_ac < max_mrca_reduction_pairwise_ac
		sum_mrca_reduction_pairwise_ac_string = "%.2f" % sum_mrca_reduction_pairwise_ac
		table_string1 << "#{max_mrca_reduction_pairwise_ac_string.rjust(cell_width)}"
		table_string2 << "#{sum_mrca_reduction_pairwise_ac_string.rjust(cell_width)}"
	end
	max_max_mrca_reduction_pairwise_ac_string = "%.2f" % max_max_mrca_reduction_pairwise_ac
	table_string1 << "#{max_max_mrca_reduction_pairwise_ac_string.rjust(cell_width)}"
	table_last_line_string1 << "#{max_max_mrca_reduction_pairwise_ac_string.rjust(cell_width)}"
	table_string1 << "\n"
	table_string2 << "\n"
end
table_last_line_string1 << "0.00".ljust(cell_width)
table_last_line_string1 << "\n"
table_string1 << table_last_line_string1

# Write the table the maximum mrca reductions for any combination of species A and C.
table_file_name1 = "#{prefix}.mrca_reductions_all_max.txt"
table_file_name2 = "#{prefix}.mrca_reductions_all_sum.txt"
table_file1 = File.open(table_file_name1,"w")
table_file2 = File.open(table_file_name2,"w")
table_file1.write(table_string1)
table_file2.write(table_string2)
table_file1.close
table_file2.close
puts "Wrote file #{table_file_name1}."
puts "Wrote file #{table_file_name2}."
