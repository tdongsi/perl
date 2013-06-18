# TAGS: InputOutput

use strict;

my %family_name = ( "fred" => "flintstone", "barney" => "rubble", "wilma" => "flintstone" );

# MAIN
print "Input the given name:";
chomp( my $name = <STDIN> );

print "The family name is: $family_name{$name}.\n";