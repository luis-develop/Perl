#!/usr/bin/env perl

use Number::Format qw(:subs);

while (<>) {
  s/\'//g;
  %h = map { split("=") } grep { /=/ } split(" "); 
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime $h{'time'}; 
#  printf "%02d-%02d-%d %02d:%02d:%02d %s %s %s\n", $mday, $mon, $year+1900, ($hour+2)%24, $min, $sec, $h{'cmd'}, $h{'resp_time'}, $h{'Result-Code'};
#  printf("%s %s %s %s\n", $h{'time'}, $h{'cmd'}, $h{'resp_time'}, $h{'Result-Code'});
   if ($h{'User-Name'}) {
     printf "%s %s %s %s %s \n", $h{'Session-Id'}, $h{'CC-Request-Type'}, $h{time}, $h{'User-Name'}, $h{'req_frame'};
   } 
   printf "%02d:%02d:%02d %s %s %s\n", ($hour+1.5)%24, $min, $sec, $h{'cmd'}, $h{'resp_time'}, $h{'Result-Code'}, $h{'Session-Id'};
   $ccr{$h{'cmd'}}{$h{'Result-Code'}}++;
}
print "\n";
$t=0;
for $cmd ( keys %ccr ) {
    print STDERR "$cmd => ";
    for $rc ( keys %{ $ccr{$cmd} } ) {
         printf STDERR "%d->%s ", $rc, format_number($ccr{$cmd}{$rc}, 9);
         $t += $ccr{$cmd}{$rc};
    }
    print STDERR "\n";
}
printf STDERR "\nTotal = %12s responses\n", format_number($t);


