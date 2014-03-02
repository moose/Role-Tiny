use strict;
use warnings FATAL => 'all';
use 5.006;

my %META = (
  name => 'Role-Tiny',
  license => 'perl_5',
  prereqs => {
    configure => { requires => {
      'ExtUtils::MakeMaker'   => 0,
    } },
    build => { requires => {
    } },
    test => { requires => {
      'Test::More' => 0.96,
      'Test::Fatal' => 0.003,
    } },
    runtime => {
      requires => {
        Exporter => '5.57',
        ($] >= 5.010 ? () : ('MRO::Compat' => 0)),
      },
      recommends => {
        'Class::Method::Modifiers' => 1.05,
      },
    },
    develop => { requires => {
      Moo => 0,
    } },
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
    x_IRC => 'irc://irc.perl.org/#moose',
    license => [ 'http://dev.perl.org/licenses/' ],
  },
  no_index => {
    directory => [ 't', 'xt' ]
  },
);

my %MM_ARGS = ();

##############################################################################
require ExtUtils::MakeMaker;
ExtUtils::MakeMaker->import;

(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

# have to do this since old EUMM dev releases miss the eval $VERSION line
my $eumm_version = eval $ExtUtils::MakeMaker::VERSION;
my $mymeta_works      = $eumm_version >= 6.57_07;
my $mymeta            = $eumm_version >= 6.57_02;
my $has_test_requires = $eumm_version >= 6.63_03;

my %configure_deps = %{$META{prereqs}{configure}{requires}};
my %build_deps     = %{$META{prereqs}{build}{requires}};
my %test_deps      = %{$META{prereqs}{test}{requires}};
my %run_deps       = %{$META{prereqs}{runtime}{requires}};

my $min_perl_version = delete $run_deps{perl};

if (not $has_test_requires) {
  %build_deps = (%build_deps, %test_deps);
  %test_deps = ();
}
if (not $mymeta_works) {
  %run_deps = (%run_deps, %build_deps);
  %build_deps = ();
}

(my $module_name = $META{name}) =~ s/-/::/g;
(my $module_file = "lib/$module_name.pm") =~ s{::}{/}g;

WriteMakefile(
  NAME => $module_name,
  VERSION_FROM => $module_file,
  LICENSE => $META{license},

  $eumm_version >= 6.47_01 && $min_perl_version
    ? ( MIN_PERL_VERSION    => $min_perl_version ) : (),
  $eumm_version >= 6.51_03
    ? ( CONFIGURE_REQUIRES  => \%configure_deps ) : (),
  $eumm_version >= 6.55_01
    ? ( BUILD_REQUIRES      => \%build_deps ) : (),
  $eumm_version >= 6.63_03
    ? ( TEST_REQUIRES       => \%test_deps ) : (),
  PREREQ_PM => \%run_deps,

  ($mymeta && !$mymeta_works ? (NO_MYMETA => 1) : ()),
  -f 'META.yml' ? () : (META_ADD => { 'meta-spec' => { version => 2 }, %META }),

  %MM_ARGS,
);
