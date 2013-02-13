#!/usr/bin/env perl
# lej 2013-01-15 Sandvine
# Usage: cidr.pl <file>

use strict;
use warnings;
# use Net::CIDR::Lite;
use Net::CIDR;

my @cidr_list = ();

while (<>) {
  if (/^\s*#/ or !/\S/) {
    print $_; 
    next;
  }
  print "# ADDING: $_";
  @cidr_list = Net::CIDR::cidradd($_, @cidr_list);
}

print "\n# Result By CIDRs:\n";
foreach my $c (@cidr_list) {
 print "# $c\n";
}

my @range_list = Net::CIDR::cidr2range(@cidr_list);
print "\n# Result By Ranges:\n";
foreach my $r (@range_list) {
 print "# $r\n";
}

my @octet_list = Net::CIDR::cidr2octets(@cidr_list);
print "\n# Result By Octets:\n";
foreach my $o (@octet_list) {
 my $pad = '.*' x (4-split '\.', $o);
 print "$o$pad\n";
}




