use Test::Harness;
use Data::Dumper;

my @files = <t/*.t>;

print Dumper(\@files);

runtests(@files);
