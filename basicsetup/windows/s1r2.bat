:: s1r2.bat (r=replica set) 
:: this file is used to Reinstall mongodb as service
:: this file is for s1r2 database

net stop MongoDBs1r2
mkdir c:\mongodb\data\s1r2
c:\mongodb\bin\mongod --remove --serviceName MongoDBs1r2
c:\mongodb\bin\mongod --bind_ip 127.0.0.1,192.168.10.2 --port 27020 --logpath c:/mongodb/logs/s1r2.log --logappend --dbpath c:/mongodb/data/s1r2/  --directoryperdb --replSet s1 --serviceName MongoDBs1r2  --serviceDisplayName MongoDBs1r2 --install
net start MongoDBs1r2