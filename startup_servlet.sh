#!/bin/sh

echo '/*===============================*/'
echo ''
echo 'start up servlet ... '
echo ''

bin/rackup -s puma rack/servlet.ru &
julius/bin/julius -C julius/main.jconf -C julius/am-dnn.jconf -input mic -module > /dev/null &
sleep 1
ruby bin/julius_client &

echo ' done.'
echo ''
echo 'startup servlet finish!'
echo ''
echo '/*===============================*/'

