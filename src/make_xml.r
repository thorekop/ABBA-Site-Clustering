# Load the babette library.
library("babette")

# Get the command-line arguments.
args <- commandArgs(trailingOnly = TRUE)
fasta <- args[1]
xml <- args[2]
div_time <- as.numeric(args[3])

# Define a site model based on the hky model.
site_model <- create_hky_site_model()

# Create a relaxed log-normal clock model.
clock_model <- create_strict_clock_model()

# Create a birth-death tree prior.
tree_prior <- create_bd_tree_prior()

# Create calibration point.
mrca_prior <- create_mrca_prior(
	   alignment_id = get_alignment_id(fasta_filename = fasta), 
	   taxa_names = c("tsk_0_1", "tsk_5_1", "tsk_10_1", "tsk_15_1"),
	   is_monophyletic = TRUE,
	   mrca_distr = create_log_normal_distr(m = log((div_time+20000000)/1000000), s = 0.001, value = (div_time+20000000)/1000000),
	   name = "root"
)

# Specify a run length of 5,000,000 iterations.
mcmc <- create_mcmc(chain_length = 5000000)

# Make an xml file with babette.
create_beast2_input_file(fasta, xml, site_model = site_model, clock_model = clock_model, tree_prior = tree_prior, mrca_prior = mrca_prior, mcmc = mcmc)