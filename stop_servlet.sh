#!/bin/sh

echo "stop servlet ... "


#AQUESTALK2_SVR_PID
echo "get AQUESTALK2_SVR_PID"
ps a|grep aquestalk2_servlet.ru |grep Sl|awk '{ print $1; }'>>pids
#JULIUS_SVR_PID
echo "get JULIUS_SVR_PID"
ps a|grep julius_servlet.ru |grep Sl|awk '{ print $1; }'>>pids
#JULIEST_SVR_PID
echo "get JULIEST_SVR_PID"
ps a|grep juliest_servlet.ru |grep Sl|awk '{ print $1; }'>>pids
#JULIUS_MOD_PID
echo "get JULIUS_MOD_PID"
ps a|grep julius |grep main|awk '{ print $1; }'>>pids

#cat pids

echo "pid kill"
while read line
do
  kill -9 $line
done <pids

rm -r pids

echo "done."

