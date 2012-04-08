package Role::Tiny::Restricted;

use strict;
use warnings FATAL => 'all';
use base qw(Role::Tiny);

sub apply_union_of_roles_to_package {
  my ($me, $to, @roles) = @_;
  my %app = %{$Role::Tiny::APPLIED_TO{$to}||{}};
  delete $app{$to};
  if (%app) {
    require Carp;
    Carp::confess("with() may not be called more than once for $to");
  }
  $me->SUPER::apply_union_of_roles_to_package($to, @roles);
}

1;
