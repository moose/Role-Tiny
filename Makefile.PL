use strict;
use warnings FATAL => 'all';
use 5.006;
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
    Exporter => '5.57',
    ($] >= 5.010 ? () : ('MRO::Compat' => 0)),
    ($mymeta_works ? () : (%BUILD_DEPS)),
  },
  $mymeta_works ? (BUILD_REQUIRES => \%BUILD_DEPS) : (),

  -f 'META.yml' ? () : (META_MERGE => {
    'meta-spec' => { version => 2 },
    no_index => {
      directory => [ 'xt' ]
    },
    resources => {
      # r/w: gitmo@git.shadowcat.co.uk:Role-Tiny.git
      repository => {
        url => 'git://git.shadowcat.co.uk/gitmo/Role-Tiny.git',
        web => 'http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=gitmo/Role-Tiny.git',
        type => 'git',
      },
      bugtracker => {
          mailto => 'bug-Role-Tiny@rt.cpan.org',
          web => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Role-Tiny',
      },
    },
  }),
);
