# thore Fri May 7 16:13:12 CEST 2021

# import modules
import msprime
import sys
import re

# The Tree class.
class Tree(object):

    def __init__(self, newick_string):
        self.newick_string = newick_string
        self.edges = []

    def get_newick_string(self):
        return self.newick_string

    def parse_newick_string(self):
        working_newick_string = self.newick_string
        number_of_internal_nodes = 0
        number_of_edges = 0

        # Remove comments from the tree string.
        pattern = re.compile("\[.*?\]")
        hit = "placeholder"
        while hit != None:
            hit = pattern.search(working_newick_string)
            if hit != None:
                working_newick_string = working_newick_string.replace(hit.group(0),"")

        # Check whether a branch above the root is present, and if so, remove it.
        if working_newick_string[0:2] == "((" and working_newick_string[-1] == ")" and working_newick_string[-2] != ")":
            level = 0
            newick_string_tail_start_pos = 0
            newick_string_tail = ""
            for pos in range(len(working_newick_string)):
                if working_newick_string[pos] == "(":
                    level += 1
                if working_newick_string[pos] == ")":
                    level -= 1
                if level == 1 and pos > 1:
                    newick_string_tail_start_pos = pos
                    newick_string_tail = working_newick_string[pos+1:]
                    break
            if newick_string_tail.count(",") == 0:
                working_newick_string = working_newick_string[1:newick_string_tail_start_pos+1]

        # Parse the bifurcating part of the tree.
        if ":" in working_newick_string:
            pattern = re.compile("\(([a-zA-Z0-9_\.\-]+?):([\d\.Ee-]+?),([a-zA-Z0-9_\.\-]+?):([\d\.Ee-]+?)\)")
        else:
            print("ERROR: It appears that the tree string does not include branch lengths!")
            sys.exit(1)
        hit = "placeholder"
        while hit != None:
            hit = pattern.search(working_newick_string)
            if hit != None:
                number_of_internal_nodes += 1
                number_of_edges += 2
                internal_node_id = "internalNode" + str(number_of_internal_nodes) + "X"
                edge1 = Edge("edge" + str(number_of_edges-1) + "X")
                edge1.set_node_ids([internal_node_id, hit.group(1)])
                edge1.set_length(float(hit.group(2)))
                edge2 = Edge("edge" + str(number_of_edges) + "X")
                edge2.set_node_ids([internal_node_id, hit.group(3)])
                edge2.set_length(float(hit.group(4)))
                self.edges.append(edge1)
                self.edges.append(edge2)
                working_newick_string = working_newick_string.replace(hit.group(0), internal_node_id)

        # Make sure the remaining string includes a single node and use this node id to determine root edges.
        pattern_rooted = re.compile("^internalNode\d+X$")
        hit_rooted = pattern_rooted.search(working_newick_string)
        if hit_rooted == None:
            print('ERROR: The newick tree string could not be parsed!')
            print('The remaining unparsed part of the newick string: \"{}\"'.format(working_newick_string))
            sys.exit(1)
        else:
            root_node_id = hit_rooted.group(0)
            for edge in self.get_edges():
                if edge.get_node_ids()[0] == root_node_id:
                    edge.set_is_root_edge(True)
                else:
                    edge.set_is_root_edge(False)

    def parse_extended_newick_string(self):
        working_newick_string = self.newick_string
        number_of_internal_nodes = 0
        number_of_edges = 0

        # Check whether a branch above the root is present, and if so, remove it.
        if working_newick_string[0:2] == "((" and working_newick_string[-1] == ")" and working_newick_string[-2] != ")":
            level = 0
            newick_string_tail_start_pos = 0
            newick_string_tail = ""
            for pos in range(len(working_newick_string)):
                if working_newick_string[pos] == "(":
                    level += 1
                if working_newick_string[pos] == ")":
                    level -= 1
                if level == 1 and pos > 1:
                    newick_string_tail_start_pos = pos
                    newick_string_tail = working_newick_string[pos+1:]
                    break
            if newick_string_tail.count(",") == 0:
                working_newick_string = working_newick_string[1:newick_string_tail_start_pos+1]

        # Parse the bifurcating part of the tree.
        if ":" in working_newick_string:
            if "[" in working_newick_string:
                pattern = re.compile("\(([a-zA-Z0-9_\.\-]+?)\[\&dmv=\{([\d\.]+?)\}\]:([\d\.Ee-]+?),([a-zA-Z0-9_\.\-]+?)\[\&dmv=\{([\d\.]+?)\}\]:([\d\.Ee-]+?)\)")
            else:
                print("ERROR: It appears that the tree string does not include annotation!")
                sys.exit(1)
        else:
            print("ERROR: It appears that the tree string does not include branch lengths!")
            sys.exit(1)
        hit = "placeholder"
        while hit != None:
            hit = pattern.search(working_newick_string)
            if hit != None:
                number_of_internal_nodes += 1
                number_of_edges += 2
                internal_node_id = "internalNode" + str(number_of_internal_nodes) + "X"
                edge1 = Edge("edge" + str(number_of_edges-1) + "X")
                edge1.set_node_ids([internal_node_id, hit.group(1)])
                edge1.set_dmv(float(hit.group(2)))
                edge1.set_length(float(hit.group(3)))
                edge2 = Edge("edge" + str(number_of_edges) + "X")
                edge2.set_node_ids([internal_node_id, hit.group(4)])
                edge2.set_dmv(float(hit.group(5)))
                edge2.set_length(float(hit.group(6)))
                self.edges.append(edge1)
                self.edges.append(edge2)
                working_newick_string = working_newick_string.replace(hit.group(0), internal_node_id)

        # Make sure the remaining string includes a single node and use this node id to determine root edges.
        pattern_rooted = re.compile("^internalNode\d+X$")
        hit_rooted = pattern_rooted.search(working_newick_string)
        if hit_rooted == None:
            print('ERROR: The newick tree string could not be parsed!')
            print('The remaining unparsed part of the newick string: \"{}\"'.format(working_newick_string))
            sys.exit(1)
        else:
            root_node_id = hit_rooted.group(0)
            for edge in self.get_edges():
                if edge.get_node_ids()[0] == root_node_id:
                    edge.set_is_root_edge(True)
                else:
                    edge.set_is_root_edge(False)

    def get_edges(self):
        return self.edges

    def get_number_of_edges(self):
        return len(self.edges)

    def get_number_of_extant_edges(self):
        number_of_extant_edges = 0
        for edge in self.edges:
            if edge.get_is_extant():
                number_of_extant_edges += 1
        return number_of_extant_edges

    def set_extant_progeny_ids(self):
        for edge in self.get_edges():
            if edge.get_is_extant():
                species_id = edge.get_node_ids()[1]
                this_edge = edge
                species_id_added_to_root_edge = False
                while species_id_added_to_root_edge == False:
                    this_edge.add_extant_progeny_id(species_id)
                    if this_edge.get_is_root_edge():
                        species_id_added_to_root_edge = True
                    else:
                        for other_edge in self.get_edges():
                            if other_edge.get_node_ids()[1] == this_edge.get_node_ids()[0]:
                                parent_edge = other_edge
                                break
                    this_edge = parent_edge

    def set_times(self):
        # Get the durations between root and extant edges.
        # These should be approximately similar, if not produce a warning.
        total_edge_lengths = []
        for edge in self.get_edges():
            if edge.get_is_extant():
                total_edge_length = edge.get_length()
                if edge.get_is_root_edge():
                    total_edge_lengths.append(total_edge_length)
                else:
                    root_edge_found = False
                    this_edge = edge
                    while root_edge_found == False:
                        for other_edge in self.get_edges():
                            if other_edge.get_node_ids()[1] == this_edge.get_node_ids()[0]:
                                parent_edge = other_edge
                                break
                        if parent_edge == None:
                            print('ERROR: The parent edge for edge {} could not be found'.format(this_edge.get_id()))
                            sys.exit(1)
                        total_edge_length += parent_edge.get_length()
                        if parent_edge.get_is_root_edge():
                            root_edge_found = True
                            total_edge_lengths.append(total_edge_length)
                        else:
                            this_edge = parent_edge
        max_total_edge_length = max(total_edge_lengths)
        if max_total_edge_length - min(total_edge_lengths) > 0.1:
            print('WARNING: The tree appears not to be ultrametric. Some terminal branches will be extended so that they all end at the same time.')
            print('')
        # Extend terminal edges if necessary.
        for edge in self.get_edges():
            if edge.get_is_extant():
                total_edge_length = edge.get_length()
                if edge.get_is_root_edge():
                    edge.set_length(edge.get_length() + max_total_edge_length - total_edge_length)
                else:
                    root_edge_found = False
                    this_edge = edge
                    while root_edge_found == False:
                        for other_edge in self.get_edges():
                            if other_edge.get_node_ids()[1] == this_edge.get_node_ids()[0]:
                                parent_edge = other_edge
                                break
                        if parent_edge == None:
                            print('ERROR: The parent edge for edge {} could not be found'.format(this_edge.get_id()))
                            sys.exit(1)
                        total_edge_length += parent_edge.get_length()
                        if parent_edge.get_is_root_edge():
                            root_edge_found = True
                            edge.set_length(round(edge.get_length() + max_total_edge_length - total_edge_length,8))
                        else:
                            this_edge = parent_edge
        # First specify the edges for which the parents still need to be identified.
        for edge in self.get_edges():
            if edge.get_is_root_edge():
                edge.set_parent_needs_times(False)
            else:
                edge.set_parent_needs_times(True)
        # Set the times of all edges.
        for edge in self.get_edges():
            if edge.get_is_extant() == True:
                edge.set_termination(0.0)
                edge.set_origin(edge.get_length())
                this_edge = edge
                while this_edge.get_parent_needs_times():
                    for other_edge in self.get_edges():
                        if other_edge.get_node_ids()[1] == this_edge.get_node_ids()[0]:
                            parent_edge = other_edge
                            break
                    if parent_edge == None:
                        print('ERROR: The parent edge for edge {} could not be found'.format(this_edge.get_id()))
                        sys.exit(1)
                    parent_edge.set_termination(this_edge.get_origin())
                    parent_edge.set_origin(this_edge.get_origin() + parent_edge.get_length())
                    this_edge.set_parent_needs_times = False
                    this_edge = parent_edge

    def get_origin(self):
        for edge in self.get_edges():
            if edge.get_is_root_edge():
                return edge.get_origin()

    def info(self):
        info_string = ''
        info_string += 'Tree'.ljust(20)
        info_string += '\n'
        info_string += 'Number of edges:'.ljust(20)
        info_string += str(self.get_number_of_edges())
        info_string += '\n'
        return info_string


