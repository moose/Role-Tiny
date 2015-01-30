use strict;
use warnings;
use Test::More;

{
  package Role; use Role::Tiny;
  sub foo { my $orig = shift; 1 + $orig->(@_) };
  package BaseClass; sub foo { 1 }
}

eval { Role::Tiny->create_class_with_roles('BaseClass', qw(Role Role)); };

like $@, qr/Duplicated/, 'duplicate role detected';

done_testing;
