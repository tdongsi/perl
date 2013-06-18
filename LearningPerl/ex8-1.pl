#!/user/bin/perl
# TAGS: StringManipulation

# Pattern test program: test the patterns read from a file
while (<>)
{
	chomp;
	if ( /match/ )
	{
		print "Matched: |$`<$&>$'|\n";
	} else {
		print "No match: |$_|\n";
	}
}