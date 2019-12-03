use strict;
use warnings;

my @keys = @ARGV;
my %hash;
$hash{$_} = 1 for @keys;
for my $key (keys %hash) {
  exit 1 if $key ne shift @keys;
}
exit 0;
