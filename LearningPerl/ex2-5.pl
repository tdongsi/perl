print "Enter the string: ";
$inputString = <STDIN>; # do not remove the newline character
print "Enter the number: ";
chomp( $number = <STDIN> );

print $inputString x $number;