# TAGS: InputOutput

chomp( @numbers = <STDIN> );

@names = qw/ fred betty barney dino wilma pebbles bamm-bamm /;

foreach $number (@numbers) {
	print $names[ $number - 1], " ";
}