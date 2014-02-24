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
    bool => sub(){0},
    fallback => 1;
}

BEGIN {
  package MyClass;
  use Role::Tiny::With;
  with 'MyRole';
  sub new { bless {}, shift }
}

BEGIN {
  package MyClass2;
  use overload
    fallback => 0,
    '""' => 'class_string',
    '0+' => sub { 42 },
    ;
  use Role::Tiny::With;
  with 'MyRole';
  sub new { bless {}, shift }
  sub class_string { 'yarp' }
}

{
  my $o = MyClass->new;
  is "$o", 'welp', 'subref overload';
  is sprintf('%d', $o), 219, 'method name overload';
  ok !$o, 'anon subref overload';
}

{
  my $o = MyClass2->new;
  eval { my $f = 0+$o };
  like $@, qr/no method found/, 'fallback value not overwritten';
  is "$o", 'yarp', 'method name overload not overwritten';
  is sprintf('%d', $o), 42, 'subref overload not overwritten';
}

done_testing;
