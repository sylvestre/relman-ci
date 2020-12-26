set -e
set -v

export PATH=/var/lib/jenkins/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/cov-analysis/bin/
if test ! -d /root/gcc-coverity; then
git clone https://github.com/gcc-mirror/gcc.git /root/gcc-coverity
fi
cd /root/gcc-coverity
git reset --hard origin/master
git pull

echo "Rebuild all"
cov-configure --gcc --xml-option=skip_file:"/tmp/*"
mkdir -p build-gcc
cd build-gcc
mkdir -p cov-int
# jit
../configure --with-gnu-as --with-gnu-ld --disable-bootstrap  --enable-languages=c,c++,fortran,lto,objc  --enable-host-shared

cov-build --dir cov-int make -j 7

tar zcvf cov-build.tar.gz cov-int/

minimumsize=160000
actualsize=
if [  -ge  ]; then
        sh /opt/upload-to-coverity-gcc.sh
else
	echo "Unexpected filesize. Should be at least  (found )"
	exit 1
fi
#rm -r cov-build.tar.gz cov-int/
make distclean||true

rm -rf ../build-gcc
exit 0

