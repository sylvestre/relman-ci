source ~/checker_env/bin/activate
export PATH=~/codechecker_package/CodeChecker/bin:$PATH
CodeChecker server --postgresql --dbusername codechecker_user -u /var/lib/jenkins/workspace/firefox-codechecker/suppress.txt  --not-host-only

