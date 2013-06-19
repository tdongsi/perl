use strict;

# use DOS command: dir /B to get the list of folders
my @Dirs = qw/
Dir1
Dir2
Dir3
/;

foreach my $dir (@Dirs)
{
	my $command = "perl Perl2CppComment.pl $dir\\Imakefile";
	print "$command\n";
	my $out = `$command`;
}