# The Edge class.
class Edge(object):

    def __init__(self, id):
        self.id = id
        self.node_ids = []
        self.extant_progeny_ids = []
        self.origin = None
        self.termination = None
        self.parent_needs_times = True

    def get_id(self):
        return self.id

    def set_node_ids(self, node_ids):
        self.node_ids = node_ids

    def get_node_ids(self):
        return self.node_ids

    def get_is_extant(self):
        if self.node_ids[1][0:12] == 'internalNode':
            return False
        else:
            return True

    def set_length(self, length):
        self.length = length

    def get_length(self):
        return self.length

    def set_is_root_edge(self, is_root_edge):
        self.is_root_edge = is_root_edge

    def get_is_root_edge(self):
        return self.is_root_edge

    def add_extant_progeny_id(self, extant_progeny_id):
        self.extant_progeny_ids.append(extant_progeny_id)

    def get_extant_progeny_ids(self):
        return self.extant_progeny_ids

    def set_termination(self, termination):
        self.termination = termination

    def get_termination(self):
        return self.termination

    def set_origin(self, origin):
        self.origin = origin

    def get_origin(self):
        return self.origin

    def set_parent_needs_times(self, parent_needs_times):
        self.parent_needs_times = parent_needs_times

    def get_parent_needs_times(self):
        return self.parent_needs_times

    def set_dmv(self, dmv):
        self.dmv = dmv

    def get_pop_size(self, generation_time):
        return self.dmv * (1000000/float(generation_time))

    def info(self):
        info_string = ''
        info_string += 'Edge id:'.ljust(28)
        info_string += self.id
        info_string += '\n'
        info_string += 'Edge node 1 id:'.ljust(28)
        info_string += self.node_ids[0]
        info_string += '\n'
        info_string += 'Edge node 2 id:'.ljust(28)
        info_string += self.node_ids[1]
        info_string += '\n'
        info_string += 'Edge length:'.ljust(28)
        info_string += str(self.length)
        info_string += '\n'
        if self.dmv != None:
            info_string += 'Edge dmv:'.ljust(28)
            info_string += str(self.dmv)
            info_string += '\n'            
        info_string += 'Edge origin:'.ljust(28)
        info_string += str(self.origin)
        info_string += '\n'
        info_string += 'Edge termination:'.ljust(28)
        info_string += str(self.termination)
        info_string += '\n'
        info_string += 'Edge is extant:'.ljust(28)
        info_string += str(self.get_is_extant())
        info_string += '\n'
        info_string += 'Edge is root edge:'.ljust(28)
        info_string += str(self.is_root_edge)
        info_string += '\n'
        info_string += 'Edge extant progeny ids:'.ljust(28)
        for extant_progeny_id in self.extant_progeny_ids:
            info_string += '{}, '.format(extant_progeny_id)
        info_string = info_string[:-2]
        info_string += '\n'
        # info_string += 'Edge parent needs times:'.ljust(20)
        # info_string += str(self.get_parent_needs_times())
        # info_string += '\n'
        return info_string

