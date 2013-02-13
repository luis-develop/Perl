#!/bin/bash

echo $1

tshark -r $1 \
-d tcp.port==8868,diameter \
-R 'diameter&&diameter.Session-Id' \
-T fields -E header=y -E quote=d -E separator='|' \
-t e -o "column.format:Time,%t,XXXXXX,%Cus:XXXXXX" \
-e frame.time \
-e diameter.Event-Timestamp \
-e ip.src \
-e ip.dst \
-e diameter.Session-Id \
-e diameter.cmd.code \
-e diameter.flags.request \
-e diameter.CC-Request-Type \
-e diameter.CC-Request-Number \
-e diameter.GGSN-Address \
-e diameter.User-Name \
-e diameter.Result-Code  > csv.$1

#
# -t e -o "column.format:Time,%t,XXXXXX,%Cus:XXXXXX" \
# perl -ne 'print unless /^\s*$/' < foo | perl -ne 'print if /\s274\s/' |  perl -ne 'print if /.*1$/' | perl -ne 'print unless /.*[01],1$/' | sort > only-asr.txt
#
# time for file in pts*pcap*; do ./tshark.sh $file; done 
# echo -n > all-captures.0
# for file in csv*; do echo $file; grep -v Event $file >> all-captures.0; done
# sed -n -e 's/^\(.*,\)\"\([0-9]*\),\([0-9]*\)\"$/\1\"\2;\3\"/p' all-captures.2
#
# CREATE TABLE diameter_gy (Event_Timestamp TEXT, 
#                           Source_IP TEXT, 
#                           Destination_IP TEXT,
#                           Session_Id TEXT, 
#                           Command_Code NUMERIC,
#                           Request_Flag NUMERIC, 
#                           CC_Request_Type NUMERIC, 
#                           CC_Request_Number NUMERIC, 
#                           GGSN_Address TEXT, 
#                           User_Name TEXT, 
#                           Result_Code TEXT)
#
# tshark -r <file> -q -d tcp.port==8868,diameter -z diameter,avp,274,CC-Request-Type,CC-Request-Number,Session-Id,GGSN-Address,User-Name,Result-Code
# tshark -r <file> -q -d tcp.port==8868,diameter -z diameter,avp,'(272 or 274)',Event-Timestamp,CC-Request-Type,CC-Request-Number,Session-Id,GGSN-Address,User-Name,Result-Code 
# time for file in pts*pcap*; do echo $file; tshark -r $file -q -d tcp.port==8868,diameter -z diameter,avp,'(272 or 274)',Event-Timestamp,CC-Request-Type,CC-Request-Number,Session-Id,GGSN-Address,User-Name,Result-Code > stat.$file; done
#
# Following fields will be printed out for each diameter message:
#
#  "frame"        Frame number.
#  "time"         Unix time of the frame arrival.
#  "src"          Source address.
#  "srcport"      Source port.
#  "dst"          Destination address.
#  "dstport"      Destination port.
#  "proto"        Constant string 'diameter', which can be used for post processing of tshark output. e.g. grep/sed/awk.
#  "msgnr"        seq. number of diameter message within the frame. E.g. '2' for the third diameter message in the same frame.
#  "is_request"   '0' if message is a request, '1' if message is an answer.
#  "cmd"          diameter.cmd_code, E.g. '272' for credit control messages.
#  "req_frame"    Number of frame where matched request was found or '0'.
#  "ans_frame"    Number of frame where matched answer was found or '0'.
#  "resp_time"    response time in seconds, '0' in case if matched Request/Answer is not found in trace. E.g. in the begin or end of capture.
#
#
#
# rm -f all-non-2001-stats
# time for file in stat.pts1_long.pcap2*; do  perl -ne "print if /Result-Code/ and not /Result-Code='2001'/" < $file >> all-non-2001-stats; echo $file; done
#
# #!/usr/bin/env perl
# while (<>) {
#  s/\'//g;
#  %h = map { split("=") } grep { /=/ } split(" ");
#  printf("%s %s %s %s\n", $h{'time'}, $h{'cmd'}, $h{'resp_time'}, $h{'Result-Code'});
# } 
#
# time ./gen-lines.pl < all-non-2001-stats > summary-non-2001
# time cut -d' ' -f4 summary-non-2001 | sort -n | uniq -c
#
# time cat stat.pts1_long.pcap* > all.stats
# time grep "is_request='0'" all.stats > all.answers
# time ./gen-lines.pl < all.answers > answers.timestamps
#
# time cat stat.pts1_long.pcap* | grep "is_request='0'" | ./gen-lines.pl > answers.timestamps
#
# perl -alne 'print if $F[2] > 1.0' answers.timestamps
# 
# time cut -f2,10,13 -d' ' all.answers  | sed -e 's/time=//' -e 's/resp_time=//' -e "s/\'//g" > all.answers.epoch
# -- Need to correct time to compensate for local time zone
# time perl -alne ' my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime $F[0]; printf "%02d-%02d-%d %02d:%02d:%02d %s %f\n",$mday,$mon,$year+1900,$hour+2,$min,$sec,$F[1],$F[2] ' < all.answers.epoch > all.answers.daytime
# time sort all.answers.daytime > all.answers.daytime.sorted
# perl -alne 'print if $F[3] > 1' < all.answers.daytime.sorted | wc -l
#   39544
# time perl -alne 'print if $F[3] > 7' < all.answers.daytime.sorted | wc -l
# time perl -MList::Util=max -alne '$max = $F[3]; $rmax = $max unless defined $rmax && $max <= $rmax; END { print $rmax }' < all.answers.daytime.sorted 
#   15.818343
#
#
#
#
#
#


#
# ------
# setlocal
# set foo=
# for %%f in (*.pcap) do set foo=!foo! %%f
# mergecap -w all.pcap %foo%
# -------
#
 
