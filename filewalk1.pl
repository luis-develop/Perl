#!/usr/bin/env perl -wT

use strict;
use File::Spec;


opendir my $DIR, "." or die "Can't open the current directory: $!\n";

my @names = readdir $DIR or die "Unable to read the current directory: $!\n";

foreach my $name (@names) {
    next if ($name eq ".");
    next if ($name eq "..");

    if (-d $name) {
      print "Found a directory: $name\n";
      next;
    }
    if ($name eq 'core') {
      print "Found core file: $name\n";
    }
}

