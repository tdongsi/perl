#
# TAGS: InputOutput

print "Enter the radius: ";
chomp($radius=<STDIN>);
$circumference = 2 * 3.14159 * $radius;
print $circumference;