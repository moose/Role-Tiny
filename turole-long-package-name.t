use strict;
use warnings;
use Test::More;

# using Role::Tiny->apply_roles_to_object with too many roles,
# It makes 'Identifier too long' error in string 'eval'.
# And, Moo uses string eval.
{
    package R::AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
    use Role::Tiny;
    package R::BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB;
    use Role::Tiny;
    package R::CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC;
    use Role::Tiny;
    package R::DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD;
    use Role::Tiny;
    package R::EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE;
    use Role::Tiny;
}

{
    package Foo;
    sub new { bless {}, shift }
}

my $foo = Foo->new();
for (qw(
    R::AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    R::BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
    R::CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
    R::DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
    R::EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
)) {
    Role::Tiny->apply_roles_to_object($foo, $_);
}

my $pkg = ref $foo;
eval "package $pkg;";
is $@, '', 'package name usable by perl'
  or diag "package: $pkg";

done_testing;
