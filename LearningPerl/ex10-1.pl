# TAGS: BasicMath InputOutput

# Number guessing game, demo of binary guess.

use strict;

my $secretNumber = int( 1 + rand 100 );
my $debug = 0;

print "Secret number is $secretNumber\n" if $debug;

while ( 1 )
{
	print "Enter your guess: ";
	chomp( my $guess = <STDIN> );
	
	print "Input: $guess\n" if $debug;
	
	last if ( !($guess) or $guess =~ /quit/i or $guess =~ /exit/i );
	
	# Winning
	last if ($guess eq $secretNumber);
	
	if ( $guess > $secretNumber )
	{
		print "Too high \n";
	} elsif ( $guess < $secretNumber )
	{
		print "Too low \n";
	}
}

print "Game over. The number is $secretNumber.\n";