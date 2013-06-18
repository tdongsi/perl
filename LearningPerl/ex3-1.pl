#
# TAGS: InputOutput
chomp( @lines = <STDIN> );

@reverseList = reverse @lines;

foreach (@reverseList) {
	print $_, ".\n";
}