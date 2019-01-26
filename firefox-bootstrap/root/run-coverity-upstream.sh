set -e

if test ! -d /root/mozilla-central-upstream; then
  hg clone https://hg.mozilla.org/mozilla-central/ /root/mozilla-central-upstream
fi
cd /root/mozilla-central-upstream
hg pull -u

rm -rf obj-firefox/
rm -rf cov-int/

export PATH=$PATH:/opt/cov-analysis/bin/


echo "Cleanup"
./mach clobber

cat > .mozconfig <<EOF
ac_add_options --enable-debug
ac_add_options --enable-debug-symbols
ac_add_options --disable-optimize
# Until we will have nasm 2.13 or newer
ac_add_options --disable-av1

export CC=/root/.mozbuild/clang/bin/clang
export CXX=/root/.mozbuild/clang/bin/clang++
export LLVM_CONFIG=/root/.mozbuild/clang/bin/llvm-config

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/obj-firefox
mk_add_options MOZ_MAKE_FLAGS="-j16"
EOF

#cov-configure  --comptype clangcc --compiler /root/.mozbuild/clang/bin/clang
cov-configure  --clang
#cov-configure --gcc --force-debug
#cov-configure  --comptype clangcc --compiler clang-5.0

cov-build --dir cov-int  ./mach --log-no-times build -v
cov-analyze --dir cov-int --all

tar zcvf cov-build.tar.gz cov-int/

minimumsize=190000

actualsize=$(du -k cov-build.tar.gz | cut -f 1)
if [ $actualsize -ge $minimumsize ]; then
	sh /opt/upload-to-coverity-fx.sh
else
	echo "Unexpected filesize. Should be at least $minimumsize (found $actualize)"
	exit 1
fi
./mach clobber

#cov-build --dir cov-int  ./mach --log-no-times build

#cov-analyze --dir cov-int --all --strip-path=`pwd`
#sh /opt/cov-submit.sh


