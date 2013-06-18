# TAGS: StringManipulation

# String matching with regular expressions

# MAIN
chomp(my @lines = <> );

foreach (@lines)
{
	if ( /fred/ )
	{
		print "$_\n";
	}
}

print "\n\n 7.2 \n";

foreach (@lines)
{
	if ( /(f|F)red/ )
	{
		print "$_\n";
	}
}

print "\n\n 7.3 \n";

foreach (@lines)
{
	if ( /\./ )
	{
		print "$_\n";
	}
}

print "\n\n 7.4 \n";

foreach (@lines)
{
	if ( /[A-Z][a-z]+/ )
	{
		print "$_\n";
	}
}

print "\n\n 7.5 \n";

foreach (@lines)
{
	if ( /(\S)\1/ )
	{
		print "$_\n";
	}
}

print "\n\n 7.6 \n";

foreach (@lines)
{
	if ( /fred(.+)wilma|wilma(.+)fred/ )
	{
		print "$_\n";
	}
}