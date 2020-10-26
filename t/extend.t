use strict;
use warnings;
use Test::More;

my %apply_steps;
BEGIN {
  package MyRoleTinyExtension;
  use Role::Tiny;


  around role_application_steps => sub {
    my ($orig, $self) = (shift, shift);
    return (
      'role_apply_before',
      $self->$orig(@_),
      'Fully::Qualified::role_apply_after',
    );
  };

  sub role_apply_before {
    my ($self, $to, $role) = @_;
    ::ok !Role::Tiny::does_role($to, $role),
      "$role not applied to $to yet";
    $apply_steps{$to}{$role}{before}++;
  }
  sub Fully::Qualified::role_apply_after {
    my ($self, $to, $role) = @_;
    ::ok +Role::Tiny::does_role($to, $role),
      "$role applied to $to";
    $apply_steps{$to}{$role}{after}++;
  }
}

my $extension = Role::Tiny->create_class_with_roles('Role::Tiny', 'MyRoleTinyExtension');

{
  package ExtendedRole;
  $extension->import;

  sub added_sub {}
}

{
  package ApplyTo;
  $extension->apply_role_to_package(__PACKAGE__, 'ExtendedRole');
}

is $apply_steps{'ApplyTo'}{'ExtendedRole'}{before}, 1,
  'before step was run';

is $apply_steps{'ApplyTo'}{'ExtendedRole'}{after}, 1,
  'after step was run';

done_testing;
