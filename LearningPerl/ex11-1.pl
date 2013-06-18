# TAGS: System

# Print out all the installed Perl modules
use strict;
use Module::CoreList;

my %modules = %{ $Module::CoreList::version{5.008} };

# Print all modules in the current version
# foreach my $key (keys %modules )
# {
	# print "Module $key: \n";
# }

# The key of the hash is the name of modules
# The value of the hash is the version of modules
my $key = 'Module::CoreList';
print "$modules{$key}\n";