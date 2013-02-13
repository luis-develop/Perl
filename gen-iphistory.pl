#!/usr/bin/env perl

use Number::Format qw(:subs);
my @req = qw /null initial update terminate/;

while (<>) {
  s/\'//g;
  my @f = split / /;
  my @s = split /;/, $f[0];
  my $ipaddr = $s[3];
  my $reqtype = $f[1];
  my $epoch = $f[2];
  my $phone = $f[3];
  printf("%s %s %s %s\n", $phone, $ipaddr, $req[$reqtype], $epoch);
  $iphist{$phone}{$epoch}{$ipaddr} = $reqtype;
#  %h = map { split("=") } grep { /=/ } split(" "); 
#  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime $h{'time'}; 
#  printf "%02d-%02d-%d %02d:%02d:%02d %s %s %s\n", $mday, $mon, $year+1900, ($hour+2)%24, $min, $sec, $h{'cmd'}, $h{'resp_time'}, $h{'Result-Code'};
#  printf("%s %s %s %s\n", $h{'time'}, $h{'cmd'}, $h{'resp_time'}, $h{'Result-Code'});
#   if ($h{'User-Name'}) {
#     printf "%s %s %s %s %s \n", $h{'Session-Id'}, $h{'CC-Request-Type'}, $h{time}, $h{'User-Name'}, $h{'req_frame'};
#   } 
   # printf "%02d:%02d:%02d %s %s %s\n", ($hour+1.5)%24, $min, $sec, $h{'cmd'}, $h{'resp_time'}, $h{'Result-Code'}, $h{'Session-Id'};
#   $ccr{$h{'cmd'}}{$h{'Result-Code'}}++;
}
print "\n";
for $ph (keys %iphist) {
  print $ph, ":\n";
  for $t (sort keys %{ $iphist{$ph} }) {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime $t;
    my $lastip = "";
    my $laststatus = 0;
    $mon++;
    printf("\t%02d:%02d:%02d %02d-%02d-%d ", ($hour+1.5)%24, $min, $sec, $mday, $mon, $year+1900);
    for $ip (keys %{ $iphist{$ph}{$t} }) {
      my $r = $iphist{$ph}{$t}{$ip};
      if ($lastip eq "") {
        $lastip = $ip;
        $laststatus = $r;
      }
      if (($lastip ne $ip) && ($laststatus != 3)) {
         print "\t\t********* DUPLICATE SITUATION **********";
      }
      print "\t\t$ip: $req[$r]\n";
    }
  }
}
#$t=0;
#for $cmd ( keys %ccr ) {
#    print STDERR "$cmd => ";
#    for $rc ( keys %{ $ccr{$cmd} } ) {
#         printf STDERR "%d->%s ", $rc, format_number($ccr{$cmd}{$rc}, 9);
#         $t += $ccr{$cmd}{$rc};
#    }
#    print STDERR "\n";
#}
#printf STDERR "\nTotal = %12s responses\n", format_number($t);

