# m_matschiner Mon Feb 5 18:03:41 CET 2024

# Import libraries.
import sys
import numpy as np
from scipy.stats import binom

# Define method for two-sided binomial test.
def two_sided_binomial_test(x, n, p):
    """
    Perform a two-sided binomial test.
    
    Parameters:
    - x: the number of successes
    - n: the number of trials
    - p: the probability of success
    
    Returns:
    - p_value: the p-value of the test
    """
    # Calculate the p-value using the cumulative distribution function (CDF)
    p_value = min(binom.cdf(x, n, p), 1 - binom.cdf(x - 1, n, p)) * 2
    
    return p_value

# Get the file name from the command-line argument
table_file_name = sys.argv[1]

# Open the input file.
with open(table_file_name,'r') as file:
    lines = file.readlines()

    # Read the input file.
    p1p3 = int(float(lines[1].split()[8]))
    p2p3 = int(float(lines[1].split()[9]))
    x = p1p3
    n = p1p3 + p2p3
    p = 0.5
    
    # Calculate the D-statistic.
    if p1p3 + p2p3 == 0:
        d = 0
    else:
        d = (p1p3 - p2p3) / (p1p3 + p2p3)
        
    # Calculate the p-value.
    p_value = two_sided_binomial_test(x, n, p)
        
    # Report d-statistic and p-value.
    print(str(d) + "\t" + str(p_value))
