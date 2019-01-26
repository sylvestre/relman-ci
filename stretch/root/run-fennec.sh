set -e 
set -v
if test ! -d /root/fennec-coverity; then
hg clone https://hg.mozilla.org/mozilla-central/ /root/fennec-coverity
fi
cd /root/fennec-coverity
hg pull https://hg.mozilla.org/mozilla-central/ -u

rm -rf obj-arm-linux-androideabi cov-build.tar.gz cov-int/  obj-arm-linux-androideabi
export PATH=/var/lib/jenkins/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/cov-analysis/bin/:/var/lib/jenkins/.cargo/bin
echo "Cleanup previous report"
rm -rf reports/
rm -rf obj-arm-linux-androideabi cov-build.tar.gz cov-int/ objdir-frontend

echo "Cleanup"
./mach clobber

cat .mozconfig

echo "Rebuild all"
cov-configure --java --force-debug --xml-option=skip_file:"(\/tmp\/.*\.(cpp|cc|c))|(\/usr\/.*)|(mozilla\/.*)"
# Run the configure separatly to avoid issues detection here
JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee' ./mach --log-no-times configure
# Please see https://bit.ly/2Pb1GF7
export COVERITY_NO_PRELOAD_CLASSES=java.io.ObjectInputStream
cov-build --dir cov-int  ./mach --log-no-times build -v

tar zcvf cov-build.tar.gz cov-int/

#minimumsize=90000
minimumsize=80000

actualsize=
if [  -ge  ]; then
        sh /opt/upload-to-coverity-fennec.sh
else
	echo "Unexpected filesize. Should be at least  (found )"
	exit 1
fi

./mach clobber

rm -rf obj-arm-linux-androideabi cov-build.tar.gz cov-int/  obj-arm-linux-androideabi objdir-frontend
exit 0
