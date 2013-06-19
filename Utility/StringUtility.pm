package StringUtility;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( allSubstrings randomString randomValidName reportProgress
					wordWrap trim RemoveSomeLinesInFile
					removePath removeSubstring replaceStringInFile convertStringToSize);

# subroutine for trimming lines
sub trim($)
{
     my $string = shift;
     $string =~ s/^\s+//;
     $string =~ s/\s+$//;
     return $string;
}


# Convert the size string such as "1024k", "2g" into the numerical size in bytes.
sub convertStringToSize
{
	my ($sizeString) = @_;
	my %sizeHash = ( 'k' => 1024, 'm' => 1024*1024, 'g' => 1024*1024*1024 );
	
	my $number = substr $sizeString, 0, length($sizeString) -1;
	my $suffix = lc (substr $sizeString, -1);
	# print "number: $number suffix: $suffix\n";
	
	if ( !$sizeHash{$suffix} )
	{
		die "Undefined suffix";
	}
	
	return $number * $sizeHash{$suffix};
}



# Return a list of all substrings from a string and its minimum length
# Ver 0.2: all substrings in both normal and upper cases
# Input: 
# 1. The given string
# 2. Minimum length of the substrings
# Output:
# List of all substrings (including the full string)
sub allSubstrings
{
	my( $string, $minLength ) = @_;
	my $fullLength = length( $string );
	my $upperCase_option = uc $string;
	my @allSubstrings;
	
	foreach my $i ( $minLength..$fullLength )
	{
		my $abbrOption = substr $string, 0, $i;
		push @allSubstrings, $abbrOption;
		$abbrOption = substr $upperCase_option, 0, $i;
		push @allSubstrings, $abbrOption;
	}
	
	return @allSubstrings;
}


# Generate a random string with a given length and character class
sub randomString
{
	my ( $length, @chars ) = @_;
	my $outString = "";
	foreach (1..$length)
	{
		$outString .= $chars[ rand scalar @chars ];
	}
	return $outString;
}


# Generate a random valid name, given the length.
# The first char of the name cannot be '-'.
sub randomValidName
{
	my ( $length ) = @_;
	my @charClass = ('A'..'Z','a'..'z','0'..'9','_', '-');
	my $name;
	do {
		$name = randomString( $length, @charClass );
	} while ( substr($name,0,1) eq "-" );
	return $name;
}


# Print a nice message banner
sub reportProgress
{
     my ($message) = @_;
     print '*' x length($message);
     print "\n$message\n";
     print '*' x length($message);
     print "\n";
}


# Subroutine to word wrap a long string
# INPUT
# $out: the output sink
# $str: the string to be word-wrapped and appended into the output sink
# $left: left margin
# $right: right margin
# $hangingIndent: indentation after the first line
# OUTPUT:
# The string after being word-wrapped.
sub wordWrap
{
     my ($out, $str, $left, $right, $hangingIndent) = @_;
     $hangingIndent = 0 unless defined $hangingIndent;
     my $lineBreakCharacters = " /\\";
    
     # the first line will be full, defined by rigtht and left margins
     my $firstLineWidth = $right -$left;
     # the next lines may be indented, depending on $hangingIndent
     my $indentedLineWidth = $firstLineWidth - $hangingIndent;
     # the current margin width, initialized for the first line
     my $width = $firstLineWidth;
     # string to represent indentation
     my $indent = ' ' x ($left+$hangingIndent);

     # In this Perl code, the $str is updated with its remaining substring after printing out lines.
     # pos for starting of the string
     # maxCurrentLen for the expected ending of the string after 'width' characters
     while ( $width < length $str )
     {
          my $breakPos;
    
          # # Find first match of "\r\n" of the current substring
          # # If first match = (not found) OR (greater than current length)
          # # find the last match of line break chars " /\\" in the range (0,width)
          # # If last match = (not found), then breakPos = width;
         
          if ( $str =~ m/[\r\n]/ and $-[0] <= $width )
          {
               # Find the position of first match
               # print "str: $str, \$-[0]: $-[0]\n";
               $breakPos = $-[0];
          } else {
               # If first match not found OR $breakPos > $width
               my $temp = reverse substr( $str, 0, $width );
               if ( $temp =~ m{[ /\\]} )
               {
                    # Find the last match of line break characters
                    # print "str: $str, \$+[0]: $+[0] $-[0]\n";
                    $breakPos = length($temp) - $+[0];
               } else {
                    # Line break characters not found
                    # print "str: $str\n";
                    $breakPos = $width;
               }
          }
         
          my $substr = substr( $str, 0, $breakPos );
          $out .= "$substr\n$indent";
          # pos += substr.size();
          $str = substr( $str, $breakPos );
         
          $width = $indentedLineWidth;
     }
    
     # the last extra
     $out .= "$str\n";
     return $out;
}


