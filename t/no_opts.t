use Test::More;
use strict;
my $ret = `make_structured_file.pl`;
like $ret, qr/ERROR\: filename not specified\. exit\./;

done_testing();
