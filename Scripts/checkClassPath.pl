use strict;

&countPaths( 'CLASSPATH' );
print "\n";
&countPaths( 'PYTHONPATH' );
print "\n";
&countPaths( 'PATH' );

sub countPaths
{
	my( $envVariable ) = @_;
	
	print "\nPaths in $envVariable.\n";
	
	my $classPaths = $ENV{$envVariable};

	my @paths = split ( /;/, $classPaths );
	my %unique_paths;
	my $count = 0;
	foreach my $path ( @paths )
	{
		$unique_paths{$path}++;
	}

	my @keys = keys %unique_paths;
	foreach my $key ( @keys )
	{
		print "$key: $unique_paths{$key} times \n";
	}
	
	# foreach my $key (@keys)
	# {
		# print "$key;";
	# }
	
}