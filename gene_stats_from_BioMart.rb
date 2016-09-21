# Get the command line argument
BioMart_file_name = ARGV[0]

# Read in the file
in_file = File.open(BioMart_file_name)
all_lines = in_file.readlines

# Make empty arrays for the information to be parsed into
prot_ids = []
outstring_genes = []
outstring_exons = []
outstring_introns = []
introns = []
temp_start = []
temp_end = []
sorted_start = []
sorted_end = []

# Record the length of each gene 
all_lines.size.times do |x|	
 	if all_lines[x].split[1] != prot_ids.last
 		prot_ids << all_lines[x].split[1]
		outstring_genes << (all_lines[x].split[4].to_i - all_lines[x].split[3].to_i)
		outstring_exons << (all_lines[x].split[8].to_i - all_lines[x].split[7].to_i)	
	else all_lines[x].split[1] == prot_ids.last
		outstring_exons << (all_lines[x].split[8].to_i - all_lines[x].split[7].to_i)
	end
end	

## Calculate the intron sizes from the sorted exons of each protein ID
all_lines.each do |l|	
 	unless prot_ids.include? l.split[1] 
 		prot_ids << l.split[1]
	end
end

prot_ids.each do |id|
	all_lines.each do |l|
		if l.split[1] == id
			temp_start << l.split[7].to_i
			temp_end << l.split[8].to_i
		end
	end
	sorted_start = temp_start.sort
	sorted_end = temp_end.sort
	sorted_start.each_index { |i| introns[i] = sorted_start[i] - sorted_end[i-1] }
	outstring_introns << introns.drop(1)
	temp_start = []
	temp_end = []
	introns = []
end

# Write the output files. 
gene_output_file_name = BioMart_file_name + "_gene_lengths"
gene_output_file = File.new(gene_output_file_name,"w")
gene_output_file.puts outstring_genes
gene_output_file.close

exon_output_file_name = BioMart_file_name + "_exon_lengths"
exon_output_file = File.new(exon_output_file_name,"w")
exon_output_file.puts outstring_exons
exon_output_file.close

intron_output_file_name = BioMart_file_name + "_intron_lengths"
intron_output_file = File.new(intron_output_file_name,"w")
intron_output_file.puts outstring_introns
intron_output_file.close

