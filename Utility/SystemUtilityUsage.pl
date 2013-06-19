use strict;
use SystemUtility;

my $VERBOSE_FLAG = 0;
my $ECHO_FLAG = 1;
my $output;
my $errorlevel;

# You can use runCommand to simulate a batch script
# It is recommended to use built-in Perl commands, such as chdir instead runCommand("cd")
chdir "Samples" or warn "Cannot change directory: $!";
($output, $errorlevel) = &runCommand( "javac HelloWorld.java" ,VERBOSE_FLAG,ECHO_FLAG);
($output, $errorlevel) = &runCommand( "java -cp . HelloWorld" ,VERBOSE_FLAG,ECHO_FLAG);
chdir '..' or warn "Cannot change directory to the archive home: $!";