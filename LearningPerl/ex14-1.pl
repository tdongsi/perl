######################################
# Chapter 14, pg. 213

sub big_money
{
	# The numerical money
	my ($number) = @_;
	# The string for printing money
	my $string = sprintf "%.2f", $number;
	
	# From right to left, add comma every 3 digits
	# A /g modifier will go from left to right
	'keep adding comma' while ( $string =~ s/^(-?\d+)(\d\d\d)/$1,$2/ );
	# Add the dollar sign after the minus sign if there is
	$string =~ s/^(-?)/$1\$/;
	
	return $string;
}

my $moneyString = big_money( 1025426353.296 );
print "Money string: $moneyString \n";
my $moneyString = big_money( -15000.25 );
print "Money string: $moneyString \n";


#####################
sub by_number
{
	# a sort subroutine
	if ($a < $b) {-1} elsif ($a > $b) {1} else {0}
}

sub by_number_too
{
	$a <=> $b;
}

sub by_case_insensitive
{
	"\L$a" cmp "\L$b";
}

my @result = sort by_number @numbers;