# Replace a string in the file with another string and save to another filename
# The inputs are self-explanatory
sub replaceStringInFile
{
     my ($inFile, $outFile, $originalString, $replaceString) = @_;
     
     open INFILE, "< $inFile" or die $!;
     my $string = do { local $/; <INFILE> };
     close INFILE;
     
     $string =~ s/\Q$originalString\E/$replaceString/;
     
     open OUTFILE, "> $outFile" or die $!;
     print OUTFILE $string;
     close OUTFILE;
}



# Remove some specific lines (defined inside the subroutine) in the text file
sub RemoveSomeLinesInFile()
{
     my($inFile,$outFile) = @_;
     # Open file handle for reading
     open(INFILE, "$inFile") or die "Cannot open $inFile: $!\n";
     # Read the lines into the array
     my @lines = <INFILE>;
     # Close the file handle
     close(INFILE);

     # Open file handle for writing or signal an OQA failure
     # Create a copy of the file since you don't want to modify the pmd files
     open(OUTFILE, "> $outFile") or die "Cannot open $outFile: $!\n";
    
     # For each line in the array
     foreach my $line (@lines)
     {
          # Remove white space, using the trim function in this module
          $line = trim($line);
         
          # Process lines based on the keywords.
          # Use regex: $string =~ m/sought_text/;
          if ($line =~ m/PMD/ || $line =~ m/version/ || $line =~ m/timestamp/)
          {
               # skip the lines with those text
          }
          elsif ( $line =~ m/objectSize/ )
          {
               # remove the objectSize because the PMD is intended for 64-bit platforms
               # it will be different on 32-bit platforms (intelnt, linux86gcc3)
               $line =~ s/objectSize="\d+"//;
               print OUTFILE "$line\n";
          }
          else
          {
               # write the lines without those text
               print OUTFILE "$line\n";
          }
     }
     close(OUTFILE);
}


# Remove a substring from a list of strings
# The substring is taken as literal, i.e. it may contain special characters.
# USAGE:
# @outputList = removeSubstring( $substring, @inputList )
# INPUT:
# substring: the literal substring to be removed.
# inputList: list of input strings
# OUTPUT:
# outputList: list of string with substring removed.
sub removeSubstring
{
     my ( $entry, @storageList ) = @_;
     foreach my $i ( 0 .. $#storageList )
     {
          $storageList[$i] =~ s/\Q$entry\E//;
     }
     return @storageList;
}


# Remove all entries of a path from a list of folder paths
# USAGE:
# @outputList = removePath( $path, @inputList )
# INPUT:
# substring: the path (host::full_path) to be removed.
# inputList: list of folder paths
# OUTPUT:
# outputList: list of folder paths with the given path removed.
sub removePath
{
     my ( $path, @storageList ) = @_;
	 
	 # # Wrap the path if needed
     # my $sink = &writeRow( "DummyName", $path );
     # my $wrappedPath = substr( $sink, 23);
	 my $wrappedPath = $path;
	 
     foreach my $i ( 0 .. $#storageList )
     {
          # Remove all the entries found with wrapped path instance
          # Regex: 2 white space at the beginning of the line (^[ ]{2} with /m modifier)
          # + any name (.+) + literal wrapped path (\Q$wrappedPath\E)
          $storageList[$i] =~ s/^[ ]{2}.+\Q$wrappedPath\E//gm;
     }
     return @storageList;
}

