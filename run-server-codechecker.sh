source ~/workspace/update-codechecker/venv/bin/activate
export PATH=/var/lib/jenkins/workspace/update-codechecker/build/CodeChecker/bin:$PATH
#CodeChecker server --postgresql --dbusername codechecker_user -u /var/lib/jenkins/workspace/firefox-codechecker/suppress.txt  --not-host-only
#CodeChecker server -w /var/lib/jenkins/.codechecker --postgresql --dbname codechecker --dbport 5432 --dbusername codechecker_user -u /var/lib/jenkins/workspace/firefox-codechecker/suppress.txt  --not-host-only
CodeChecker server -w /var/lib/jenkins/.codechecker --postgresql --dbname codechecker_config --dbport 5432 --dbusername codechecker_user   --not-host-only --verbose debug


