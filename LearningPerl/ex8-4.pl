#!/user/bin/perl
# TAGS: StringManipulation

use 5.010;

while (<>)
{
	chomp;
	if ( /(?<name>\w*a)\b/ )
	{
		print "Matched: |$`<$&>$'|\n";
		print "'name' contains '$+{name}'\n";
	} else {
		print "No match: |$_|\n";
	}
}