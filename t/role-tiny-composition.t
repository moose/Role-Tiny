use strictures 1;
use Test::More;
use Test::Fatal;

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

ok(exception { Role::Tiny->apply_roles_to_object(X->new, "R1", "R2") }, 'apply conflicting roles to object');

done_testing;
