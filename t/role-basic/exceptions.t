#!/usr/bin/env perl

use lib 'lib', 't/role-basic/lib';
use MyTests;
require Role::Tiny::Restricted;

{
    package My::Does::Basic;

    use Role::Tiny::Restricted;

    requires 'turbo_charger';

    sub conflict {
        return "My::Does::Basic::conflict";
    }
}

eval <<'END_PACKAGE';
package My::Bad::MultipleWith;
use Role::Tiny::Restricted::With;
with 'My::Does::Basic';
with 'My::Does::Basic';  # can't use with() more than once
sub turbo_charger {}
END_PACKAGE
like $@,
  qr/with\(\) may not be called more than once for My::Bad::MultipleWith/,
  'Trying to use with() more than once in a package should fail';

eval <<'END_PACKAGE';
package My::Bad::Requirement;
use Role::Tiny::Restricted::With;
with 'My::Does::Basic'; # requires turbo_charger
END_PACKAGE
like $@,
qr/missing turbo_charger/,
  'Trying to use a role without providing required methods should fail';

{
    {
        package My::Conflict;
        use Role::Tiny::Restricted;
        sub conflict {};
    }
    eval <<'    END_PACKAGE';
    package My::Bad::MethodConflicts;
    use Role::Tiny::Restricted::With;
    with qw(My::Does::Basic My::Conflict);
    sub turbo_charger {}
    END_PACKAGE
    like $@,
    qr/.*/,
      'Trying to use multiple roles with the same method should fail';
}


{
    {
        package Role1;
        use Role::Tiny::Restricted;
        requires 'missing_method';
        sub method1 { 'method1' }
    }
    {
        package Role2;
        use Role::Tiny::Restricted;
        with 'Role1';
        sub method2 { 'method2' }
    }
    eval <<"    END";
    package My::Class::Missing1;
    use Role::Tiny::Restricted::With;
    with 'Role2';
    END
    like $@,
    qr/missing missing_method/,
      'Roles composed from roles should propogate requirements upwards';
}
{
    {
        package Role3;
        use Role::Tiny::Restricted;
        requires qw(this that);
    }
    eval <<"    END";
    package My::Class::Missing2;
    use Role::Tiny::Restricted::With;
    with 'Role3';
    END
    like $@,
    qr/missing this, that/,
      'Roles should be able to require multiple methods';
}

done_testing;
