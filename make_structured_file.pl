#!/usr/local/perl-5.14.1/bin/perl
use strict;
use File::Path qw(mkpath);
use Data::Dumper;
use IO::File;
use Getopt::Long;
use English;
my %opt = (

	  );

GetOptions(\%opt,
	   "filename:s",
	   "mode:s",
	   "num_lines:s",
	   "edit_line:s",
	   "content:s",
	   "overwrite:s",
	   "debug:s",
	);

my $fh; # the filehandle of whatever file we're working with

my $debug = $opt{'debug'};
if (defined($opt{'debug'})) {
    print "before defaults applied\n";
    print Dumper(\%opt);
}

# # arg validation

# no matter what, we need a filename to work with, whether we're creating it
# or editing an existing one
 if (!defined($opt{'filename'})) {
     print "ERROR: filename not specified. exit.\n";
     exit 1;
 }




# # some combinations or lack of combinations of arguments don't make sense

# # You asked us to insert some content, but didn't say where and there's no sensible default
# if  ( !(defined($opt{'edit_line'})) and (defined($opt{'content'}))) {
#   print "ERROR: no edit_line specified but content specified, exit.\n";
#   exit 1;
# }

# # You asked us to to edit a line, but didn't say with what; use default content
# if  ( (defined($opt{'edit_line'}))) {
#   if (!defined($opt{'content'} ) ){
#     print "INFO: edit_line specified but no content, defaulting to \"blargh\"\n";
#     $opt{'content'} = "blargh";
#   }
#   if (defined($opt{'num_lines'})) {
#     print "INFO: both edit_line and num_lines specified; num_lines ignored\n";
#   }
      
# }



# # specifying an edit_line and either specifying content explicitly with --content
# # (or fallling int the default) case counts as "Having specified an edit" (see below)


# if ( (!defined($opt{'num_lines'}) ) and (!defined($opt{'edit_line'}))) {
#   $opt{'num_lines'} = 10;
#   print "INFO: num_lines not specified, defaulting to $opt{'num_lines'}\n";
# }

# if ($debug) {
#   print "After defaults applied\n";
#   print Dumper(\%opt);
# }

# # What about the file?

# # it exists, and you haven't specified an edit, must be asking to create; specify overwrite to continue if you haven't already

# # TODO: See below; this logic is missing from the conditional currently
# # it exists, and you have specified an edit, read the file and note its length (number of lines / 2, I guess?)
# # -- edit_line is less than or equal to the length of the file do the edit at edit_line and return the edited content
# # -- edit_line is greater than length of the file: 

# # it doesn't exist and you haven't specified an edit, must be asking to create; just create it.

# # it doesn't exist, but you have specified an edit; create the file with the edit at the specified line
# # it doesn't exist, but you have specified an edit;  but you also specified num_lines:
# # -- num_lines is less than edit_line; emit a warning, ignore num_lines and put the edit at edit_line instead? or just error
# # -- num_lines is greater than than edit_line; create the file with num_lines and the edit at edit_line
# # -- num lines is equal to edit_line; create the file with num_lines and the edit at edit_line, which happens to be num_line (duh!)

# # TODO:
# # The logic below is incomplete; we need to check if the file exists and 'edit is specified'; in that case we don't need overwrite; we just
# # make the edit. only if no 'edit is specified' and the file exists to we require --overwrite before (re)creating the file blank with the specified number of lines

# if (-e $opt{'filename'}) {
#   print "$opt{'filename'} exists";
# # if (no edit specified)
#   if (!defined($opt{'overwrite'})) {
#     print " re-run with --overwwrite=1 to overwrite existing file\n";
#   } else {
#     print " and overwrite specified, proceeding\n";
#   }
#   # else (edit specified)
#   # read the file

# } else {
#   print "INFO: $opt{'filename'} does not exist, creating with $opt{'num_lines'} lines\n";
#   my $fh = IO::File->new(">$opt{'filename'}");
#   my $file_hr = &create_content($opt{'num_lines'},undef,undef);
#   &write_content($fh,$file_hr);
# }

my $ret = &open_file($opt{'filename'},$opt{'mode'});

print Dumper($ret);

if (defined($ret->{"err"}))  {
  die "$ret->{'err'}";
}

if ($opt{mode} eq "create") {
  if  (!defined($opt{'num_lines'})) {
    $opt{'num_lines'} = 10;
    print "INFO: num_lines not specified, defaulting to $opt{'num_lines'}\n";
  }
  my $line_hr = &create_content($opt{'num_lines'});
  &write_content($ret->{"fh"},$line_hr);
}



sub open_file {
  # Given a filename and read/write mode; 
  # if asked to read and file doesn't exist, return error else return read fh
  # if asked to write and file does exist, return error else return write fh

  my $filename = shift;
  my $mode = shift;
  my $fh;
  my $err = undef;

  if ($mode eq "edit") {
    if (!(-e $filename)) {
      $err = "File $filename doesn't exist, cannot edit";
    } else {
      $fh = IO::File->new("<$filename") or ($err = "Failed to open $filename: $ERRNO\n")
    }
  } elsif ($mode eq "create") {
    if ((-e $filename)) {
      $err = "File $filename exists, cannot create, use --mode=edit instead";
    } else {
      $fh = IO::File->new(">$filename") or ($err = "Failed to open $filename: $ERRNO\n")
    }
  } else {
    return {"err"=>"Invalid mode","fh"=>undef};
  }

  return {"err"=>$err,"fh"=>$fh};

}


sub read_file {
  my $fh = shift;
  my $line_hr;


  return $line_hr
}

sub write_content{
  # Given a filehandle and a hashref of content, write
  # the hashref (in line number order) to the specified filehandle
  my $fh = shift;
  my $line_hr = shift;

  foreach my $idx (sort {$a <=> $b}  (keys(%{$line_hr}))) {
    print $fh $line_hr->{$idx};
  }
}

sub create_content {
# return a hash of lines of the specified size, possibly with content at the specified line
  my $num_lines = shift;
  my $edit_lines = shift;
  my $edit_content = shift;
  my $line_hr;

  my $idx;
  for $idx (1..($opt{'num_lines'})) {
    $line_hr->{$idx} = "$idx:\n$idx:-----\n";
  }

  return $line_hr;
  
}

# use on an existing line_hr read from existing file
sub edit_content {

  
}
