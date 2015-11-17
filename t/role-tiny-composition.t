use strict;
use warnings;
use Test::More;

{
  package R1;
  use Role::Tiny;

  sub foo {}

  $INC{"R1.pm"} = __FILE__;
}

{
  package R2;
  use Role::Tiny;

  sub foo {}

  $INC{"R2.pm"} = __FILE__;
}

{
  package X;
  sub new {
      bless {} => shift
  }
}

eval { Role::Tiny->apply_roles_to_object(X->new, "R1", "R2") };
like $@,
  qr/^Method name conflict for 'foo' between roles 'R. and R2., cannot apply these simultaneously to an object/,
  'apply conflicting roles to object';

done_testing;
