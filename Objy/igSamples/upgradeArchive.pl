use strict;
use Utility;
use File::Copy;

#Specify the following constants based on where you are
my $version = '3.0';
my $platform = 'win_x64';

#DEBUG
my $echo = ECHO_FLAG;
my $verbose = VERBOSE_FLAG;

# We skipped generating IGFacebookSample, JSNAPMongoDB, and WebGroupStorageSample
my @samples = qw/ FlightPlanSample
HelloGraphSample
IGFacebookSample
IGGratefulSample
IGIMDBSample
IGLinkHunterSample
IGWikiSample
JSNAPMongoDB
JSNAPSample
NDCSample
PharmGraphSample
RelationsSample
URLTagSample
WebGroupSample
/;

# Temporary folder to download the zip DB, extract, and upgrade
my $temp = 'TempUpgrade';

unless (-e $temp)
{
	mkdir $temp or die "Cannot create dir $temp: $!";
}
chdir $temp or die "Cannot change dir $temp: $!";


my $caseyPath;
if ( isWindows() )
{
	$caseyPath = '//casey/tc/qa/IG_archive/';
} else {
	$caseyPath = '/net/casey/tc/qa/IG_archive/';
}

my $appendix = 'IG' . $version . '/' . $platform;
my $fullPath = $caseyPath . $appendix;

foreach my $sample (@samples)
{
	my $zipFileName = "$sample.zip";
	my $zipFilePath = "$fullPath/$zipFileName";
	my ($output, $errorlevel) = runCommand( "cp $zipFilePath .", $verbose, $echo );
	my ($output, $errorlevel) = runCommand( "unzip -o ./$zipFileName", $verbose, $echo );
	
	my ($bootPath, $errorlevel) = runCommand( "ls ./$appendix/$sample/*.boot", $verbose, $echo );
	
	my ($output, $errorlevel) = runCommand( "ooinstallfd $bootPath", $verbose, $echo );
	my ($output, $errorlevel) = runCommand( "oolicense -fromdefault $bootPath", $verbose, $echo );
	my ($output, $errorlevel) = runCommand( "cmd /c igupgrade -bootfile $bootPath", $verbose, $echo );
	
	my ($output, $errorlevel) = runCommand( "mv ./$appendix/$sample ../". ARCHIVE_HOME, $verbose, $echo );
}

chdir '..' or die "Cannot change dir: $!";
