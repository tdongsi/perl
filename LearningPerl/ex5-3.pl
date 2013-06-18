# TAGS: InputOutput
use strict;

sub printRulerLine()
{
	my ($inWidth) = @_;
	my $rep = $inWidth/10 + 1;
	
	for (1..5) {
		print "1234567890";
	}
	print "\n";
}

#MAIN
print "Input the width: \n";
chomp(my $width = <STDIN> );

print "Input the lines: \n";
my @lines;

while( my $line = <STDIN> )
{
	chomp($line);
	push @lines, $line;
}

&printRulerLine($width);
foreach my $line (@lines)
{
	printf "%${width}s\n", $line;
}