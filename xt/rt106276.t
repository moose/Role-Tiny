use strict;
use warnings;
use Test::More;

{
    package Web::ComposableRequest::Base;
    use Moo;
    has 'foo' => is => 'ro';
    package Web::ComposableRequest::Role::L10N;
    use Moo::Role;
    package Web::ComposableRequest::Role::Session;
    use Moo::Role;
    package Web::ComposableRequest::Role::Cookie;
    use Moo::Role;
    package Web::ComposableRequest::Role::JSON;
    use Moo::Role;
    package Web::ComposableRequest::Role::Static;
    use Moo::Role;
}

my $root  = 'Web::ComposableRequest';
my @roles = map { "${root}::Role::${_}" }
            'L10N', 'Session', 'Cookie', 'JSON', 'Static';
my $class = Moo::Role->create_class_with_roles( "${root}::Base", @roles );

eval { $class->new };

is $@, '', 'Package name usable by perl'
   or diag "Package: $class ".(length $class);

done_testing;
