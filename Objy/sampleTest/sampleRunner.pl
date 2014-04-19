#!/usr/buildtools/bin/perl

# This script is to veriy the tutorial 3: Specifying File Storage
# Check if the Clean Up section is enabled at the end of the script
# If Clean Up is disabled, run "sampleRunner.pl clean" before each run.

use strict;
use Sys::Hostname;
use Cwd;
use File::Spec;

# hostname
# in OQA: $hostname = $oqa::hostname;
my $hostname = hostname;
# current test path
# in OQA: $path = $oqa::qadir;
my $currentPath = getcwd;

# Assumption: we are at INSTALL_DIR/samples
chdir 'placementTutorial/storageTasks' or die "Cannot change dir: $!";

my $echoSwitch = 1;
my $verboseSwitch=1;
my $output;
my $errorlevel;

my @Dirs = qw / LocationA LocationB LocationC LocationD /;
my @Names = qw / LocA LocB LocC LocD /;

# create hash from two arrays
my %DirsForNames;
@DirsForNames{@Names} = @Dirs;

#######################################################################
#######################################################################

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

sub pause
{
	print "Press any key to continue...\n";
	if ( $^O eq 'MSWin32' )
	{
		&runCommand( "pause", 0,0);
	} else {
		&runCommand( "read -p \"Press any key\"", 0,0);
	}
}

# INPUT:
# filename: the name/path of the config file to be modified
# Dirs: list of preferred storage locations
sub setLocationPref
{
	my ($filename, @Dirs) = @_;
	
	# check if file exists
	die "File does not exist" unless (-e $filename);
	
	# Backup the file
	runCommand( "cp $filename $filename.bak",0,0);
	
	# open files
	open ( INFILE, "< $filename.bak" ) or die "Cannot open file";
	open ( OUTFILE, "> $filename" ) or die "Cannot open file";
	
	while ( my $line = <INFILE> )
	{
		print OUTFILE $line;
	}
	
	# close file
	close( INFILE );
	close( OUTFILE );
}


sub example2
{
	my ($verboseSwitch,$echoSwitch, $resetScript, $populatorExec, $bootfile) = @_;
	
	# pg. 81
	($output, $errorlevel) = &runCommand( "$resetScript -Msg",$verboseSwitch,$echoSwitch);
	# my ($output, $errorlevel) = &runCommand( "reset-WithMSG.bat",$verboseSwitch,$echoSwitch);
	($output, $errorlevel) = &runCommand( "objy ImportPlacement -inFile VehicleRR.pmd -bootFile $bootfile",$verboseSwitch,$echoSwitch);
	($output, $errorlevel) = &runCommand( "$populatorExec",$verboseSwitch,$echoSwitch);

	#Checkpoint: Verify that DB files in 4 storage locations
	&checkpoint;
	print "Verify: Default* DB file and 5 Vehicles* DB files among 4 storage locations\n";
}

sub example3
{
	my ($verboseSwitch,$echoSwitch, $resetScript, $populatorExec, $bootfile) = @_;
	
	# pg. 84
	# Modify the .config file
	&setLocationPref( 'App1Prefs.config', @Dirs[3,4] );

	# pg. 86
	($output, $errorlevel) = &runCommand( "$resetScript -msg",$verboseSwitch,$echoSwitch);
	# ($output, $errorlevel) = &runCommand( "reset-WithMSG.bat",$verboseSwitch,$echoSwitch);
	($output, $errorlevel) = &runCommand( "$populatorExec -loadConfiguration App1Prefs.config",$verboseSwitch,$echoSwitch);

	# Checkpoint: Verify that DB files
	&checkpoint;
	print "Verify: Default_1.RentalComapnyData.DB file created in LocationC \n";
}

# Example from page 87
sub example4
{
	my ($verboseSwitch,$echoSwitch, $resetScript, $populatorExec, $bootfile) = @_;
	
	# Page 87
	&runCommand( "$resetScript -MSG",$verboseSwitch,$echoSwitch);
	&runCommand( "objy ImportPlacement -inFile Customers.pmd -bootfile $bootfile",$verboseSwitch,$echoSwitch);
	&runCommand( "objy AddStorageLocation -name LocB -dbPlacerGroup Customers -bootfile $bootfile",$verboseSwitch,$echoSwitch);
	&runCommand( "$populatorExec",$verboseSwitch,$echoSwitch);
	
	# Checkpoint: Verify that DB files
	&checkpoint;
	print "Verify: Customers_1.RentalComapnyData.DB file created in LocationB \n";
	print "Verify: Default_1.RentalComapnyData.DB file created in LocationA \n";
}

