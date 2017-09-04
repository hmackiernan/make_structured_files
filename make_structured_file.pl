use strict;
use File::Path qw(mkpath);
use Data::Dumper;
use IO::File;
use Getopt::Long;

my %opt = (

	  );

GetOptions(\%opt,
	   "filename:s",
	   "num_lines:s",
	   "edit_line:s",
	   "content:s",
	   "overwrite:s",
	);

print "before defaults applied\n";
print Dumper(\%opt);

# arg validation
if (!defined($opt{'num_lines'})) {
  $opt{'num_lines'} = 10;
  print "INFO: num_lines not specified, defaulting to $opt{'num_lines'}\n";
}

if  ( !(defined($opt{'edit_line'})) and (defined($opt{'content'}))) {
  print "ERROR: no edit_line specified but content specified, exit.\n";
  exit 1;
}


if  ( (defined($opt{'edit_line'}) and (!defined($opt{'content'} )))) {
  $opt{'content'} = "blargh";
  print "INFO: edit_line specified but no content, defaulting to \"blargh\"\n";
}



print "After defaults applied\n";
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
