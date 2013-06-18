package SystemUtility;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( absolutePath is_folder_empty fileExists );


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