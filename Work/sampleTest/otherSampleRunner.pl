#!/usr/buildtools/bin/perl

# This script is to verify Java sample Hello World.
# It reproduces the steps, based on README.txt

use strict;

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
	
	if ( $verbose )
	{
		print "$output\n";
	}
	
	warn "\n\n\nERROR: Error executing command: $command. Returns $errorlevel\n\n\n" if $errorlevel;
	
	return ($output,$errorlevel);
}

my $verboseSwitch = 1;
my $echoSwitch = 1;

# Assumption: we are at INSTALL_DIR/samples
# TODO: Take INSTALL_DIR from a shared file and chdir to it

# NOTE: The ordering of these tests matters, due to chdir commands.
# If modularity is needed, chdir back to the orginal dir after EACH sample test.

# Python sample helloWorld
chdir 'python/helloWorld' or die "Cannot change dir: $!";
my ($output, $errorlevel) = &runCommand( "python main.py",$verboseSwitch,$echoSwitch);
unless ( $output =~ m/Found HelloObject and it says Hello World/ )
{
	print $output;
	die "Unexpected output from Java sample";
}

# Python sample tutorial
chdir '../tutorial' or die "Cannot change dir: $!";
my ($output, $errorlevel) = &runCommand( "python tutorial.py",$verboseSwitch,$echoSwitch);

# objydbTutorial
chdir '../../objydbTutorial' or die "Cannot change dir: $!";
&runCommand( "chmod 777 *.*", $verboseSwitch, $echoSwitch );
my ($output, $errorlevel) = &runCommand( "objy installfd -bootfile RentalCompany.boot",$verboseSwitch,$echoSwitch);
my ($output, $errorlevel) = &runCommand( "objy license -fromdefault -bootfile RentalCompany.boot",$verboseSwitch,$echoSwitch);


# C++ sample on Unix
if ( $^O ne 'MSWin32' )
{
	chdir '../cxx/helloWorld' or die "Cannot change dir: $!";
	
	# Based on README.txt, except doing directly at the installed sample folder.
	&runCommand( "make -e", $verboseSwitch, $echoSwitch );
	&runCommand( "./helloWorld data/HelloWorld.boot", $verboseSwitch, $echoSwitch );
}

# Clean up
chdir '../..' or die "Cannot change dir: $!";