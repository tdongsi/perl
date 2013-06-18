# TAGS: StringManipulation

# Count the number of input strings and display all the unique strings

use strict;

#MAIN
my %times_seen;

# Input the names
while ( <STDIN> )
{
	chomp;
	
	$times_seen{$_}++;
}

while( my ($key,$value) = each %times_seen ) {
  print "$key appears $value times\n";
}

# Shows in ASCII order
my @k = keys %times_seen;
my @ks = sort @k;
foreach my $key (@ks)
{
	print "$key appears $times_seen{$key} times\n";
}