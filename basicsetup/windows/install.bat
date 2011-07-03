:::::::::::::::::::::::::::::::::::::::::::::::::::
::  Contribute to: https://github.com/shimondoodkin/mongodb.co.il/tree/master/basicsetup/
::  
::  Mongodb Quick Installation Script
::
::    1. copy all files from this folder to c:\mongodb\bin\
::
::    2. change ip binding to your likening if required. 
::       the ip can be several ips separated by comma
::       in files:
::         s1r1.bat
::         s1r2.bat
::         s1r3.bat
::         configdb.bat
::         configdb2.bat
::         configdb3.bat
::         mongos.bat
::
::    3. you can use the computer name
::       or validate your c:\Windows\System32\drivers\etc\hosts file
::       that it contains your hostname as a name not localhost
::       for example:
::       web0     127.0.0.1
::       
::    4. change hostname in files: (search and replace web0 with your local hostname)    
::         mongos.bat
::         install.bat
::     
::    5. run install.bat 
::       if you have made a mistake you can install.bat file again it will re-register the services
::  
::    6 Credits
::       Created by Shimon Doodkin (http://doodkin.com)
::

echo "start replica set for shard s1"
s1r1.bat
s1r2.bat
s1r3.bat
echo "initiate replica set, can take about 60 seconds"
c:\mongodb\bin\mongo web0:27018/admin --eval "rs.initiate({_id : 's1',members : [ {_id : 0, host : 'web0:27018'}, {_id : 1, host : 'web0:27020'}, {_id : 2, host : 'web0:27021', arbiterOnly:true } ]}).errmsg"
echo "start config databases"
configdb.bat
configdb2.bat
configdb3.bat
echo "start databases router"
mongos.bat
echo "initiate sharding with shard s1"
c:\mongodb\bin\mongo web0:27017/admin --eval "db.runCommand( { addshard : 's1/web0:27018,web0:27020' } ).errmsg"
