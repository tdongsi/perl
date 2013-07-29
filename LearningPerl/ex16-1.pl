######################################
# Chapter 16, pg. 246
# TAGS: System

use strict;

my $dir = "test";

chdir $dir or die "Cannot change directory: $!";
system ( "dir" );
chdir ".." or die "Cannot change directory back";
