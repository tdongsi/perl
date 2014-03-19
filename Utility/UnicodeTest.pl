#!/usr/buildtools/bin/perl

# This Perl script tests Unicode-compatibility of a command-line tool.
use strict;

##############################################################
# Unicode preamble
use utf8;      # so literals and identifiers can be in UTF-8
use warnings;  # on by default
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use charnames qw(:full :short);  # unneeded in v5.16

# Choose encoding scheme for the Perl source file: ANSI
# You may need to set the Windows locale to Chinese to see the command line displayed properly

# ANSI
# What you see is what you get. Same Chinese-named files created as in source code.
# Problem with regex matching of Chinese characters: "malformed regex" error.

# UTF-8
# Not the same Chinese file created. The only correct Chinese is in main.log.
# There is no "malformed regex" error. However, the correctly formed regex matching is now useless.

##############################################################

#MAIN

# Chinese names
# Using sing quote is recommended.
my $FDName = '你好世界';
my $nonExistent = '西瓜';
my $customSchema = '南瓜.txt'; # pumpkin 
my $folderName = '新年快乐'; # Happy New Year: tan nien khoai lac

# Test whatever you want with these Chinese name
