use Test::More tests => 1;

BEGIN {
    use_ok( 'Role::Tiny' ) || BAIL_OUT "Could not load Role::Tiny: $!";
}

diag( "Testing Role::Tiny $Role::Tiny::VERSION, Perl $], $^X" );
