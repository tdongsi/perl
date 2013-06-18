# TAGS: BasicMath

use strict;

sub total
{
	my $total = 0;
	foreach ( @_ )
	{
		$total += $_;
	}
	return $total;
}

sub average
{
	my $total = &total(@_);
	my $average = $total / @_;
	return $average;
}

sub above_average
{
	my $average = &average(@_);
	my @myList;
	
	foreach ( @_ )
	{
		if ( $_ > $average )
		{
			push @myList, $_;
		}
	}
	
	return @myList;
}

# MAIN
my @fred = above_average(1..10);
print "\@fred is @fred\n";
my @barney = above_average( 100, 1..10 );
print "\@barney is @barney\n";
