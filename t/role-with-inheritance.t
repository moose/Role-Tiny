use strict;
use warnings;
use Test::More;

{
  package R1;
  use Role::Tiny;
}
{
  package R2;
  use Role::Tiny;
}
{
  package C1;
  use Role::Tiny::With;
  with 'R1';
}
{
  package C2;
  use Role::Tiny::With;
  our @ISA=('C1');
  with 'R2';
}

ok Role::Tiny::does_role('C1','R1'), "Parent does own role";
ok !Role::Tiny::does_role('C1','R2'), "Parent does not do child's role";
ok Role::Tiny::does_role('C2','R1'), "Child does base's role";
ok Role::Tiny::does_role('C2','R2'), "Child does own role";

{
  package C3;
  our @ISA = qw(C1);
}
{
  package C4;
  our @ISA = qw(C2 C3);
}
is_deeply Role::Tiny::_get_linear_isa_dfs('C4'), ['C4', 'C2', 'C1', 'C3'],
  'dfs isa search is accurate';

done_testing();
