#!/usr/bin/env perl

#use Net::CIDR::Lite;
use Net::CIDR;


#my $cidr = Net::CIDR::Lite->new;
#$cidr->add('186.185.128.0/17');
#@cidr_list = $cidr->list;
#@ip_ranges = $cidr->list_range;
#print @cidr_list;

# @a=Net::CIDR::cidr2range("10.0.0.0/14", "192.68.0.0/24");
# @range_list=Net::CIDR::cidr2range(@cidr_list);
# @octet_list=Net::CIDR::cidr2octets(@cidr_list);
# @cidr_list=Net::CIDR::cidradd("10.0.0.0/8", @cidr_list);

my @cidr_list = ();

while (<>) {
  next if /#/ or /^$/;
  print "adding range: $_";
  @cidr_list = Net::CIDR::cidradd($_, @cidr_list);
}

print "\nBy CIDRs\n";
foreach $x (@cidr_list) {
 print $x, "\n";
}

my @range_list=Net::CIDR::cidr2range(@cidr_list);

print "\nBy Ranges\n";
foreach $x (@range_list) {
 print $x, "\n";
}

@octet_list=Net::CIDR::cidr2octets(@cidr_list);

print "\nBy Octets\n";
foreach $x (@octet_list) {
 $y = '.*' x (4-split '\.', $x);
 print "$x$y\n";
}




