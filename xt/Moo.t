use strict;
use warnings;
use Test::More $ENV{EXTENDED_TESTING} ? ()
  : (skip_all => 'Set EXTENDED_TESTING to enable Moo testing');

use IPC::Open3;
use File::Spec;
use Config;

$ENV{PERL5LIB} = join $Config{path_sep}, @ARGV;

open my $in, '<', File::Spec->devnull
  or die "can't open devnull: $!";

my $pid = open3 $in, my $out, undef, $^X, '-MCPAN', '-e', 'test @ARGV', 'Moo';
my $output = do { local $/; <$out> };
close $out;
waitpid $pid, 0;

my $status = $?;
like $output, qr/--\s*OK\s*\z/,
  'Moo passed tests';

done_testing;
