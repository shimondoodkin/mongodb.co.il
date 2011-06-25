:: configdb2.bat ( same as configdb.bat but to be run on the same computer under a different name )
:: this file is used to Reinstall mongodb as service
:: this file is for configdb2 database

net stop MongoDBconfigdb2
mkdir c:\mongodb\data\configdb2
c:\mongodb\bin\mongod --remove --serviceName MongoDBconfigdb2
c:\mongodb\bin\mongod --bind_ip 127.0.0.1,192.168.10.2 --port 27119 --logpath c:/mongodb/logs/configdb2.log --logappend --dbpath c:/mongodb/data/configdb2/ --directoryperdb --serviceName MongoDBconfigdb2 --serviceDisplayName MongoDBconfigdb2 --install
net start MongoDBconfigdb2


