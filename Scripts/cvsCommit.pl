use strict;

#########################################################
# This portion is used to commit multiple files (with the same name) in different folders.

# my @MyTests = qw/ 18961 19242 19001 19250 19569 19392 /;

# foreach my $test (@MyTests)
# {
	# my $dir = $test - ($test % 1000);
	# my $command = "cvs commit -m \"ISSUE-$test: Some checkin message.\" $dir\\$test\\Somename.cpp";
	# print "$command\n";
	# my $output = `$command`;
# }


#########################################################
# This portion is used to copy oldConfig.cfg to newConfig.cfg, and replace the former with the later on CVS.

use File::Copy qw{copy};

my @ToolTestId = qw/ 19828 19854 19896 /;
my @ToolTestName = qw/ ToolA ToolB ToolC /;

my @ToolTestId = qw/ 19896 /;
my @ToolTestName = qw/ ToolC /;

my %NameForId;
@NameForId{@ToolTestId} = @ToolTestName;

my $oldFileName = "oldConfig.cfg";
my $newFileName = "newConfig.cfg";
my $baseFolder = 'C:\cvsrepo';

foreach my $test (@ToolTestId)
{
	# change current directory
	my $curFolder = File::Spec->catdir($baseFolder, $NameForId{$test});
	print "cd $curFolder\n";
	chdir $curFolder;
	
	# copy nightlyTests.cfg objyToolTests.cfg
	copy $oldFileName, $newFileName;
	
	# cvs delete nightlyTests.cfg
	unlink $oldFileName;
	my $command = "cvs delete $oldFileName";
	system $command;
	
	# cvs add objyToolTests.cfg
	my $command = "cvs add $newFileName";
	system $command;
	
	# cvs commit -m "ISSUE-: Change the config file" nightlyTests.cfg objyToolTests.cfg
	my $command = "cvs commit -m \"ISSUE-$test: Change the config file\" $oldFileName $newFileName";
	print "$command\n";
	system $command;
}

