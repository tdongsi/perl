#!/usr/buildtools/bin/perl

# This script is to verify Java sample Hello World.
# It reproduces the steps, based on README.txt

use strict;
use File::Copy;
use Sys::Hostname;

my $INSTALL_DIR = $ARGV[0];
print "Assumption: we are at $INSTALL_DIR\n";

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

sub searchReplaceFile()
{
	my ($file, $original_string, $new_string) = @_;
	print "File: $file\n";
	open FILE, "< $file" or die "Cannot open $file: $!";
	chomp( my @lines = <FILE> );
	close FILE;

	copy( $file, "$file.bak" ) or die "Faile to backup $file: $!";

	open OUT, "> $file" or die "Cannot open $file: $!";

	foreach my $line (@lines)
	{
		 $line =~ s/$original_string/$new_string/;
		 # $line =~ s#qadir\.host1 .+#qadir.host1 = $cwd/intelnt#;
		 # $line =~ s#objydir\.host1 .+#objydir.host1 = Y:/release/R11_2_0#;
		 print OUT "$line\n";
	}

	close OUT;
}

if ( isWindows() )
{
	!system( 'cp -r sql/ooisql sql/ooisqlbak' ) or die "Fail to backup: $!";
	
	# Running ooisql demo
	copy( "../etc/sql/usr_proc/Makefile", "sql/ooisql/Makefile" ) or die "Cannot copy Makefile: $!";
	
	chdir 'sql/ooisql' or die "Cannot change directory: $!";
	
	print "Editing Makefile ... \n";
	&searchReplaceFile( 'Makefile', 'INSTALL_DIR\s+=.+', "INSTALL_DIR = $INSTALL_DIR" );
	
	print "Editing demo.bat ... \n";
	&searchReplaceFile( 'demo.bat', 'dummy', "sql4eran" );
	
	&runCommand( "nmake all", 1, 1 );
	my ($output, $error) = &runCommand( "demo.bat", 1, 1 );
	
	my $check1 = 0;
	if ( $output =~ m/FC: no differences encountered/ )
	{
		$check1 = 1;
	}
	
	unless ( $check1 eq 1)
	{
		die "Windows ooisql demo fails: $check1";
	}
	
	# Running odbc sample manually (using VS)
	
} else {
	!system( 'cp -r sql/ooisql sql/ooisqlbak' ) or die "Fail to backup: $!";
	
	# Running ooisql demo
	chdir 'sql/ooisql' or die "Cannot change directory: $!";
	
	print "Editing Makefile ... \n";
	&searchReplaceFile( 'Makefile', 'INSTALL_DIR\s+=.+', "INSTALL_DIR = $INSTALL_DIR" );
	my $hostname = hostname;
	&searchReplaceFile( 'Makefile', 'LS_HOST\s+=.+', "LS_HOST = $hostname" );
	&searchReplaceFile( 'Makefile', 'FDID\s+=.+', "FDID = 1234" );
	
	print "Editing demo.sh ... \n";
	&searchReplaceFile( 'demo.sh', 'passwd=.+', "passwd=sql4eran" );
	
	my ($output, $error) = &runCommand( "make", 1, 1 );
	die "Fail to compile sample" if $error;
	
	my ($output, $error) = &runCommand( "./demo.sh", 1, 1 );
}