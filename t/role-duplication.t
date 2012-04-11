use strictures 1;
use Test::More;

{
  package Role; use Role::Tiny;
  around foo => sub { my $orig = shift; 1 + $orig->(@_) };
  package Base; sub foo { 1 }
}

eval { Role::Tiny->create_class_with_roles('Base', qw(Role Role)); };

like $@, 'Duplication', 'duplicate role detected';

done_testing;
