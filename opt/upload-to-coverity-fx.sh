curl --insecure --form token=$(cat /opt/fx-pass.txt)   --form email=sylvestre@debian.org   --form file=@cov-build.tar.gz   --form version="$BUILD_ID"   --form description="Description"   https://scan.coverity.com/builds?project=Firefox