# get the file names and parameter values (command line arguments)
prefix = sys.argv[1]
pop_size = float(sys.argv[2])
div_time = float(sys.argv[3])
rec_rate = float(sys.argv[4])
mut_rate = float(sys.argv[5])
intr_rate = float(sys.argv[6])
P2_rate = float(sys.argv[7])
seed = int(sys.argv[8])

# calculate sampling times
if P2_rate <= 1:
    P_default_sampling_time = 0
    P2_sampling_time = div_time-(div_time*P2_rate)
else:
    P_default_sampling_time = (div_time*P2_rate)-div_time
    P2_sampling_time = 0
    
# define phylogeny and calculate rates
newick_string = "(((P1:" + str(div_time + P_default_sampling_time) + ",P2:" + str(div_time + P_default_sampling_time) + "):10000000,P3:" + str(div_time + 10000000 + P_default_sampling_time) + "):10000000,P4:" + str(div_time + 20000000 + P_default_sampling_time) + ")"

# set chromosome length
seq_length = 1e7

# define population model 
demography = msprime.Demography.from_species_tree(
    newick_string,
    time_units="gen",
    initial_size=pop_size)

# set migration rate -> introgression rate
demography.add_migration_rate_change(time=div_time+P_default_sampling_time-2500000, rate=intr_rate, source="P3", dest="P2")
demography.add_migration_rate_change(time=div_time+P_default_sampling_time-2500000, rate=intr_rate, source="P2", dest="P3")
demography.sort_events()

