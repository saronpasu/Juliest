#!/bin/sh

echo "stop servlet ... "


#AQUESTALK2_SVR_PID
echo "get SVR_PID"
ps a|grep servlet.ru |grep Sl|awk '{ print $1; }'>>pids
#ps a|grep julius_client |grep Sl|awk '{ print $1; }'>>pids
ps a|grep julius |grep Sl|awk '{ print $1; }'>>pids

#cat pids

echo "pid kill"
while read line
do
  kill -9 $line
done <pids

rm -r pids

echo "done."

