use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Fatal;

BEGIN {
  plan skip_all => "Class::Method::Modifiers not installed"
    unless eval "use Class::Method::Modifiers; 1";
}

BEGIN {
  package MyRole;

  use Role::Tiny;

  around foo => sub { my $orig = shift; join ' ', 'role foo', $orig->(@_) };
}

BEGIN {
  package MyClass;

  sub foo { 'class foo' }
}

BEGIN {
  package BrokenRole;
  use Role::Tiny;

  around 'broken modifier' => sub { my $orig = shift; $orig->(@_) };
}

sub try_apply_to {
  my $to = shift;
  exception { Role::Tiny->apply_role_to_package($to, 'MyRole') }
}

is(try_apply_to('MyClass'), undef, 'role applies cleanly');
is(MyClass->foo, 'role foo class foo', 'method modifier');

ok(exception {
    my $new_class = Role::Tiny->create_class_with_roles('MyClass', 'BrokenRole');
}, 'exception caught creating class with broken modifier in a role');

done_testing;

