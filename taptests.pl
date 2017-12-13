use TAP::Harness;
use Data::Dumper;
use strict;
use Getopt::Long;

my %opts;
GetOptions(\%opts,"verbose:s");

my @files = <t/*.t>;

print Dumper(\@files);

my %args = (
    "verbosity"=> defined($opts{'verbose'}),
    );
my $harness = TAP::Harness->new(\%args);

$harness->runtests(@files);
