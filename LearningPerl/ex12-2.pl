# TAGS: System FileManipulation

# Find the oldest file from a list of arguments for file names
use strict;

# In Windows, glob in commandline arguments such as *.pl will be taken
# literally as '*.pl' string into @ARGV
my $maxDate = -1;
my $oldestFile;
foreach my $filename (  map {glob($_)} @ARGV)
{
	my $date = -M $filename;
	if ( $date > $maxDate )
	{
		$maxDate = $date;
		$oldestFile = $filename;
	}
	print "$filename: $date\n";
}

print "The oldest file is: $oldestFile\n";


#### Example from here

	# Rename all files ".old" to ".new"
	foreach my $file ( glob "*.old" )
	{
		my $newfile = $file;
		$newfile =~ s/\.old$/.new/;
		if ( -e $newfile )
		{
			warn "Can't rename $file. $newfile exists";
		} else
		{
			if ( rename $file, $newfile )
			{
				# Success, do nothing
			} else
			{
				print "Error renaming file: $!";
			}
		}
	}


	my $dir = "/etc";
	opendir DH, $dir or die "Cannot open $dir: $!";
	foreach $file (readdir DH )
	{
		# Optional: find those that match the pattern
		next unless $file =~ m/\.pm$/; # dir *.pm
		# Optional: does not count . and ..
		next if $file eq '.' or $file eq '..';
		# Optional: skip dot file (meaning hidden)
		next if $file =~ m/^\./;
		# Optional: list files only
		next unless -f $file;
		# # Optional: list readable files only
		# next unless -f $file and -r $file;
		
		# more processing
		print "one matching file in $dir is $file\n";
		# Remember to prefix with $dir
		print "full path is : $dir/$file\n";
	}
	closedir DH;
	
	foreach my $file ( glob "*.o" )
	{
		unlink $file or warn "Failed to remove $file: $!\n";
	}