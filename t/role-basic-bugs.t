#!/usr/bin/env perl

use lib 'lib', 't/role-basic/lib';
use MyTests;

# multiple roles with the same role
{
    package RoleC;
    use Role::Tiny::Restricted;
    sub baz { 'baz' }

    package RoleB;
    use Role::Tiny::Restricted;
    with 'RoleC';
    sub bar { 'bar' }

    package RoleA;
    use Role::Tiny::Restricted;
    with 'RoleC';
    sub foo { 'foo' }

    package Foo;
    use strict;
    use warnings;
    use Role::Tiny::Restricted 'with';
    ::is( ::exception {
        with 'RoleA', 'RoleB';
    }, undef, 'Composing multiple roles which use the same role should not have conflicts' );
    sub new { bless {} => shift }

    my $object = Foo->new;
    foreach my $method (qw/foo bar baz/) {
        ::can_ok $object, $method;
        ::is $object->$method, $method,
          '... and all methods should be composed in correctly';
    }
}

{
    no warnings 'redefine';
    local *UNIVERSAL::can = sub { 1 };
    eval <<'    END';
    package Can::Can;
    use Role::Tiny::Restricted 'with';
    with 'A::NonExistent::Role';
    END
    my $error = $@ || '';
    like $error, qr{^Can't locate A/NonExistent/Role.pm},
        'If ->can always returns true, we should still not think we loaded the role'
            or diag "Error found: $error";
}

done_testing;
