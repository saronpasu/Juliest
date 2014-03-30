#!/bin/sh

echo '/*===============================*/'
echo ''
echo 'start up servlet ... '
echo ''

ruby bin/julius_client &
bin/rackup -s puma rack/servlet.ru &

echo ' done.'
echo ''
echo 'startup servlet finish!'
echo ''
echo '/*===============================*/'

