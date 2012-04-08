use Test::More tests => 1;

BEGIN {
    use_ok( 'Role::Tiny::Restricted' ) || BAIL_OUT "Could not load Role::Tiny::Restricted: $!";
}

diag( "Testing Role::Tiny::Restricted $Role::Tiny::Restricted::VERSION, Perl $], $^X" );
