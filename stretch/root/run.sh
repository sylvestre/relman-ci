set -e
set -v

echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" > /etc/apt/sources.list.d/llvm-8.list
apt update
apt install -y clang-8

if test ! -d /root/firefox-coverity; then
hg clone https://hg.mozilla.org/mozilla-central/ /root/firefox-coverity
fi
cd /root/firefox-coverity
hg pull https://hg.mozilla.org/mozilla-central/ -u

rm -rf obj-x86_64-pc-linux-gnu/
rm -rf cov-int/
rm -rf cov-build.zip

export PATH=/var/lib/jenkins/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/cov-analysis/bin/:/var/lib/jenkins/.cargo/bin
#cargo install cbindgen --force

echo "Cleanup"
./mach clobber

cat > .mozconfig << EOF
ac_add_options --enable-debug
#ac_add_options --enable-linker=gold
ac_add_options --disable-av1
export CC=clang-8
export CXX=clang++-8

mk_add_options MOZ_MAKE_FLAGS="-j16"
EOF

rm -f third_party/rust/lalrpop/src/parser/lrgrammar.rs

echo "Rebuild all"
cov-configure --comptype clangcc --compiler clang-8
cov-configure --comptype clangcc --compiler clang++-8

cov-build --dir cov-int  ./mach --log-no-times build

zip -r cov-build.zip cov-int/

minimumsize=190000

actualsize=
if [  -ge  ]; then
	sh /opt/upload-to-coverity-fx.zip.sh
else
	echo "Unexpected filesize. Should be at least  (found )"
	exit 1
fi

rm -rf obj-x86_64-unknown-linux-gnu obj-x86_64-pc-linux-gnu
exit 0

