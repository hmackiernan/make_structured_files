use TAP::Harness;
use Data::Dumper;
use strict;

my @files = <t/*.t>;

print Dumper(\@files);

my $harness = TAP::Harness->new();

$harness->runtests(@files);
