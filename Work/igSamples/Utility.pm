#!/usr/bin/perl
# TAGS: System

# Functions to use command line to compile and run Java programs to create InfiniteGraph FDs.

package Utility;
use strict;
use warnings;
use Exporter;
use File::Copy;

our @ISA= qw( Exporter );
our @EXPORT = qw{ runCommand isWindows ARCHIVE_HOME VERBOSE_FLAG ECHO_FLAG IG_HOME ANT_HOME
createHelloWorldSample
createHelloGraphSample
createWebGroupSample
createWebGroupStorageSample
createPharmGraphSample
createPharmGraphSamplePipeline
createIGWikiSample 
createFlightPlanSample
createNDCSample
createIGGratefulSample
createURLTagSample
createRelationsSample
createJSNAPSample
createIGIMDBSample
createIGLinkHunterSample
};

use constant { 
	VERBOSE_FLAG => 1,
	ECHO_FLAG => 1,
	IG_HOME => 'C:/ig',
	ANT_HOME => 'C:/buildTools/apache-ant-1.6.2',
	ARCHIVE_HOME => 'Win64', # relative path to the folder where the created FD should be moved to
	# ANT_HOME => 'C:/buildTools/ant',
};


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

sub isWindows()
{
	if ($^O eq 'MSWin32')
	{
		return 1;
	} else {
		return 0;
	}
}

my $igJar = IG_HOME."/lib/InfiniteGraph.jar";
my $slf4jJar = IG_HOME."/lib/slf4j-simple-1.6.1.jar";
my @classPath = ('.', './src', $igJar, $slf4jJar );
our $classPath;
if ( $^O eq "MSWin32" )
{
	$classPath = join ';', @classPath;
} else
{
	$classPath = join ':', @classPath;
}
print "my classpath $classPath \n";

