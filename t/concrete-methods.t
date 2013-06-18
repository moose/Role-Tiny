use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Fatal;

{
  package MyRole1;

  sub before_role {}

  use Role::Tiny;

  our $GLOBAL1 = 1;
  sub after_role {}
}

{
  package MyClass1;

  our $GLOBAL1 = 1;
  sub method {}
}

my $role_methods = Role::Tiny->_concrete_methods_of('MyRole1');
is_deeply([sort keys %$role_methods], ['after_role'],
  'only subs after Role::Tiny import are methods' );

my $class_methods = Role::Tiny->_concrete_methods_of('MyClass1');
is_deeply([sort keys %$class_methods], ['method'],
  'only subs from non-Role::Tiny packages are methods' );

done_testing;