sub checkpoint
{
	if ( $^O eq 'MSWin32' )
	{
		my ($output, $errorlevel) = &runCommand( "dir *.DB /s/b",$verboseSwitch,$echoSwitch);
	} else {
		my ($output, $errorlevel) = &runCommand( "ls *.DB",$verboseSwitch,$echoSwitch);
		my ($output, $errorlevel) = &runCommand( "ls */*.DB",$verboseSwitch,$echoSwitch);
	}
}

#######################################################################
#######################################################################

my $resetScript;
if ( $^O eq 'MSWin32' )
{
	# $resetScript = 'reset2.bat';
	$resetScript = 'reset.exe';
} else {
	# $resetScript = './reset.sh';
	$resetScript = './reset';
}

my $populatorExec;
if ( $^O eq 'MSWin32' )
{
	$populatorExec = 'populate.exe';
} else {
	$populatorExec = './populate';
}

my $bootfile = 'RentalCompanyData.boot';


if ( $ARGV[0] eq 'clean' )
{
	# Clean up
	($output, $errorlevel) = &runCommand( "$resetScript -clean",$verboseSwitch,$echoSwitch);
	($output, $errorlevel) = &runCommand( "rm -r @Dirs",$verboseSwitch,$echoSwitch);
	die "Finish cleaning up";	
}
#######################################################################
#######################################################################

# Setup
($output, $errorlevel) = &runCommand( "mkdir @Dirs",$verboseSwitch,$echoSwitch);

######################################################################

# Starting the tutorial: pg. 74
($output, $errorlevel) = &runCommand( "$resetScript",$verboseSwitch,$echoSwitch);

# pg. 75
($output, $errorlevel) = &runCommand( "objy AddStorageLocation -name $Names[0] -storageLocation ./$Dirs[0] -bootFile $bootfile",$verboseSwitch,$echoSwitch);

# pg. 76
($output, $errorlevel) = &runCommand( "objy AddStorageLocation -storageLocation ./$Dirs[1] -storageLocation ./$Dirs[2] -storageLocation ./$Dirs[3] -bootFile $bootfile",$verboseSwitch,$echoSwitch);

($output, $errorlevel) = &runCommand( "$populatorExec",$verboseSwitch,$echoSwitch);
# Checkpoint: Verify that DB file in $Dirs[0] and bootfile folder



# pg. 77
($output, $errorlevel) = &runCommand( "objy ListStorage -bootFile $bootfile",$verboseSwitch,$echoSwitch);
# pg. 78:  renaming
($output, $errorlevel) = &runCommand( "objy AddStorageLocation -name $Names[1] -storageLocation ./$Dirs[1] -bootFile $bootfile",$verboseSwitch,$echoSwitch);
($output, $errorlevel) = &runCommand( "objy RemoveStorageLocation -storageLocation ./$Dirs[3] -bootFile $bootfile",$verboseSwitch,$echoSwitch);
($output, $errorlevel) = &runCommand( "objy ListStorage -bootFile $bootfile",$verboseSwitch,$echoSwitch);

# pg.79: managing storage zones
my $zoneName = 'MountainCentral';
($output, $errorlevel) = &runCommand( "objy AddStorageLocation -zone $zoneName -name $Names[1] -bootFile $bootfile",$verboseSwitch,$echoSwitch);
($output, $errorlevel) = &runCommand( "objy AddStorageLocation -zone $zoneName -storageLocation ./$Dirs[2] -storageLocation ./$Dirs[3] -bootFile $bootfile",$verboseSwitch,$echoSwitch);

($output, $errorlevel) = &runCommand( "objy RemoveStorageLocation -zone $zoneName -storageLocation ./$Dirs[3] -bootFile $bootfile",$verboseSwitch,$echoSwitch);

($output, $errorlevel) = &runCommand( "objy ListStorage -bootFile $bootfile",$verboseSwitch,$echoSwitch);

&pause;
### OK ####

##############

&example2($verboseSwitch,$echoSwitch, $resetScript, $populatorExec, $bootfile);
&pause;

##############

&example3($verboseSwitch,$echoSwitch, $resetScript, $populatorExec, $bootfile);
&pause;

##############

&example4($verboseSwitch,$echoSwitch, $resetScript, $populatorExec, $bootfile);
&pause;



#######################################################################
# Clean up
($output, $errorlevel) = &runCommand( "$resetScript -clean",$verboseSwitch,$echoSwitch);
($output, $errorlevel) = &runCommand( "rm -r @Dirs",$verboseSwitch,$echoSwitch);

chdir '../..' or die "Cannot change directory: $!";