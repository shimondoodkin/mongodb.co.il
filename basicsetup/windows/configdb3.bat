:: configdb3.bat ( same as configdb.bat but to be run on the same computer under a different name )
:: this file is used to Reinstall mongodb as service
:: this file is for configdb3 database
:: make sure you use forward slash "/" in mongod arguments

net stop MongoDBconfigdb3
mkdir c:\mongodb\data\configdb3
c:\mongodb\bin\mongod --remove --serviceName MongoDBconfigdb3
c:\mongodb\bin\mongod --bind_ip 127.0.0.1 --port 27219 --logpath c:/mongodb/logs/configdb3.log --logappend --dbpath c:/mongodb/data/configdb3/ --directoryperdb --serviceName MongoDBconfigdb3 --serviceDisplayName MongoDBconfigdb3 --install
net start MongoDBconfigdb3
