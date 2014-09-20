#!/bin/sh

WORK_DIR=`pwd`
UNAME=`uname`

echo '/*================================*/'
echo 'start install julius'
echo ''

echo '=================================='
echo 'fetch julius ... '
echo ''

# fetch julius
wget http://jaist.dl.sourceforge.jp/julius/60273/julius-4.3.1.tar.gz

echo 'done.'
echo ''

echo 'fetch julius dictation-kit ... '
echo ''

# fetch julius-dictation-kit
wget http://jaist.dl.sourceforge.jp/julius/60416/dictation-kit-v4.3.1-linux.tgz

echo 'done.'
echo '=================================='
echo ''


echo '=================================='
echo 'uncompless julius ... '
echo ''

# uncompless julius
tar zxf julius-4.3.1.tar.gz

echo 'done.'
echo ''
echo 'uncompless julius-dictation-kit ... '
echo ''

# uncompless julius-dictation-kit
tar zxf dictation-kit-v4.3.1-linux.tgz

echo 'done.'
echo '=================================='
echo ''

cd $WORK_DIR
mkdir julius

echo '=================================='
echo 'configuration julius ... '
echo ''

cd julius-4.3.1
./configure --prefix=$WORK_DIR/julius --exec-prefix=$WORK_DIR/julius --with-mictype=alsa

echo 'done.'
echo '=================================='
echo ''

echo '=================================='
echo 'build julius ... '
echo ''

# build julius
make
make install

echo 'done.'
echo '=================================='


# move dictation-kit to julius
cd $WORK_DIR
cd dictation-kit-v4.3.1-linux
cp -rf model $WORK_DIR/julius/model
cp -r am-dnn.jconf $WORK_DIR/julius/am-dnn.jconf
cp -r main.jconf $WORK_DIR/julius/main.jconf

cd $WORK_DIR

echo '=================================='
echo 'remove temp packages ... '
echo ''

# remove tempfile julius
rm -rf julius-4.3.1
rm -r julius-4.3.1.tar.gz
# remove tempfile julius-dictation-kit
rm -rf dictation-kit-v4.3.1-linux
rm -r dictation-kit-v4.3.1-linux.tgz

echo 'done.'
echo '=================================='
echo ''

echo 'install julius finish!'
echo '/*================================*/'


