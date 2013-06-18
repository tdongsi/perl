# TAGS: InputOutput

$maximum = &max( 19, 5, 3, 12, 4, 2 );
print "The maximum is: $maximum";

sub max {
	my($currMax) = shift @_;
	
	foreach (@_) {
		if ( $_ > $currMax ) {
			$currMax = $_;
		}
	}
	$currMax;
}

# Read lines from a file, defined by program argument
while ( defined($line=<>) ) {
	chomp( $line );
	print "It is $line.\n";
}

# Read lines from a file, defined by program argument
while ( <> ) {
	chomp;
	print "It is $_.\n";
}

# Print an array of strings
my @items = qw(wilma dino pebbles);
printf "The items are:\n".("%10s\n" x @items), @items;

if ( ! open LOG, ">> logfile" ) {
    die "Cannot create log file: $!";
}
