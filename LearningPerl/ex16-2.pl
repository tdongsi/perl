######################################
# Chapter 16, pg. 246
# TAGS: System

use strict;

my $dir = "test";
open STDERR, "> ls.err" or die "Cannot open file: $!";
open STDOUT, "> ls.out" or die "Cannot open file: $!";


chdir $dir or die "Cannot change directory: $!";
system ( "dir" );
chdir ".." or die "Cannot change directory back";
