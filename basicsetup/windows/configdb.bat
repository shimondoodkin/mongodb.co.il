:: configdb.bat ( same as a replica but without "--replSet myreplsetname" )
:: this file is used to Reinstall mongodb as service
:: this file is for configdb database

net stop MongoDBconfigdb
mkdir c:\mongodb\data\configdb
c:\mongodb\bin\mongod --remove --serviceName MongoDBconfigdb
c:\mongodb\bin\mongod --bind_ip 127.0.0.1,192.168.10.2 --port 27019 --logpath c:/mongodb/logs/configdb.log --logappend --dbpath c:/mongodb/data/configdb/ --directoryperdb --serviceName MongoDBconfigdb --serviceDisplayName MongoDBconfigdb --install
net start MongoDBconfigdb
