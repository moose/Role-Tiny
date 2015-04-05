use strict;
use warnings;
use Test::More;
use lib 't/role-basic/lib';

use My::Example;
can_ok 'My::Example', 'no_conflict';
is +My::Example->no_conflict, 'My::Does::Basic::no_conflict',
    '... and it should return the correct value';

done_testing;