# simulate ancestry
ts = msprime.sim_ancestry(
    samples=[msprime.SampleSet(5, "P1", P_default_sampling_time), msprime.SampleSet(5, "P2", P2_sampling_time), msprime.SampleSet(5, "P3", P_default_sampling_time), msprime.SampleSet(5, "P4", P_default_sampling_time)],
    demography=demography,
    recombination_rate=rec_rate,
    sequence_length=seq_length,
    random_seed=seed)

# # Collect information about the trees in the tree sequence.
# tree_sequence = []
# for tree in ts.trees():
#     this_tree_to_append = []
#     this_tree_to_append.append(tree.interval[1]-tree.interval[0])
#     this_tree_to_append.append(tree.newick())
#     tree_sequence.append(this_tree_to_append)

# # Get c-gene sizes and sizes of single-topology tracts.
# c_gene_sizes = []
# tract_sizes = []
# tree_strings = []
# topology_strings = []
# for length_and_tree in tree_sequence:
#     length = int(length_and_tree[0])
#     tree_string = length_and_tree[1].rstrip(';')
#     topology_string = re.sub(r':\d+\.\d+','', tree_string)
#     c_gene_sizes.append(length)
#     tree_strings.append(tree_string)
#     topology_strings.append(topology_string)

# # Compare each tree with the one before to identify topology breakpoints.
# previous_topology_string = topology_strings[0]
# previous_topology_length = c_gene_sizes[0]
# num_topology_changes = 0
# for x in range(1, len(topology_strings)):
#     # Only parse trees if the topology strings differ.
#     if topology_strings[x] != previous_topology_string:
#         # Make sure the two trees are really different.
#         tree1 = Tree(tree_strings[x-1])
#         tree1.parse_newick_string()
#         tree1.set_extant_progeny_ids()
#         tree2 = Tree(tree_strings[x])
#         tree2.parse_newick_string()
#         tree2.set_extant_progeny_ids()
#         clades1 = []
#         for edge in tree1.get_edges():
#             extant_progeny_ids = edge.get_extant_progeny_ids()
#             extant_progeny_ids.sort()
#             if len(extant_progeny_ids) > 1:
#                 clades1.append(extant_progeny_ids)
#         clades1.sort()
#         clades2 = []
#         for edge in tree2.get_edges():
#             extant_progeny_ids = edge.get_extant_progeny_ids()
#             extant_progeny_ids.sort()
#             if len(extant_progeny_ids) > 1:
#                 clades2.append(extant_progeny_ids)
#         clades2.sort()
#         if clades1 != clades2:
#             num_topology_changes = num_topology_changes + 1
#             tract_sizes.append(previous_topology_length)
#             previous_topology_length = c_gene_sizes[x]
#         else:
#             previous_topology_length += c_gene_sizes[x]
#     else:
#         previous_topology_length += c_gene_sizes[x]
#     previous_topology_string = topology_strings[x]
# #if there have not been any topology changes, set the tract lengths to equal the lengths of the simulated chromosomes.
# if num_topology_changes == 0:
#     tract_sizes = [chr_length for x in range(n_chr_simulated)]

