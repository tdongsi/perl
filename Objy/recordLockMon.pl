#!/usr/buildtools/bin/perl

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

my $echoSwitch = 1;
my $verboseSwitch=0;
my $output;
my $errorlevel = 0;


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

#######################################################################
#######################################################################

# Setup
my $path = 'C:/FinalWorkspace/main/qatest/SPR_tests/oocheck_oofix/spr_18043/win_x64/db1.boot';
my $recordFile = 'oolockmonRecord_R1021.txt';
open FILE, "> $recordFile" or die "Cannot open file for recording";


while ( $errorlevel eq 0 )
{
	($output, $errorlevel) = &runCommand( "oolockmon -host $hostname:6783 $path",$verboseSwitch,$echoSwitch);
	my @lines = split /\n/, $output;
	foreach my $line (@lines)
	{
		# print "$line\n";
		if ( $line =~ m/Lock table displayed/)
		{
			print FILE "$line\n";
		}
	}
	sleep 1;
}

close(FILE);

#######################################################################
# Clean up
# ($output, $errorlevel) = &runCommand( "rm -r @Dirs",$verboseSwitch,$echoSwitch);