# thore Fri May 7 16:13:12 CEST 2021

# import modules
import msprime
import sys

# get the file names and parameter values (command line arguments)
f_name = sys.argv[1]
pop_size = float(sys.argv[2]) # population size
div_time = float(sys.argv[3]) # divergence rate
use_rec_map = False
if sys.argv[4] == "var":
    use_rec_map = True
    # Read the recombination map.
    rec_map = msprime.RateMap.read_hapmap("../data/maps/GRCh37_chr20_truncated.txt")
else:
    rec_rate = float(sys.argv[4]) # recombination rate
mut_rate = float(sys.argv[5]) # mutation rate
intr_rate = float(sys.argv[6]) # introgression rate
P2_rate = float(sys.argv[7]) # P2 rate -> branch length variation
seed = int(sys.argv[8]) # random number

# calculate sampling times
if P2_rate <= 1:
    P_default_sampling_time = 0
    P2_sampling_time = div_time-(div_time*P2_rate)
else:
    P_default_sampling_time = (div_time*P2_rate)-div_time
    P2_sampling_time = 0
    
# define phylogeny and calculate rates
newick_string = "(((P1:" + str(div_time + P_default_sampling_time) + ",P2:" + str(div_time + P_default_sampling_time) + "):10000,P3:" + str(div_time + 10000 + P_default_sampling_time) + "):10000000,P4:" + str(div_time + 10010000 + P_default_sampling_time) + ")"

# set chromosome length
seq_length = 2e7

# define population model 
demography = msprime.Demography.from_species_tree(
    newick_string,
    time_units="gen",
    initial_size=pop_size)

# set migration rate -> introgression rate
demography.add_migration_rate_change(time=div_time+P_default_sampling_time-2500000, rate=intr_rate, source="P3", dest="P2")
demography.add_migration_rate_change(time=div_time+P_default_sampling_time-2500000, rate=intr_rate, source="P2", dest="P3")
demography.sort_events()

#print(newick_string)
#print(demography.debug())
#sys.exit(0)

# simulate ancestry
if use_rec_map:
    ts = msprime.sim_ancestry(
        samples=[msprime.SampleSet(5, "P1", P_default_sampling_time), msprime.SampleSet(5, "P2", P2_sampling_time), msprime.SampleSet(5, "P3", P_default_sampling_time), msprime.SampleSet(5, "P4", P_default_sampling_time)],
        demography=demography,
        recombination_rate=rec_map,
        random_seed=seed)
else:
    ts = msprime.sim_ancestry(
        samples=[msprime.SampleSet(5, "P1", P_default_sampling_time), msprime.SampleSet(5, "P2", P2_sampling_time), msprime.SampleSet(5, "P3", P_default_sampling_time), msprime.SampleSet(5, "P4", P_default_sampling_time)],
        demography=demography,
        recombination_rate=rec_rate,
        sequence_length=seq_length,
        random_seed=seed)

# add mutations to the tree sequence
mts = msprime.sim_mutations(
    ts,
    rate=mut_rate,
    model=msprime.HKY(kappa=2.0),
    random_seed=seed)

# write vcf file
with open(f_name, "w") as vcf_file:
    mts.write_vcf(vcf_file, contig_id="1")



