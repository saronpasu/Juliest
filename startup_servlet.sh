#!/bin/sh

echo '/*===============================*/'
echo ''
echo 'start up servlet ... '
echo ''
echo ' start AquesTalk2 servlet ... '

bin/rackup rack/aquestalk2_servlet.ru &

echo ' done.'
echo ''
echo ' start Julius servlet ... '

bin/rackup rack/julius_servlet.ru &

echo ' done.'
echo ''
echo ' start Juliest servlet ... '

bin/rackup rack/juliest_servlet.ru &

echo ' done.'
echo ''
echo 'startup servlet finish!'
echo ''
echo '/*===============================*/'

