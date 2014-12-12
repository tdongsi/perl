use strict;
use Cwd;

my $INSTALL_DIR = 'C:/objydev';
my $currentPath = getcwd;

chdir "$INSTALL_DIR/samples" or die "Cannot change directory: $!";

# Java sample
print "JAVA SAMPLES\n";
!system( "perl $currentPath/javaSampleRunner.pl") or die "Cannot run Perl script: $!";

# placementTutorial sample
print "PLACEMENT TUTORIAL SAMPLES\n";
!system( "perl $currentPath/sampleRunner.pl") or die "Cannot run Perl script: $!";

# objydb sample
# python sample
print "OBJYDB AND PYTHON SAMPLES\n";
!system( "perl $currentPath/otherSampleRunner.pl") or die "Cannot run Perl script: $!";

# SQL sample: Windows dependent on the Objy version installed
# Windows: nmake is used
print "SQL++ SAMPLES\n";
!system( "perl $currentPath/sqlSampleRunner.pl $INSTALL_DIR") or die "Cannot run Perl script: $!";