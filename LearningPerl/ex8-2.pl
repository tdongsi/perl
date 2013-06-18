#!/user/bin/perl
# TAGS: StringManipulation

while (<>)
{
	chomp;
	if ( /\w*a\b/ )
	{
		print "Matched: |$`<$&>$'|\n";
	} else {
		print "No match: |$_|\n";
	}
}