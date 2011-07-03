:: s1r3.bat (r=replica set) 
:: this file is used to Reinstall mongodb as service
:: this file is for s1r3 database
:: make sure you use forward slash "/" in mongod arguments

net stop MongoDBs1r3
mkdir c:\mongodb\data\s1r3
c:\mongodb\bin\mongod --remove --serviceName MongoDBs1r3
c:\mongodb\bin\mongod --bind_ip 127.0.0.1 --port 27021 --logpath c:/mongodb/logs/s1r3.log --logappend --dbpath c:/mongodb/data/s1r3/  --directoryperdb --replSet s1 --serviceName MongoDBs1r3  --serviceDisplayName MongoDBs1r3 --install
net start MongoDBs1r3