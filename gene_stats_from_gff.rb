# Get the command line argument
gff_file_name = ARGV[0]

# Read in the file
gff_file = File.open(gff_file_name)
all_gff_lines = gff_file.readlines

# Make empty arrays for the information to be parsed into
gff_lines = []
outstring_genes = []
outstring_exons = []
outstring_introns = []

# Make a smaller file with just the gene and exon information
record_this_line = false
all_gff_lines.each do |l|
	record_this_line = true if l.to_s.split[2] == "gene"
	record_this_line = true if l.to_s.split[2] == "mt_gene"
	record_this_line = true if l.to_s.split[2] == "transcript"
	record_this_line = false if l.to_s.split[2] == "J_gene_segment"
	record_this_line = false if l.to_s.split[2] == "C_gene_segment"
	record_this_line = false if l.to_s.split[2] == "V_gene_segment"
	record_this_line = false if l.to_s.split[2] == "lincRNA"
	record_this_line = false if l.to_s.split[2] == "lincRNA_gene"
	record_this_line = false if l.to_s.split[2] == "miRNA"
	record_this_line = false if l.to_s.split[2] == "miRNA_gene"
	record_this_line = false if l.to_s.split[2] == "chromosome"
	record_this_line = false if l.to_s.split[2] == "NMD_transcript_variant"
	record_this_line = false if l.to_s.split[2] == "processed_pseudogene"
	record_this_line = false if l.to_s.split[2] == "processed_transcript"
	record_this_line = false if l.to_s.split[2] == "pseudogene"
	record_this_line = false if l.to_s.split[2] == "pseudogenic_transcript"
	record_this_line = false if l.to_s.split[2] == "aberrant_processed_transcript"
	record_this_line = false if l.to_s.split[2] == "RNA"
	record_this_line = false if l.to_s.split[2] == "rRNA"
	record_this_line = false if l.to_s.split[2] == "rRNA_gene"
	record_this_line = false if l.to_s.split[2] == "snoRNA"
	record_this_line = false if l.to_s.split[2] == "snoRNA_gene"
	record_this_line = false if l.to_s.split[2] == "snRNA"
	record_this_line = false if l.to_s.split[2] == "snRNA_gene"
	record_this_line = false if l.to_s.split[2] == "supercontig"
	if record_this_line == true
		if l.to_s.split[2] == "gene" or l.to_s.split[2] == "mt_gene"
			gff_lines << l
			Features = []	
			Features.push(l.to_s.split[2])
		end	
		if l.to_s.split[2] == "five_prime_UTR" or l.to_s.split[2] == "three_prime_UTR"
			Features.push(l.to_s.split[2])
		end	
		unless l.to_s.split[2]  == "exon" && (Features.last == "three_prime_UTR" or Features.last == "five_prime_UTR") && (Features[-2] == "five_prime_UTR" or Features[-2] == "three_prime_UTR") 
			if l.to_s.split[2]  == "exon"
				gff_lines << l
			end
		end
	end
end

# Find gene length of each gene, exon and intron and compute average
gff_lines.size.times do |x|	
	if gff_lines[x].split[2] == "gene" or gff_lines[x].split[2] == "mt_gene" 
		unless gff_lines[x-1].split[2] == "gene" or gff_lines[x-1].split[2] == "mt_gene"
			outstring_genes << (gff_lines[x].split[4].to_i - gff_lines[x].split[3].to_i)
		end
	elsif gff_lines[x].split[2] == "exon"
		outstring_exons << (gff_lines[x].split[4].to_i - gff_lines[x].split[3].to_i)
		unless gff_lines[x-1].split[2] == "gene" or gff_lines[x-1].split[2] == "mt_gene" 
			if gff_lines[x].split[3].to_i > gff_lines[x-1].split[3].to_i 				
				outstring_introns << (gff_lines[x].split[3].to_i - gff_lines[x-1].split[4].to_i)
			else
				outstring_introns << (gff_lines[x-1].split[3].to_i - gff_lines[x].split[4].to_i)
			end																											
		end
	end
end

# Write the output files. 
gene_output_file_name = gff_file_name.chomp(".gff") + "_gene_lengths"
gene_output_file = File.new(gene_output_file_name,"w")
gene_output_file.puts outstring_genes
gene_output_file.close

exon_output_file_name = gff_file_name.chomp(".gff") + "_exon_lengths"
exon_output_file = File.new(exon_output_file_name,"w")
exon_output_file.puts outstring_exons
exon_output_file.close

intron_output_file_name = gff_file_name.chomp(".gff") + "_intron_lengths"
intron_output_file = File.new(intron_output_file_name,"w")
intron_output_file.puts outstring_introns
intron_output_file.close

file_output_file_name = gff_file_name.chomp(".gff") + "_used_lines"
file_output_file = File.new(file_output_file_name,"w")
file_output_file.puts gff_lines
file_output_file.close

