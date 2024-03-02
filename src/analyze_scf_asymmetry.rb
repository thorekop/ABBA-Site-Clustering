# m_matschiner Fri Feb 2 16:52:54 CET 2024

# See https://en.wikipedia.org/wiki/Binomial_coefficient
def n_choose_k(n, k)
	if k > n
		puts "ERROR: k should never be larger than n!"
		exit 1
	elsif k == 0
		return 1
	elsif k > n/2
		return n_choose_k(n, n-k)
	end
	r = 1
	1.upto(k) do |j|
		r = r * (n + 1 - j) / j
	end
	r
end

# Get the command-line arguments.
table_file_name = ARGV[0]

# Read the input file.
table_file = File.open(table_file_name, "r")
lines = table_file.readlines

# Get the numbers of sites supporting (p1,p2), (p1,p3), and (p2,p3)
p1p2 = lines[1].split[7].to_f
p1p3 = lines[1].split[8].to_f
p2p3 = lines[1].split[9].to_f

# Calculate the d statistic.
if p1p3 + p2p3 == 0
	d = 0
else
	d = (p1p3 - p2p3)/(p1p3 + p2p3)
end

# Test if the imbalance between discordant trees is greater than expected by chance.
pr = 0
n = p1p3.to_i + p2p3.to_i
k = (p2p3.to_i+1)
k.times do |i|
	pr += Math.exp(Math.log(n_choose_k(n,i)) + Math.log(0.5**i) + Math.log((1-0.5)**(n-i)))
end
pr = pr * 2 # Make the test two-tailed instead of one-tailed.
pr = 1.0 if pr > 1.0 # This is possible when both alternative topologies are equally frequent.

# Report the D-statistic and the calculated p-value.
puts "#{d}\t#{pr}"
