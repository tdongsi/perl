# TAGS: System

# Sort and display the environment variables

use strict;

my @k = keys %ENV;
my @v = values %ENV;

my @ks = sort @k;

my $max_length = 0;

# foreach my $key ( @ks )
# {
	# print " Env: $key \t => \t $ENV{$key}.\n";
# }

# Extra credit:
foreach my $key (@ks)
{
	if ( length $key > $max_length )
	{
		$max_length = length $key;
	}
}

foreach my $key ( @ks )
{
	# printf ("Env: %-${max_length}s => $ENV{$key}.\n", $key);
	printf ("Env: %*s => $ENV{$key}.\n", -$max_length, $key);
}

print "\n\n\n";

# # Exercise 10-3
# foreach my $key( @ks )
# {
	# if ( !$ENV{$key} )
	# {
		# printf ("Env: %*s => $ENV{$key}.\n", -$max_length, $key);
	# }
# }

my $key = 'TMP';
my $value = $ENV{$key}? $ENV{$key}: '(undefined value)';
printf ("Env: %*s => $value.\n", -$max_length, $key);