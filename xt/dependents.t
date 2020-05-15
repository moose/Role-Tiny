use strict;
use warnings;

my $v;
my $doit;
my @dists;
BEGIN {
  # this won't run by default anyway, so just display the full content so Travis
  # doesn't abort due to lack of output.
  $v = 1;
  $doit = $ENV{EXTENDED_TESTING};

  while (@ARGV) {
    my $arg = shift @ARGV;
    if ($arg eq '--') {
      push @dists, @ARGV;
      last;
    }
    elsif ($arg =~ /\A(?:-v|--verbose)\z/) {
      $v = 1;
    }
    elsif ($arg =~ /\A(?:-q|--quiet)\z/) {
      $v = 0;
    }
    elsif ($arg =~ /\A(?:--doit)\z/) {
      $doit = 1;
    }
    elsif ($arg =~ /\A-/) {
      die "Unsupported option $arg!\n";
    }
    else {
      push @dists, $arg;
    }
  }

  if (!@dists && $doit) {
    @dists = (
      'MSTROUT/Moo-0.009002.tar.gz', # earliest working version
      'MSTROUT/Moo-1.000000.tar.gz',
      'MSTROUT/Moo-1.000008.tar.gz',
      'HAARG/Moo-1.007000.tar.gz',
      'HAARG/Moo-2.000000.tar.gz',
      'HAARG/Moo-2.001000.tar.gz',
      'Moo',
      'namespace::autoclean',
      'Dancer2',
      'MooX::Options',
    );
  }
}

use Test::More
  @dists ? (tests => scalar @dists)
         : (skip_all => 'Set EXTENDED_TESTING to enable dependents testing');
use IPC::Open3;
use File::Spec;
use Cwd qw(abs_path);
use Config;

delete $ENV{AUTHOR_TESTING};
delete $ENV{EXTENDED_TESTING};
delete $ENV{RELEASE_TESTING};
$ENV{NONINTERACTIVE_TESTING} = 1;
$ENV{PERL_MM_USE_DEFAULT} = 1;
delete $ENV{HARNESS_PERL_SWITCHES};

my @extra_libs = do {
  my @libs = `"$^X" -le"print for \@INC"`;
  chomp @libs;
  my %libs; @libs{@libs} = ();
  map { Cwd::abs_path($_) } grep { !exists $libs{$_} } @INC;
};
$ENV{PERL5LIB} = join($Config{path_sep}, @extra_libs, $ENV{PERL5LIB}||());

open my $in, '<', File::Spec->devnull
  or die "can't open devnull: $!";

sub find_hash_seed {
  my $hash_seed;
  for my $seed (0 .. 2**10) {
    my $hash_seed = "$]" >= 5.017006 ? sprintf "%x", $seed : $seed;
    local $ENV{PERL_PERTURB_KEYS} = 0;
    local $ENV{PERL_HASH_SEED} = $hash_seed;
    if (0 == system $^X, 'xt/check-hash-order.pl', @_) {
      return $hash_seed;
    }
  }
  return undef;
}

my $ext = qr{\.(?:t(?:ar\.)?(?:bz2|xz|gz)|tar|zip)};
for my $dist (@dists) {
  note "Testing $dist ...";

  my $hash_seed;

  # tests in some older Moo are sensitive to hash key order.  force one that
  # works, since we still want to run the rest of the tests.  hash
  # implementation can change, so search for a value that works like we want.
  if ($dist =~ m{\bMoo-0\.00900[2-7]\b}) {
    $hash_seed = find_hash_seed('one', 'two');
  }

  diag "Forcing hash seed $hash_seed for $dist" if defined $hash_seed;
  local $ENV{PERL_HASH_SEED} = $hash_seed if defined $hash_seed;
  local $ENV{PERL_PERTURB_KEYS} = '0' if defined $hash_seed;

  my $name = $dist;
  $name =~ s{$ext$}{}
    if $name =~ m{/};
  my $pid = open3 $in, my $out, undef, $^X, '-MCPAN', '-e', 'test @ARGV', $dist;
  my $output = '';
  while (my $line = <$out>) {
    $output .= $line;
    diag $line
      if $v;
  }
  close $out;
  waitpid $pid, 0;

  my $status = $?;

  if ($dist !~ m{/}) {
    $output =~ m{^Configuring (.)/(\1.)/(\2.*)$ext\s}m
      and $name = "$3 (latest)";
  }

  local $TODO = "distroprefs interfered with prereq installation"
    if $output =~ /Disabled via prefs file/;

  my $passed = $output =~ /--\s*OK\s*\z/ && $output !~ /--\s*NOT\s+OK\s*\z/;
  ok $passed, "$name passed tests";
  diag $output
    if !$passed && !$v;
}

done_testing;
