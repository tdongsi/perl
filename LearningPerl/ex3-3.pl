# TAGS: InputOutput StringManipulation

chomp( @lines = <STDIN> );

@sortedLines = sort @lines;

print "The sorted lines are: @sortedLines \n";

print "The sorted lines are:\n";
foreach (@sortedLines) {
	print $_, "\n";
}