# # Remove the last c-gene size as it is truncated not by recombination, but by the chromosome end.
# c_gene_sizes = c_gene_sizes[:-1]

# # Get the total length of c-genes and tracts.
# c_gene_sizes_sum = sum(c_gene_sizes)
# tract_sizes_sum = sum(tract_sizes)

# # Write output files.
# c_gene_sizes_file_name = prefix + ".c_genes.txt"
# with open(c_gene_sizes_file_name, "w") as c_gene_sizes_file:
#     c_gene_sizes_file.write("c_gene_sizes\n")
#     for c_gene_size in c_gene_sizes:
#         c_gene_sizes_file.write(str(c_gene_size) + "\n")
# tract_sizes_file_name = prefix+ ".tracts.txt"
# with open(tract_sizes_file_name, "w") as tract_sizes_file:
#     tract_sizes_file.write("tract_sizes\n")
#     for tract_size in tract_sizes:
#         tract_sizes_file.write(str(tract_size) + "\n")

# Add mutations to the tree sequence.
mts = msprime.sim_mutations(
    ts,
    rate=mut_rate,
    model=msprime.HKY(kappa=2.0),
    random_seed=seed)

# Write information about the mutations to output files.
mutations_file_name = prefix+ ".mutations.txt"
with open(mutations_file_name, "w") as mutations_file:
    mutations_file.write(" ".join(["position", "time", "ancestral_state", "branch", "derived_state"]) + "\n")

    # Identify homoplasies.
    for site in mts.sites():
        if len(site.mutations) > 1:
            tree_this_site = ts.at(site.position)
            site_ancestral_state = site.ancestral_state
            mutation_times = []
            mutation_branches = []
            mutation_derived_states = []
            for mutation in site.mutations:
                mutation_times.append(mutation.time)
                sample_branches_this_mutation = []
                for sample in tree_this_site.samples(mutation.node):
                    if sample in range(0,10):
                        sample_branches_this_mutation.append("P1")
                    elif sample in range(10,20):
                        sample_branches_this_mutation.append("P2")
                    elif sample in range(20,30):
                        sample_branches_this_mutation.append("P3")
                    elif sample in range(30,40):
                        sample_branches_this_mutation.append("P4")
                branches_this_mutation = list(set(sample_branches_this_mutation))
                branches_this_mutation.sort()
                mutation_branch = "_".join(branches_this_mutation)
                mutation_branches.append(mutation_branch)
                mutation_derived_states.append(mutation.derived_state)
            for x in range(len(mutation_branches)):
                mutations_file.write(" ".join([str(site.position), str(mutation_times[x]), str(site.ancestral_state), mutation_branches[x], mutation_derived_states[x]]) + "\n")
