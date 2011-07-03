:: s1r1.bat (r=replica set) 
:: this file is used to Reinstall mongodb as service
:: this file is for s1r1 database
:: make sure you use forward slash "/" in mongod arguments

net stop MongoDBs1r1
mkdir c:\mongodb\data\s1r1
c:\mongodb\bin\mongod --remove --serviceName MongoDBs1r1
c:\mongodb\bin\mongod --bind_ip 127.0.0.1 --port 27018 --logpath c:/mongodb/logs/s1r1.log --logappend --dbpath c:/mongodb/data/s1r1/  --directoryperdb --replSet s1 --serviceName MongoDBs1r1  --serviceDisplayName MongoDBs1r1 --install
net start MongoDBs1r1
