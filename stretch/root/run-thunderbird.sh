set -v
if test ! -d /root/thunderbird-coverity; then
hg clone https://hg.mozilla.org/mozilla-central/ /root/thunderbird-coverity
fi

cd /root/thunderbird-coverity
hg pull -u  https://hg.mozilla.org/mozilla-central/

if test ! -d comm; then
    hg clone https://hg.mozilla.org/comm-central comm/
else
    cd comm 
    hg pull https://hg.mozilla.org/comm-central 
    hg update
    cd ..
fi

export PATH=$PATH:/opt/cov-analysis/bin/:/var/lib/jenkins/.cargo/bin
cargo install cbindgen
echo "Cleanup previous build"
rm -rf obj-x86_64-unknown-linux-gnu cov-build.tar.gz cov-int/ obj-x86_64-pc-linux-gnu

echo "Cleanup previous report"
rm -rf reports/

python client.py checkout

echo "Cleanup"
./mach clobber

cat .mozconfig

cov-configure --gcc
cov-configure  --comptype clangcc --compiler clang-5.0

#--xml-option=skip_file:"(\/tmp\/.*\.(cpp|cc|c))|(\/usr\/.*)|(mozilla\/.*)"

# Run the configure separatly to avoid issues detection here
./mach  --log-no-times configure

echo "Rebuild all without coverity"
./mach --log-no-times build -v

echo "Touch all tb files to retrigger the build"
touch $(find comm/ -type f -iname '*.cpp' -o -iname '*.c')

echo "build only tb files using coverity"
cov-build --dir cov-int ./mach --log-no-times build -v

tar zcvf cov-build.tar.gz cov-int/

minimumsize=100000
actualsize=$(du -k cov-build.tar.gz | cut -f 1)
if [ $actualsize -ge $minimumsize ]; then
        sh /opt/upload-to-coverity.sh
else
	echo "Unexpected filesize. Should be at least $minimumsize (found $actualize)"
	exit 1
fi


#cd ..
#rm -rf obj-x86_64-unknown-linux-gnu cov-build.tar.gz cov-int/ obj-x86_64-pc-linux-gnu

exit 0
