curl --form token=$(cat /opt/gcc-pass.txt)   --form email=sylvestre@debian.org   --form file=@cov-build.tar.gz   --form version="$BUILD_ID"   --form description=""   https://scan.coverity.com/builds?project=gcc

