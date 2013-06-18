#!/user/bin/perl
# TAGS: StringManipulation

while (<>)
{
	if ( /(\s)$/ )
	{
		print "Matched: |$`<$&>$'|\n";
	} else {
		print "No match: |$_|\n";
	}
}