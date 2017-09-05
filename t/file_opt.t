use Test::More;
use strict;
my $ret = `make_structured_file.pl --filename=beep.txt`;
print $ret;

like $ret, qr/INFO: num_lines not specified, defaulting to 10/, "Default lines";
like $ret, qr/INFO: beep.txt does not exist, creating with 10 lines/, "Create nonexistent file";
ok (-e "beep.txt", "file 'beep.txt' created");

unlink "beep.txt";

done_testing();
