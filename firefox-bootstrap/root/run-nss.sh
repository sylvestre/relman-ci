set -e

cd /root/nss

rm -rf dist/

if test ! -d /root/nss/nspr; then
  hg clone https://hg.mozilla.org/projects/nspr nspr
else
  cd nspr && hg pull -u && cd -
fi

if test ! -d /root/nss/nss; then
  hg clone https://hg.mozilla.org/projects/nss nss
fi
cd /root/nss/nss

rm -rf cov-int

hg pull -u

#export PATH=$PATH:/opt/cov-analysis/bin/
export PATH=$PATH:/opt/cov-analysis-linux64-2018.12/bin

cov-configure --gcc

USE_64=1 cov-build --dir cov-int ./build.sh -c -v

cov-analyze --dir cov-int --all --strip-path="/root/nss"

sh /opt/cov-submit-nss.sh

