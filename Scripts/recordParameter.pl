#!/usr/buildtools/bin/perl

use strict;
use Sys::Hostname;
use Cwd;
use File::Spec;

# hostname
my $hostname = hostname;
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
# Background of this script:
# Some long-running program ProcessProgram processing some big BigData.txt file.
# There is some MonitorProgram that gives a snapshot of some parameters: memory, etc.
# We want to capture and monitor a certain parameter by repeatedly calling MonitorProgram.
# The parameter of interest can be identified by the output: "Parameter description: information here".
#######################################################################

# Setup
my $path = 'C:/main/BigData.dat';
my $recordFile = 'Log.txt';
open FILE, "> $recordFile" or die "Cannot open file for recording";


while ( $errorlevel eq 0 )
{
	($output, $errorlevel) = &runCommand( "MonitorProgram -host $hostname:6783 $path",$verboseSwitch,$echoSwitch);
	my @lines = split /\n/, $output;
	foreach my $line (@lines)
	{
		# print "$line\n";
		if ( $line =~ m/Parameter description/)
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