package Role::Tiny::Restricted::With;

use strict;
use warnings FATAL => 'all';
use Role::Tiny::Restricted ();

use Exporter 'import';
our @EXPORT = qw( with );

sub with {
    my $target = caller;
    Role::Tiny::Restricted->apply_union_of_roles_to_package($target, @_)
}

1;
