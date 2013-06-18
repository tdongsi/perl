# TAGS: InputOutput

use strict;

sub printRulerLine()
{
	for (1..5) {
		print "1234567890";
	}
	print "\n";
}

#MAIN
print "Input the lines: \n";
my @lines;

while( my $line = <STDIN> )
{
	chomp($line);
	push @lines, $line;
}

printRulerLine();
foreach my $line (@lines)
{
	printf "%20s\n", $line;
}