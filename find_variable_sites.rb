# Martin Malmstrøm - March 31st 2017

# find_variable_sites.rb reads in an alignment in 
# fasta format and counts the differences 
# between the two sequences and devide this
# on the total alignment length to determine 
# substitution rate (just need the time also)  
# Run as "ruby find_variable_sites.rb FILE.fas"

# Get the command line argument
fasta_file_name = ARGV[0]

# Read in the file
fasta_file = File.open(fasta_file_name)
fasta_lines = fasta_file.readlines

# Make empty arrays for the information to be parsed into
fasta_ids = []
fasta_seqs = []

# Look for fasta headers, record the ID, and make all sequences one-liners 
fasta_lines.each do |l|
	if l[0] == ">"
		fasta_ids << l[1..-1].strip.split(".")[1]	
		fasta_seqs << ""
	elsif l.strip != ""	
		fasta_seqs.last << l.strip.downcase
	end	
end	

# Creating new variables with value 0 for counts of the different possibilities pr site 
diffs = 0
ambigous = 0

# Convert each fasta entery to new array with each base as an element
a = fasta_seqs[0].to_s.scan /\w/
b = fasta_seqs[1].to_s.scan /\w/

b.size.times do |x|
	if a[x] != b[x]
	diffs +=1
	end
end	

a.size.times do |x|
	if b[x] == "n" || b[x] == "y" || b[x] == "r" || b[x] == "s" || b[x] == "w" || b[x] == "k" || b[x] == "m" || b[x] == "b" || b[x] == "d" || b[x] == "h" || b[x] == "v" 
	ambigous += 1	
	end
end

puts "Number of sites examined:"
puts b.size
puts "Number of corrected variable sites:"
puts (diffs-ambigous)

