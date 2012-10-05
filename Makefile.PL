use strict;
use warnings FATAL => 'all';
use 5.008001;
use ExtUtils::MakeMaker;
(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

my %BUILD_DEPS = (
  'Test::More' => 0.96,
  'Test::Fatal' => 0.003,
);

# have to do this since old EUMM dev releases miss the eval $VERSION line
my $mymeta_works = do { no warnings; $ExtUtils::MakeMaker::VERSION >= 6.5707 };

WriteMakefile(
  NAME => 'Role::Tiny',
  VERSION_FROM => 'lib/Role/Tiny.pm',
  PREREQ_PM => {
    ($] >= 5.010 ? () : ('MRO::Compat' => 0)),
    ($mymeta_works ? () : (%BUILD_DEPS)),
  },
  $mymeta_works ? (BUILD_REQUIRES => \%BUILD_DEPS) : (),

  META_ADD => {
    resources => {
      # r/w: gitmo@git.shadowcat.co.uk:Role-Tiny.git
      repository => 'git://git.shadowcat.co.uk/gitmo/Role-Tiny.git',
    },
  },

);