# No need to clean up the FD before rerun the script
sub createHelloGraphSample
{
	my $sampleName = 'HelloGraphSample';
	my $output;
	my $errorlevel;
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	($output, $errorlevel) = &runCommand( "javac -cp $classPath ./src/com/infinitegraph/samples/hellograph/HelloGraph.java" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "java -cp $classPath com.infinitegraph.samples.hellograph.HelloGraph" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName\n" if not $errorlevel; #if successful
	&runCommand( "mv *.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}


sub createHelloWorldSample
{
	my $sampleName = 'HelloWorldSample';
	my $output;
	my $errorlevel;
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	($output, $errorlevel) = &runCommand( "javac -cp $classPath ./src/com/infinitegraph/samples/hellograph/HelloGraph.java" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "java -cp $classPath com.infinitegraph.samples.hellograph.HelloGraph" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName\n" if not $errorlevel; #if successful
	&runCommand( "mv *.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createWebGroupSample
{
	my $sampleName = 'WebGroupSample';
	my $output;
	my $errorlevel;
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createWebGroupStorageSample
{
	my $sampleName = 'WebGroupStorageSample';
	my $output;
	my $errorlevel;
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	
	chdir 'data' or warn "Cannot change directory to data: $!";
	($output, $errorlevel) = &runCommand( "objy AddStorageLocation -name  LocA -storageLocation LocationA -bootfile WebGroupStorage.boot" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "objy AddStorageLocation -name  LocB -storageLocation LocationB -bootfile WebGroupStorage.boot" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "objy AddStorageLocation -name  LocC -storageLocation LocationC -bootfile WebGroupStorage.boot" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "objy AddStorageLocation -name  LocD -storageLocation LocationD -bootfile WebGroupStorage.boot" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "objy AddStorageLocation -name LocB -name LocC -zone ZoneBC -bootfile WebGroupStorage.boot" ,VERBOSE_FLAG,ECHO_FLAG);
	
	chdir '..' or warn "Cannot change directory to WebGroupStorageSample: $!";
	($output, $errorlevel) = &runCommand( "ant runApp1" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runApp2" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	if ( not $errorlevel )
	{
		&runCommand( "mv data/* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG);
		mkdir "data/LocationA" or warn "Cannot create LocationA: $!";
		mkdir "data/LocationB" or warn "Cannot create LocationA: $!";
		mkdir "data/LocationC" or warn "Cannot create LocationA: $!";
		mkdir "data/LocationD" or warn "Cannot create LocationA: $!";
	}
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createPharmGraphSample
{
	my $sampleName = 'PharmGraphSample';
	my $output;
	my $errorlevel;
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant cleanall" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runStandardCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runStandardIngest" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createPharmGraphSamplePipeline
{
	my $sampleName = 'PharmGraphSample';
	my $output;
	my $errorlevel;
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant cleanall" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runAcceleratedCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runAcceleratedIngest" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/PharmGraphSamplePipeline" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

# Manual steps:
# Edit build.xml
# 3 minutes to ingest
sub createIGWikiSample
{
	my $sampleName = 'IGWikiSample';
	my $output;
	my $errorlevel;
	
	my $dataFile = 'page_links_en.nt.bz2';
	unless ( -e "Samples/$sampleName/wikidata/$dataFile" )
	{
		copy( "$dataFile", "Samples/$sampleName/wikidata/$dataFile" ) or warn "Cannot copy data file: $!";
	}
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	$ENV{'MYANT_HOME'} = ANT_HOME;
	# print " $ENV{'ANT_HOME'} \n";
	
	# # Workaround 2:
	# # Change in build.xml: <property name="lib.dir" value="${env.ANT_HOME}/lib" /> to <property name="lib.dir" value="${env.MYANT_HOME}/lib" />
	# $ENV{'MYANT_HOME'} = ANT_HOME;
	
	# # Workaround 1:
	# # Copy ant.jar to the current folder
	# # Change in build.xml: <property name="lib.dir" value="${env.ANT_HOME}/lib" /> to <property name="lib.dir" value="." />
	# copy( ANT_HOME.'/lib/ant.jar', './ant.jar' ) or die "Can't copy: $!";
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant cleandb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runWikiCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runWikiIngest" ,VERBOSE_FLAG,ECHO_FLAG);
	# ($output, $errorlevel) = &runCommand( "ant runWikiRun" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createFlightPlanSample
{
	my $sampleName = 'FlightPlanSample';
	my $output;
	my $errorlevel;
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant run" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

# Manual steps:
sub createNDCSample
{
	my $sampleName = 'NDCSample';
	my $output;
	my $errorlevel;
	
	# Copy the data file
	my @dataFiles = qw{package.txt
	package.xls
	product.txt
	product.xls};
	foreach my $dataFile (@dataFiles)
	{
		unless ( -e "Samples/$sampleName/NDCdata/$dataFile" )
		{
			copy( "$dataFile", "Samples/$sampleName/NDCdata/$dataFile" ) or warn "Cannot copy data file: $!";
		}
	}
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant cleanall" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runStagePatientDatabase" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runImportPatient" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runImportProduct" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runGeneratePatientAllergies" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createIGGratefulSample
{
	my $sampleName = 'IGGratefulSample';
	my $output;
	my $errorlevel;
	
	my $dataFile = 'graph-example-2.xml';
	unless ( -e "Samples/$sampleName/resources/$dataFile" )
	{
		copy( "$dataFile", "Samples/$sampleName/resources/$dataFile" ) or warn "Cannot copy data file: $!";
	}
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant cleandb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runCreateDb" ,0,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runImport" ,0,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createURLTagSample
{
	my $sampleName = 'URLTagSample';
	my $output;
	my $errorlevel;
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant run" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createRelationsSample
{
	my $sampleName = 'RelationsSample';
	my $output;
	my $errorlevel;
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant run" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

sub createJSNAPSample
{
	my $sampleName = 'JSNAPSample';
	my $output;
	my $errorlevel;
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant cleandb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runGraph" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}


sub createJSNAPMongoDB
{
	my $sampleName = 'JSNAPMongoDB';
	my $output;
	my $errorlevel;
}


sub createIGIMDBSample
{
	my $sampleName = 'IGIMDBSample';
	my $output;
	my $errorlevel;
	
	# Copy the data file
	my @dataFiles = qw{actors.list.gz
		actresses.list.gz
		cinematographers.list.gz
		composers.list.gz
		directors.list.gz
		editors.list.gz
		producers.list.gz
		writers.list.gz};
	foreach my $dataFile (@dataFiles)
	{
		unless ( -e "Samples/$sampleName/resources/$dataFile" )
		{
			copy( "$dataFile", "Samples/$sampleName/resources/$dataFile" ) or warn "Cannot copy $dataFile: $!";
		}
	}
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant createDb" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestComposers" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestDirectors" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestCinematographers" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestEditors" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestWriters" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestProducers" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestActresses" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant ingestActors" ,VERBOSE_FLAG,ECHO_FLAG);
	# ($output, $errorlevel) = &runCommand( "ant ingestAll" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}


sub createIGLinkHunterSample
{
	my $sampleName = 'IGLinkHunterSample';
	my $output;
	my $errorlevel;
	
	chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	$ENV{'IG_HOME'} = IG_HOME;
	
	($output, $errorlevel) = &runCommand( "ant clean" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runInputGenerator" ,VERBOSE_FLAG,ECHO_FLAG);
	($output, $errorlevel) = &runCommand( "ant runAcceleratedIngest" ,VERBOSE_FLAG,ECHO_FLAG);
	
	print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	&runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	chdir '../..' or warn "Cannot change directory to the archive home: $!";
}

# TEMPLATE
# sub createIGGratefulSample
# {
	# my $sampleName = 'IGGratefulSample';
	# my $output;
	# my $errorlevel;
	
	# my $dataFile = 'graph-example-2.xml';
	# unless ( -e "Samples/$sampleName/resources/$dataFile" )
	# {
		# copy( "$dataFile", "Samples/$sampleName/resources/$dataFile" ) or warn "Cannot copy data file: $!";
	# }
	
	# chdir "Samples/$sampleName" or warn "Cannot change directory to $sampleName: $!";
	
	# $ENV{'IG_HOME'} = IG_HOME;
	
	# ($output, $errorlevel) = &runCommand( "ant" ,VERBOSE_FLAG,ECHO_FLAG);
	# ($output, $errorlevel) = &runCommand( "ant runCreateDb" ,VERBOSE_FLAG,ECHO_FLAG);
	# ($output, $errorlevel) = &runCommand( "ant runImport" ,VERBOSE_FLAG,ECHO_FLAG);
	
	# print "FD can be found in Samples/$sampleName/data\n" if not $errorlevel; #if successful
	# &runCommand( "mv data/*.* ../../". ARCHIVE_HOME . "/$sampleName" ,VERBOSE_FLAG,ECHO_FLAG) if not $errorlevel;
	
	# chdir '../..' or warn "Cannot change directory to the archive home: $!";
# }

1;