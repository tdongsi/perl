# TAGS: InputOutput

use strict;

print "Input the lines: \n";
chomp( my @lines = <STDIN> );

print "1234567890" x 5, "\n";

foreach (@lines)
{
	printf "%20s\n", $_;
}