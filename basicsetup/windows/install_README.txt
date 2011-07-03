Mongodb Quick Installation Script

  1. copy all files from this folder to c:\mongodb\bin\
   
  2. change ip binding to your likening if required. 
     the ip can be several ips separated by comma
     in files:
       s1r1.bat
       s1r2.bat
       s1r3.bat
       configdb.bat
       configdb2.bat
       configdb3.bat
       mongos.bat
       
  3. you can use the computer name
     or validate your c:\Windows\System32\drivers\etc\hosts file
     that it contains your hostname as a name not localhost
     for example:
     web0     127.0.0.1
     
  4. change hostname in files: (search and replace web0 with your local hostname)    
       mongos.bat
       install.bat

  5. run install.bat 
     if you have made a mistake you can install.bat file again it will re-register the services

  6 Credits
     Created by Shimon Doodkin (http://doodkin.com)



Read install.sh
The scripts are simple you can modify it and bend it to your needs quickly.
I wrote it is intentionally in not a not DRY functions fashion
So it will by straight forward. I think you will be able fairly easily  
reconstruct this script in to a script of your needs.



plan:

all hosted on 127.0.0.1 one shard "s1"

mongod servers replica set "s1": web0:27018,web0:27020,web0:27021
config servers:                  web0:27019,web0:27119,web0:27219
mongos router:                   web0:27017

please note: this script doesn't configure how to shard a database
             if you need it later you can do it yourself 



This is a basic configuration and it is not much stable
To make it stable spread the parts to different computers.
A more stable configuration is like:

mongod servers replica set "s1": web0:27018,web0:27020-arbiter,web1:27018,web1:27020-arbiter
config servers:                  web0:27019,web1:27019,web0:27119
mongos router:                   web0:27017



snippets:

net stop mongos
net stop MongoDBconfigdb
net stop MongoDBconfigdb2
net stop MongoDBconfigdb3
net stop MongoDBs1r1
net stop MongoDBs1r2
net stop MongoDBs1r3

net start MongoDBs1r1
net start MongoDBs1r2
net start MongoDBs1r3
net start MongoDBconfigdb
net start MongoDBconfigdb2
net start MongoDBconfigdb3
net start mongos



Contribute to:
     https://github.com/shimondoodkin/mongodb.co.il/tree/master/basicsetup/

Israeli MongoDB website
     http://mongodb.co.il
