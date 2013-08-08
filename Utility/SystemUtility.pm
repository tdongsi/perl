package SystemUtility;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( absolutePath is_folder_empty fileExists fileSizes findBootfile runCommand );


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


# Get the file sizes in byte with the given path and file name (wildcards allowed)
# INPUT: file name and path, including wild cards.
# OUTPUT: array of the file sizes in bytes
sub fileSizes
{
	my ($fileNameAndPath) = @_;
	# use qq to guard against spacey file paths
	my @files = glob qq($fileNameAndPath);
	my @sizes;
	
	foreach my $i (0..$#files)
	{
		$sizes[$i] = -s $files[$i];
		# print "$files[$i]\n size: $sizes[$i]\n";
	}
	
	return @sizes;
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

# Subroutine to cleanup files extracted from a zip file
# INPUT:
# ZipFile: the name of the zip file
sub CleanUpZip
{ 
	my ($ZipFile) = @_;
	print "Deleting $ZipFile and all its associated files\n";
	
	#create temp file to store list of files in Zip
	my $ListOfFiles = "ListOfFiles.txt";
	system("unzip -l $ZipFile > $ListOfFiles");
	open(PROCESS, "$ListOfFiles")  || die "Could not find $ZipFile!: $!"; 
	my @ZipLines = <PROCESS>;
	close(PROCESS);

	foreach my $line (@ZipLines) 
	{
		# E.g. line: 374  02-02-10 11:24   Filename.h
		$line = trim($line);
		my ($length, $date, $time, $ZipFilePath) = split(/\s+/, $line);
		#delete file in zip
		if( -e "$ZipFilePath" || -d "$ZipFilePath" )
		{
			unlink($ZipFilePath);
		}
		#check current working directory for zip file if can't find it (in case user junks path with j)
		elsif ($ZipFilePath =~ /^[A-Za-z0-9_]/ )
		{
			my($ZipFileName, $ZipFileDirPath) = fileparse($ZipFilePath);
			unlink($ZipFileName);
		}
	}
	
	#cleanup actual zip and temp file after finishing processing
	unlink($ZipFile);
	unlink($ListOfFiles);
} 