curl --form token=$(cat /opt/nss-pass.txt)   --form email=sylvestre@mozilla.com   --form file=@cov-build.tar.gz   --form version="$BUILD_ID"   --form description="Description"     https://scan.coverity.com/builds?project=nss

