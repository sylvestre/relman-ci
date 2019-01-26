set -e
set -v
if test ! -d /root/firefox-coverity; then
hg clone https://hg.mozilla.org/mozilla-central/ /root/firefox-coverity
fi
cd /root/firefox-coverity
hg pull https://hg.mozilla.org/mozilla-central/ -u

rm -rf obj-x86_64-pc-linux-gnu/
rm -rf cov-int/
rm -rf cov-build.tar.gz
export PATH=/var/lib/jenkins/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/cov-analysis/bin/:/var/lib/jenkins/.cargo/bin
# cargo install cbindgen

echo "Cleanup"
./mach clobber

cat > .mozconfig << EOF
ac_add_options --enable-debug
ac_add_options --disable-av1
export CC=clang-5.0
export CXX=clang++-5.0
export CXXFLAGS="-I/usr/include/c++/6/ -I/usr/include/x86_64-linux-gnu/c++/6/ -I/usr/include/c++/6/backward/"
mk_add_options MOZ_MAKE_FLAGS="-j16"
EOF

echo "Rebuild all"
cov-configure --gcc --force-debug
cov-configure  --comptype clangcc --compiler clang-5.0

#cov-build --dir cov-int  ./mach --log-no-times build -v
cov-build --dir cov-int  ./mach --log-no-times build
cov-analyze --dir cov-int --all

tar zcvf cov-build.tar.gz cov-int/

minimumsize=190000

actualsize=
if [  -ge  ]; then
	sh /opt/upload-to-coverity-fx.sh
else
	echo "Unexpected filesize. Should be at least  (found )"
	exit 1
fi

rm -rf obj-x86_64-unknown-linux-gnu obj-x86_64-pc-linux-gnu
exit 0

