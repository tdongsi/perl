# TAGS: InputOutput

#use 5.010;

local @lastname;

sub greet
{
	my ($name) = @_;
	## Required Perl 5.10
	#state @lastname = "";
	
	if ( @lastname == 0 )
	{
		print "Hello $name! You are the first one here!\n";
	} else {
		print "Hi $name! I've seen: @lastname\n";
	}
	
	push @lastname, $name;
}

#MAIN
greet( "Fred" );
greet( "Barney" );
greet( "Cuong" );
greet( "Wilma" );