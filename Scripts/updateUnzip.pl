#!/usr/buildtools/bin/perl

# USAGE:
# perl updateUnzip.pl <fileName>

$^I = ".bak";

# This script is to find and replace the "unzip" tool call with "jar -xvf"
while ( <> )
{
	s#\Qunzip $file\E#/usr/java_home/bin/jar -xvf $file#;
	print;
}


# # This script can also be used to update a property file
# # With entries like "field.field1 = oldValue" to "field.field1 = newValue"
# while ( <> )
# {
	# s#field\.filed1 .+#field.filed1 = value1#;
	# s#field\.field2 .+#field.field2 = value2#;
	# print;
# }