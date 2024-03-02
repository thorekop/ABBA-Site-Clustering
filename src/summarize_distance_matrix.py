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
import statistics

# Set up the argument parser.
parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description=textwrap.dedent('''\
      %(prog)s
    ------------------------------------------------------------
      This script reads a distance matrix for species P1, P2,
      P3, and P4, and calculates dxy for P1/P2, P1/P3, and P2/P3.

      Run e.g. with
      python3 summarize_distance_matrix.py input.txt
    '''))
parser.add_argument(
    '-v', '--version',
    action='version',
    version='%(prog)s 0.1'
    )
parser.add_argument(
    'dist',
    nargs=1,
    type=str,
    help='name of the file with the distance matrix'
    )

# Parse command-line arguments.
args = parser.parse_args()
dist_name = args.dist[0]

# Read the distance matrix.
with open(dist_name) as f:
    lines = f.read().splitlines()

# Get the distances of certain species pairs.
p1_p2_dists = []
for x in range(6,11):
	for y in range(1,6):
		p1_p2_dists.append(float(lines[y].split()[x]))
#print("dxy(P1,P2):", statistics.mean(p1_p2_dists))
p1_p3_dists = []
for x in range(11,16):
	for y in range(1,6):
		p1_p3_dists.append(float(lines[y].split()[x]))
#print("dxy(P1,P3):", statistics.mean(p1_p3_dists))
p2_p3_dists = []
for x in range(11,16):
	for y in range(6,11):
		p2_p3_dists.append(float(lines[y].split()[x]))
#print("dxy(P2,P3):", statistics.mean(p2_p3_dists))

# Write settings and dxy(P1,P2), dxy(P1,P3), dxy (P2,P3) in one line.
dist_base = dist_name.split("/")[-1]
pop_size = dist_base.split("_")[2]
div_time = dist_base.split("_")[5]
rec_rate = dist_base.split("_")[8]
mut_rate = dist_base.split("_")[11]
intr_rate = dist_base.split("_")[14]
P2_rate = dist_base.split("_")[17]
print(pop_size + "\t" + div_time + "\t" + rec_rate + "\t" + mut_rate + "\t" + intr_rate + "\t" + P2_rate + "\t" + str(statistics.mean(p1_p2_dists)) + "\t" + str(statistics.mean(p1_p3_dists)) + "\t" + str(statistics.mean(p2_p3_dists)))
