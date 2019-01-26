source ~/workspace/update-codechecker/venv/bin/activate
export PATH=/var/lib/jenkins/workspace/update-codechecker/build/CodeChecker/bin:$PATH
CodeChecker server -w /var/lib/jenkins/.codechecker --postgresql --dbname codechecker_config --dbport 5432 --dbusername codechecker_user   --not-host-only


