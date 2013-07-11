use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Fatal;

my $backcompat_called;
{
  package RoleExtension;
  use base 'Role::Tiny';

  sub apply_single_role_to_package {
    my $me = shift;
    $me->SUPER::apply_single_role_to_package(@_);
    $backcompat_called++;
  }
}

{
  package Role1;
  $INC{'Role1.pm'} = __FILE__;
  use Role::Tiny;
  sub sub1 {}
}

{
  package Role2;
  $INC{'Role2.pm'} = __FILE__;
  use Role::Tiny;
  sub sub2 {}
}

{
  package Class1;
  RoleExtension->apply_roles_to_package(__PACKAGE__, 'Role1', 'Role2');
}

is $backcompat_called, 2,
  'overridden apply_single_role_to_package called for backcompat';

done_testing;
