use strict;
use File::Path qw(mkpath);
use Data::Dumper;
use IO::File;
use Getopt::Long;

my %opt = ();

GetOptions(\%opt,
	   "filename:s",
	   "num_lines:s",
	   "edit_line:s",
	   "content:s",
	   "overwrite:s",
	);

print Dumper(\%opt);



if (-e $opt{'filename'}) {
  print "$opt{'filename'} exists";
  if (!defined($opt{'overwrite'})) {
    print " re-run with --overwwrite=1 to overwrite existing file\n";
  } else {
    print " and overwrite specified, proceeding\n";
  }
} else {
  print "$opt{'filename'} does not exist, creating with $opt{'num_lines'} lines\n";
}


my $fh = IO::File->new(">$opt{'filename'}");
my $idx;
for $idx (1..($opt{'num_lines'})) {
  print $fh "$idx:\n";
  print $fh "$idx:-----\n";
  
}
