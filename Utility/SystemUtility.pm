package SystemUtility;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( absolutePath is_folder_empty fileExists findBootfile runCommand );


# Return the OS-compatible absolute path to a file (i.e. correct backslash/forward slash)
# INPUT:
# currentPath: the current folder, usually obtained with CWD.
# subdir: filename or directory in the current folder.
# OUTPUT: Returns the absolute path as a string
sub absolutePath
{
     my ($currentPath, $subdir) = @_;
    
     $currentPath = abs_path( $currentPath );
     my $fullPath = File::Spec->catdir($currentPath, $subdir);
     # Replace drive letter with its lower case, only applied with Windows
     $fullPath =~ s/^([A-Za-z])/lc($1)/e;
    
     return $fullPath;
}


# Check if the folder is empty
sub is_folder_empty {
    my $dirname = shift;
    opendir(my $dh, $dirname) or die "Not a directory";
    return scalar(grep { $_ ne "." && $_ ne ".." } readdir($dh)) == 0;
}

# Check if a file with the given path and file name exists
# INPUT: file name and path, including wild cards. Spaces in path not allowed, intepreted as separator of multiple file paths.
# OUTPUT: the number of such file exists, 0 if file does not exist.
sub fileExists
{
     my ($fileNameAndPath) = @_;
     my @arr = glob($fileNameAndPath);
     my $containerFileExists = scalar @arr;
     return $containerFileExists;
}


# Find the (only) file of the given type in the given directory
# USAGE: $bootfileName = findBootfile( $dir )
# INPUT:
# $dir: the given directory
# OUTPUT:
# $bootfileName: the file path if there is only one, "" if 0 or > 1 files found with .boot extension
sub findBootfile {
	my ($dir, $suffix) = @_;
	my $count    = 0;
	my $filename = "";

	opendir DH, $dir or die "Cannot open $dir: $!";
	foreach my $file ( readdir DH ) {
		if ( $file =~ m/\.$suffix$/ ) {
			$count++;
			$filename = $file;
		}
	}

	# Optional: check if it is the only file
	if ( $count == 1 ) {
		return "$dir/$filename";
	}
	else {
		return "";
	}
}


# Subroutine to simulate Windows batch call
# USAGE: ($output, $errorlevel) = runCommand( $command, $verbose, $echo);
# INPUT:
# command: the system commands to be executed
# verbose: print the output
# echo: print the command
# OUTPUT:
# output: screen output as string
# errorlevel: integer return of the system command call.
sub runCommand
{
	my($command, $verbose, $echo) = @_;
	
	if ($echo)
	{
		print "> $command\n";
	}
	
	# NOTE: the verbose option could not stop error messages from being printed out.
	# my $output = `$command`;
	my $output = `$command 2>&1`;
	my $errorlevel = $?;
	
	# Only print when there is no error
	if ( $verbose )
	{
		print "$output\n";
	}
	
	warn "\n\n\nERROR: Error executing command: $command. Returns $errorlevel\n\n\n" if $errorlevel;
	
	return ($output,$errorlevel);
}