######################################
# Chapter 16, pg. 246
# TAGS: System

use strict;

print localtime()."\n";
my $date = localtime();

my @tokens = split " ", $date;
if ( $tokens[0] eq 'Sun' or $tokens[0] eq 'Sat' )
{
	print "Go play";
} else {
	print "Get to work\n";
}