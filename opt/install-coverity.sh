VERSION=2017.07
rm -f cov-analysis
tar zxvf cov-analysis-linux64-$VERSION.tar.gz
ln -s cov-analysis-linux64-$VERSION cov-analysis
chown -R root. cov-analysis
find cov-analysis/ -type d -exec chmod 777 {} \;
find cov-analysis/ -type f -exec chmod og+w {} \;
