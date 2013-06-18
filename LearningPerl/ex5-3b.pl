# TAGS: InputOutput

use strict;

#MAIN
print "Input the width: \n";
chomp(my $width = <STDIN> );

print "Input the lines: \n";
chomp(my @lines = <STDIN> );

print "1234567890" x ($width/10 + 1), "\n";

foreach my $line (@lines)
{
	printf "%${width}s\n", $line;
}