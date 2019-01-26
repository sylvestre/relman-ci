set -e

if test ! -d /root/mozilla-central; then
  hg clone https://hg.mozilla.org/mozilla-central/ /root/mozilla-central
fi
cd /root/mozilla-central
hg pull -u

rm -rf obj-firefox/
rm -rf cov-int/

export PATH=$PATH:/opt/cov-analysis/bin/


echo "Cleanup"
./mach clobber

#cov-configure  --comptype clangcc --compiler /root/.mozbuild/clang/bin/clang
cov-configure --clang
cov-configure --javascript

# Only capture browser for now as the full fails with an OOM
cov-build --dir cov-int  --fs-capture-search=toolkit/ --fs-capture-search=services/ --fs-capture-search=browser/ --fs-capture-search-exclude-regex ".*/test" ./mach --log-no-times build
cov-analyze --dir cov-int --all --strip-path=`pwd`
sh /opt/cov-submit.sh
./mach clobber

