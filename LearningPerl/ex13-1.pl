# TAGS: IntputOutput System

use strict;

sub listDirectory
{
	my ($dirPath) = @_;
}

print "Enter the path: ";
my $userInput;
my $dirPath;
chomp( $userInput = <STDIN> );

print "You entered: $userInput\n";


if ( $userInput =~ m/^\s*$/ )
{
	print "Blank input\n";
	# Assign hom directory
	$dirPath = "E:\Dropbox";
} else {
	$dirPath = $userInput;
}


