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

sub isWindows()
{
	if ($^O eq 'MSWin32')
	{
		return 1;
	} else {
		return 0;
	}
}

sub runJava()
{
	my ( $javaExec, $params ) = @_;
	my $command = '';
	
	if ( isWindows() )
	{
		my $javaPath = "C:/buildTools/current_java/bin/$javaExec";
				
		$command .= join ' ', ($javaPath, $params );
	} else {
		my $javaPath = "/usr/java_home/current_java/bin/$javaExec";
				
		$command .= join ' ', ($javaPath, $params );
	}
	
	return $command;
}

my $verboseSwitch = 1;
my $echoSwitch = 1;

# Assumption: we are at INSTALL_DIR/samples
# TODO: Take INSTALL_DIR from a shared file and chdir to it

# Step 1: Create FD in data
chdir 'java/helloWorld/data' or die "Cannot change dir: $!";
my ($output, $errorlevel) = &runCommand( "objy CreateFd -fdname HelloWorld",$verboseSwitch,$echoSwitch);

# Step 2: Build the sample application
chdir '../src' or die "Cannot change dir: $!";
my $command = &runJava( "javac", "*.java" );
my ($output, $errorlevel) = &runCommand($command,$verboseSwitch,$echoSwitch);

# Step 3: Run the application and check for success message
my $command = &runJava( "java", "Main ../data/HelloWorld.boot" );
my ($output, $errorlevel) = &runCommand($command,$verboseSwitch,$echoSwitch);

unless ( $output =~ m/HelloWorld test has PASSED/ )
{
	print $output;
	die "Unexpected output from Java sample";
}

# Clean up
chdir '../data' or die "Cannot change dir: $!";
my ($output, $errorlevel) = &runCommand( "objy Deletefd -bootfile HelloWorld.boot",$verboseSwitch,$echoSwitch);

chdir '..' or die "Cannot change dir: $!";