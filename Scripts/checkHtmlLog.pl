use strict;
use LWP::Simple;

# This script is used to check the QA logs from link
# Call the script: checkQaLog HTML_link.
# The summary log is saved as summary.html.


# Grab all the lines that contain the IDs from a file
# USAGE: @Entries = grepIdFromFile( $filePath, @IDs);
# INPUT:
# $filePath: path to the file
# @IDs: list of IDs. Each ID has the format: 'script qatest/.../.../someTestName.qas'
# OUTPUT:
# @entries: list of lines in the file that contain the IDs
sub grepIdFromFile
{
	my ( $filename, @IDs ) = @_;
	my @Entries;
	
	foreach my $id ( @IDs )
	{
		open (INFILE, "< $filename") or die "Cannot open file: $!.";
		while ( my $line = <INFILE> )
		{
			chomp($line);
			if ( not $line =~ m/^#/ and $line =~ m/$id/ )
			{
				# print "$line\n";
				push @Entries, $line;
				
				# This line assumes that each ID appears once in the file
				last;
			}
		}
		close (INFILE);
	}
	
	return @Entries;
}

# Filter out those QA tests based on their test call in QAS files
# USAGE: parseHtmlQaLog( $filePath, @IDs);
# INPUT:
# $filePath: path to the HTML file
# @IDs: list of IDs which are the test calls in QAS files. Each ID has the format: 'script qatest/.../.../someTestName.qas'
sub parseHtmlQaLog
{
	my ( $inFilename, $outFilename, @CallLines ) = @_;
	# Keep one dummy entry to ensure the flags are set correctly
	push @CallLines, 'script qatest/dummy/dummy/dummy/dummy.qas';
	my $DEBUG = 0;
	
	open (INFILE, "< $inFilename") or die "Cannot open file for reading: $!.";
	open (OUTFILE, "> $outFilename") or die "Cannot open file for writing: $!.";
	
	# Crop the top summary section
	my $writeFlag = 0; # Flag indicates that we should copy the current line in test summary
	my $flagIndex = 0; # Flag indicates that we're in test summary
	my $count = 0;
	while ( my $line = <INFILE> )
	{
		# If "Full Log:" found, terminate
		$count++;
		if ( $line =~ m/Full Log:/ )
		{
			last;
		}
		
		# When encountering line with "Index: " string, set the flag on
		if ( not $flagIndex and $line =~ m/Index: / )
		{
			$flagIndex = 1;
			print OUTFILE $line;
			next;
		} elsif ( not $flagIndex )
		{
			# Before encountering line with "Index: " string, print them all
			print OUTFILE $line;
			next;
		}
		
		# Parsing the summary of the OQA log
		if ( $flagIndex )
		{
			if ( $writeFlag )
			{
				# if writeFlag on, search for "script qatest/(anything).qas" in the line
				if ( $line =~ m{script qatest/(.)*\.qas} )
				{
					# part of the next test summary
					print "Found a script entry at line $count.\n" if $DEBUG;
					foreach my $i (0..$#CallLines)
					{
						# if the next test is also my test
						if ( $line =~ m/\Q$CallLines[$i]\E/ )
						{
							$writeFlag = 1;
							splice @CallLines, $i, 1; # remove the entry from my list
							print OUTFILE $line;
							# print "HERE4: $line";
							# break the foreach loop
							last;
						} else {
							# turn off write flag
							$writeFlag = 0;
						}
					} # end foreach
				} else {
					print OUTFILE $line;
					# print "HERE3: $line";
				}
			} else {
				# if writeFlag off, search for "script qatest/(anything).qas" in the line
				if ( $line =~ m{script qatest/(.)*\.qas} )
				{
					print "Found a script entry at line $count.\n" if $DEBUG;
					foreach my $i (0..$#CallLines)
					{
						if ( $line =~ m/\Q$CallLines[$i]\E/ )
						{
							$writeFlag = 1;
							splice @CallLines, $i, 1; # remove the entry from my list
							print OUTFILE $line;
							# print "HERE4: $line";
							# break the foreach loop
							last;
						}
					} # end foreach
				} else {
					next;
				}
			}
		}
	}
	
	print OUTFILE '<h1>Ingore those lines above "Index:"</h1>';
	print OUTFILE '</body> </html>';
	close (INFILE);
	close (OUTFILE);
}


# MAIN

#######################################################################
### OPTIONAL: In this section, find the entry based on the ID from list of entries in files
#######################################################################

# Some IDs: both text and number
my @Tools = qw/ AddStorageLocation
CreateContainers
CreateFd
ExportPlacement
ImportPlacement
RemoveStorageLocation /;
my @IssueNumbers = qw/ 15327 18961 19001 19242 19250 19392 19569 19656 19755 19831 20133 /;

# grab entry from ToolTests.qas
my @ToolTestCalls = grepIdFromFile( 'C:/ToolTests.qas', @Tools );
foreach my $call (@ToolTestCalls)
{
	print "$call\n";
}

# grab entry from TestsR110.qas
my @R11TestCalls = grepIdFromFile( 'C:/TestsR110.qas', @IssueNumbers );
foreach my $call (@R11TestCalls)
{
	print "$call\n";
}
#######################################################################
#######################################################################

# Call the script: checkQaLog HTML_link.

my $link = $ARGV[0];
print "Retrieving $link ... \n";
my $localHtml = 'local.html';
my $outHtml = 'summary.html';

my $status = getstore($link, $localHtml);
unless (is_success($status)) {
  die "An error has occured! Status code: $status\n";
}

&parseHtmlQaLog( $localHtml, $outHtml, (@ToolTestCalls, @R11TestCalls) );
# &parseHtmlQaLog( "SPRTestsR110_OQA_log2.htm", "temp2.htm", (@ToolTestCalls, @R11TestCalls) );

