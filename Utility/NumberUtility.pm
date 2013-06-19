package NumberUtility;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( randomPermutation product sizeAoA convertDecimalToIndex convertIndexToValues randomListMerge );
					
					
# Generate a random permutation from a list
# USAGE: @perm = randomPermutation( @list );
# INPUT:
# @list: the list of items
# OUTPUT:
# @perm: a random instance of permutations from the list
sub randomPermutation
{
     my (@terms) = @_;
    
     # Go through the list, swap with random items
     foreach my $i (0..$#terms)
     {
          my $j = int ( $i + rand($#terms+1-$i) );
          ($terms[$i], $terms[$j]) = ($terms[$j], $terms[$i]);
     }
    
     return @terms;
}


# Return the product of array elements
# INPUT: an array
# OUTPUT: a scalar value
sub product
{
	my $count = 1;
	foreach my $i (@_)
	{
		$count *= $i;
	}
	return $count;
}

# Return the array of sizes for each in AoA
# INPUT: an array of references that represent the AoA
# OUTPUT: an array of sizes for corresponding arrays
sub sizeAoA
{
	my @aRef = @_;
	my @sizes;
	foreach my $i (0..$#aRef)
	{
		$sizes[$i] = scalar @{$aRef[$i]};
	}
	return @sizes;
}


# Given a decimal number and an array of max values, generate the corresponding arbitrary-base number
# 
# INPUT:
# number: input decimal number
# @maxCount: array of max values
# OUTPUT:
# @outIndex: array of digits, with the least significant digit at index 0
#
# EXAMPLE:
# if @maxCount contains all 2s, @outIndex is the binary digits with the least significant bit at index 0
# if @maxCount contains all 10s, @outIndex is the decimal digits of the input number, in the reverse order (i.e., least significant digit at 0)
sub convertDecimalToIndex
{
	my ($number, @maxCount) = @_;
	my $originalNumber = $number;
	my @outIndex;
	
	foreach my $i (0..$#maxCount)
	{
		$outIndex[$i] = $number % $maxCount[$i];
		$number = int( $number / $maxCount[$i]);
	}
	
	die "Error: Overflowed since input decimal $originalNumber is larger than maximum index @maxCount" if ($number > 0);
	return @outIndex;
}


# Given an array of index and the array of arrays, return the array of corresponding values
# INPUT
# rIndex: reference to the array of index
# rAoA: reference to array of arrays
# OUTPUT
# options: array of corresponding values, i.e. $options[$i] = $AoA[$i][$index[$i]];
sub convertIndexToValues
{
	my ($rIndex, $rAoA) = @_;
	my @index = @{$rIndex};
	my @AoA = @{$rAoA};
	my @options;
	
	foreach my $i (0..$#index)
	{
		my $j = $index[$i];
		$options[$i] = $AoA[$i][$j];
	}
	
	return @options;
}

# Merge randomly two lists into a single list
# INPUT
# $rListA: reference to list A
# $rListB: reference to list B
# OUTPUT
# @merge: the single list with elements from list A and list B in random order
sub randomListMerge
{
	my ( $rListA, $rListB ) = @_;
	my @merge;
	my @listA = @{$rListA};
	my @listB = @{$rListB};
	my $countA = 0;
	my $countB = 0;
	
	# Pick randomly elements from each list and push into the common list
	while ($countA <= $#listA && $countB <= $#listB )
	{
		if ( rand > 0.5 )
		{
			push @merge, $listA[$countA];
			$countA++;
		} else {
			push @merge, $listB[$countB];
			$countB++;
		}
	}
	
	# Push the rest into the merged list
	foreach my $i ($countB..$#listB)
	{
		push @merge, $listB[$i];
	}
	foreach my $i ($countA..$#listA)
	{
		push @merge, $listA[$i];
	}
	
	return @merge;
}