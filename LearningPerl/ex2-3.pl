print "Enter the radius: ";
chomp($radius = <STDIN>);

if ( $radius > 0 )
{
	$circ = 2 * 3.14159 * $radius;
	print $circ;
} else {
	print "0";
}

