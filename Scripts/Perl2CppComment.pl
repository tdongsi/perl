# This script is to convert all the comments in the given file
# from the Perl-style comment (# comment) to C-style comment (/* comment */)
# USAGE
# perl Perl2CppComment.pl fileName
#
# See also: correctComment.pl for using this script to correct multiple files.

use strict;
$^I = ".bak";
while ( <> )
{
	# Any line with # at the beginning, followed by words and spaces, and ending with \n
	s"^#([\w\s+]+)\n$"/* $1 */\n";
	print;
}