package SystemUtility;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( absolutePath is_folder_empty fileExists fileSizes findBootfile runCommand 
	CleanUpZip fileToArray);


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

# Read text file into array of text lines.
sub fileToArray
{
	my ($filename) = @_;
	open FILE, "< $filename" or die "Cannot open file $filename: $!";
	my @lines = <FILE>;
	close FILE;
	return @lines;
}


# Filter the file. Filtering logic is defined by implementation
# INPUT:
# $beforeFile: string of input file name
# $afterFile: string of output file name, after filtering
# OUTPUT:
# No output. If success, a new file is created with filtered content, named as specified.
sub filterFile
{
	my ($beforeFile, $afterFile) = @_;
	
	open INFILE, "<", $beforeFile or die "Cannot open $beforeFile: $!";
	my @lines = <INFILE>;
	close INFILE;
	
	# print "DEBUG: Number of lines -1: $#lines\n";
	
	open OUTFILE, ">", $afterFile or die "Cannot open $afterFile: $!";
	
	foreach my $line (@lines)
	{
		print OUTFILE $line unless 
		# Add filtering logic to HERE
		# Any line that satisfies the conditions will be ignored
		# These are examples
			($line =~ m/#size = .+/ or
			$line =~ m/#hashValue = .+/);
	}
	
	close OUTFILE;
}

# Check file after filtering content
# INPUT:
# $beforeFile: string of file name before 
# $afterFile: string of file name after
# OUTPUT:
# Return 0 if the files are consistent.
sub checkFile
{
	my ($beforeFile, $afterFile) = @_;
	
	my $trimBefore = "trim_$beforeFile";
	filterFile( $beforeFile, $trimBefore );
	my $trimAfter = "trim_$afterFile";
	filterFile( $afterFile, $trimAfter );
	
	# diff the files after filtering
	my $value = system("diff $trimBefore $trimAfter");
	unlink $trimBefore;
	unlink $trimAfter;
	
	return $value;
}

# Check file after filtering content.
# INPUT:
# $beforeFile: string of file name before 
# $afterFile: string of file name after
# $rFilter: reference to your filter implementation. Default to filterFile. Must follow filterFile behavior.
# OUTPUT:
# Return 0 if the files are consistent.
sub checkFileRef
{
	my ($beforeFile, $afterFile, $rFilter) = @_;
	$rFilter = \&filterFile;
	
	my $trimBefore = "trim_$beforeFile";
	&$rFilter( $beforeFile, $trimBefore );
	my $trimAfter = "trim_$afterFile";
	&$rFilter( $afterFile, $trimAfter );
	
	# diff the files after filtering
	my $value = system("diff $trimBefore $trimAfter");
	unlink $trimBefore;
	unlink $trimAfter;
	
	return $value;
}

