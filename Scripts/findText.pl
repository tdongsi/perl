# TAGS: StringManipulation
# Usage: perl findText.pl output.txt
# To find a line that contain some matching string.

use strict;
my $lineLimit = 10000;
my $count = 1;

# Read each line of the text file/files, given by the arguments
while ( <> )
{
	my $line = $_;
	# if ( $line =~ m/exception/i )
	if ( $line =~ m/exception/i and not ($line = m/ooLockConflictException/) )
	{
		print "Line $count:" . $line;
	}
	$count++;
	
	# # OPTIONAL: stop after some certain length
	# last if $count eq $lineLimit;
}