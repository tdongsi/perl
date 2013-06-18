use strict;
use StringUtility;

# allSubstrings usage demo
my @subStrings = allSubstrings( 'Hello World', 4 );
foreach my $string (@subStrings)
{
	print "$string\n";
}
print "\n\n";


# reportProgress usage demo
reportProgress( 'Hello World' );

# wordWrap usage demo
my $message = "Hello Wonderful World";
my $sink = '';
$sink .= '*' x length($message);
$sink .= "\n$message\n";
$sink .= '*' x length($message);
$sink .= "\n";

print "\n\nBefore:\n$sink";

my $longProse = 'I see trees of green, red roses too. I see em bloom, for me and for you. And I think to myself, what a wonderful world.';

my $sink2 = wordWrap($sink, $longProse, 5, length($message)+1, 0 );
my $sink3 = wordWrap($sink, $longProse, 0, length($message)+1, 5 );

print "\nAfter:\n$sink2\n$sink3";