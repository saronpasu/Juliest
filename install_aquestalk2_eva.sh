#!/bin/sh

WORK_DIR=`pwd`
UNAME=`uname`

echo '/*================================*/'
echo 'start install AquesTalk2 Eva'
echo ''

echo '=================================='
echo 'fetch AquesTalk2 Eva ... '
echo ''

# fetch AquesTalk2 Eva
wget http://www.a-quest.com/download/package/aqtk2-lnx-eva_230.zip

echo 'done.'
echo ''

echo 'fetch AqKanji2Koe Eva ... '
echo ''

# fetch AqKanji2Koe Eva
wget http://www.a-quest.com/download/package/aqk2k_lnx_eva_202.zip

echo 'done.'
echo '=================================='
echo ''


echo '=================================='
echo 'uncompless AquesTalk2 Eva ... '
echo ''

# uncompless AquesTalk2 Eva
unzip aqtk2-lnx-eva_230.zip

echo 'done.'
echo ''
echo 'uncompless AqKanji2Koe Eva ... '
echo ''

# uncompless AqKanji2Koe Eva
unzip aqk2k_lnx_eva_202.zip

echo 'done.'
echo '=================================='
echo ''

cd $WORK_DIR

echo '=================================='
echo 'copy AquesTalk2 Eva ... '
echo ''

# copy AquesTalk2 Eva
cd aqtk2-lnx-eva
cp lib64/libAquesTalk2Eva.so.2.3 $WORK_DIR/lib/

echo 'done.'
echo '=================================='
echo ''

echo '=================================='
echo 'copy AqKanji2Koe Eva ... '
echo ''

# copy AqKanji2Koe Eva
cd $WORK_DIR
mkdir dict
cd aqk2k_lnx_eva
cp -r aq_dic $WORK_DIR/dict/
cp lib64/libAqKanji2Koe.so.2.0 $WORK_DIR/lib/

echo 'done.'
echo '=================================='

cd $WORK_DIR

echo '=================================='
echo 'remove temp packages ... '
echo ''

# remove tempfile AquesTalk2 Eva
rm -rf aqtk2-lnx-eva
rm -r aqtk2-lnx-eva_230.zip
# remove tempfile AqKanji2Koe Eva
rm -rf aqk2k_lnx_eva
rm -r aqk2k_lnx_eva_202.zip

echo 'done.'
echo '=================================='
echo ''

echo 'install AquesTalk2 finish!'
echo '/*================================*/'


