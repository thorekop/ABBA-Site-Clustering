# m_matschiner Wed Jan 10 18:30:01 CET 2024

# This script reads a VCF file, calculates genetic distances
# between all samples, and writes a distance matrix.


# Import libraries and make sure we're on python 3.
import sys
if sys.version_info[0] < 3:
    print('Python 3 is needed to run this script!')
    sys.exit(0)
import argparse
import textwrap
from random import randint
import copy
from pathlib import Path

# Set up the argument parser.
parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description=textwrap.dedent('''\
      %(prog)s
    ------------------------------------------------------------
      This script reads a VCF file, calculates genetic distances
      between all samples, and writes a distance matrix.

      Run e.g. with
      python3 get_distances_from_vcf.py input.vcf output.txt
    '''))
parser.add_argument(
    '-v', '--version',
    action='version',
    version='%(prog)s 0.1'
    )
parser.add_argument(
    '-l',
    nargs=1,
    type=int,
    default=[1],
    dest='genome_size',
    help='Total size of genome in bp (default: 1)'
        )
parser.add_argument(
    'vcf',
    nargs=1,
    type=str,
    help='name of the input file in VCF format'
    )
parser.add_argument(
    'dist',
    nargs=1,
    type=str,
    help='name of the output distance matrix'
    )

# Parse command-line arguments.
args = parser.parse_args()
vcf_name = args.vcf[0]
dist_name = args.dist[0]
genome_size = float(args.genome_size[0])

# Initialize the distance matrix.
dist = []

# Parse the VCF input file line by line.
pos = 0
chrom = None
ids = []
with open(vcf_name) as vcf:
	for line in vcf:
		if line[0:2] == "##":
			continue
		elif line[0:1] == "#":
			# Get the sample ids.
			for sample_id in line.split()[9:]:
				ids.append(sample_id)
			# Fill a distance matrix with 0s according to the number of samples.
			for x in range(len(ids)):
				dist_row = []
				for y in range(len(ids)):
					dist_row.append(0.0)
				dist.append(dist_row)
		else:
			pos = int(line.split()[1])
			# Skip if the current position is 0 (this can happen when the VCF is written with msprime, but not otherwise).
			if pos == 0:
				continue

			# Get the genotypes.
			genotype_strings = line.split()[9:]
			genotypes = []
			for genotype_string in genotype_strings:
				genotype = genotype_string.split(",")[0].replace("|","/").split("/")
				# Orientate genotypes if needed.
				if genotype[0] > genotype[1]:
					genotype[0], genotype[1] = genotype[1], genotype[0]
				genotypes.append(genotype)

			# Compare all genotypes with each other.
			for x in range(len(ids)):
				for y in range(x+1,len(ids)):
					assert len(genotypes[x]) == 2
					assert len(genotypes[y]) == 2
					dist_value = 0
					if genotypes[x][0] != genotypes[y][0]:
						dist_value += 0.5
					if genotypes[x][1] != genotypes[y][1]:
						dist_value += 0.5
					dist[x][y] += dist_value
					dist[y][x] += dist_value

# Prepare a distance matrix in phylip format.
dist_string = str(len(ids)) + "\n"
for x in range(len(dist)):
	dist_row = ids[x]
	for y in range(len(dist[x])):
		dist_row += "\t" + str(dist[x][y]/genome_size)
	dist_string += dist_row + "\n"

with open(dist_name,"w") as dist_file:
	dist_file.write(dist_string)
