use strict;
use Cwd;

my $INSTALL_DIR = 'C:/objy';
my $currentPath = getcwd;

chdir "$INSTALL_DIR/samples" or die "Cannot change directory: $!";

# Java sample
!system( "perl $currentPath/javaSampleRunner.pl") or die "Cannot run Perl script: $!";

# placementTutorial sample
!system( "perl $currentPath/sampleRunner.pl") or die "Cannot run Perl script: $!";

# objydb sample
# python sample
!system( "perl $currentPath/otherSampleRunner.pl") or die "Cannot run Perl script: $!";

# SQL sample: Windows dependent on the Objy version installed
# Windows: nmake is used
!system( "perl $currentPath/sqlSampleRunner.pl $INSTALL_DIR") or die "Cannot run Perl script: $!";