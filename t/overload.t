use strict;
use warnings FATAL => 'all';
use Test::More;

BEGIN {
  package MyRole;
  use Role::Tiny;

  sub as_string { "welp" }
  sub as_num { 219 }
  use overload
    '""' => \&as_string,
    '0+' => 'as_num',
    bool => sub(){1},
    fallback => 1;
}

BEGIN {
  package MyClass;
  use Role::Tiny::With;
  with 'MyRole';
  sub new { bless {}, shift }
}

my $o = MyClass->new;
is "$o", 'welp', 'subref overload';
is 0+$o, 219, 'method name overload';
ok !!$o, 'anon subref overload';

done_testing;
