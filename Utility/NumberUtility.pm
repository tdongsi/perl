package NumberUtility;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( randomPermutation );
					
					
					
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