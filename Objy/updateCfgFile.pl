#!/usr/buildtools/bin/perl

use strict;
use Cwd;
use File::Copy;

my $cwd = cwd();
print "Updating cfg file in $cwd\n";

my $file = $ARGV[0];
print "File: $file\n";
open FILE, "< $file" or die "Cannot open $file: $!";
chomp( my @lines = <FILE> );
close FILE;

copy( $file, "$file.bak" ) or die "Faile to backup $file: $!";

open OUT, "> $file" or die "Cannot open $file: $!";

foreach my $line (@lines)
{
	# $line =~ s#host\.host1 .+#host.host1 = win732vs2010#;
	# $line =~ s#qadir\.host1 .+#qadir.host1 = $cwd/intelnt#;
	# $line =~ s#objydir\.host1 .+#objydir.host1 = Y:/release/R11_2_0#;
	
	$line =~ s#host\.host1 .+#host.host1 = rh5x64#;
	$line =~ s#qadir\.host1 .+#qadir.host1 = $cwd/linux86_64#;
	$line =~ s#objydir\.host1 .+#objydir.host1 = /dist/objydev#;
	
	print OUT "$line\n";
}

close OUT;