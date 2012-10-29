use strictures 1;
use Test::More;

BEGIN {
  plan skip_all => "Class::Method::Modifiers not installed"
    unless eval "use Class::Method::Modifiers; 1";
}

{
  package One; use Role::Tiny;
  around foo => sub { my $orig = shift; (__PACKAGE__, $orig->(@_)) };
  package Two; use Role::Tiny;
  around foo => sub { my $orig = shift; (__PACKAGE__, $orig->(@_)) };
  package Three; use Role::Tiny;
  around foo => sub { my $orig = shift; (__PACKAGE__, $orig->(@_)) };
  package Four; use Role::Tiny;
  around foo => sub { my $orig = shift; (__PACKAGE__, $orig->(@_)) };
  package Base; sub foo { __PACKAGE__ }
}

foreach my $combo (
  [ qw(One Two Three Four) ],
  [ qw(Two Four Three) ],
  [ qw(One Two) ]
) {
  my $combined = Role::Tiny->create_class_with_roles('Base', @$combo);
  is_deeply(
    [ $combined->foo ], [ reverse(@$combo), 'Base' ],
    "${combined} ok"
  );
  my $object = bless({}, 'Base');
  Role::Tiny->apply_roles_to_object($object, @$combo);
  is(ref($object), $combined, 'Object reblessed into correct class');
}

done_testing;
