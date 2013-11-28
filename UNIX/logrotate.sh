# manually logrotate eg. Catalina.out while server is running
# May have some dataloss, but better than disk running too full

rotfile=catalina.out; cat $rotfile | gzip -9v -c > $rotfile.$(date +%Y-%m-%d).gz; echo "" > $rotfile
