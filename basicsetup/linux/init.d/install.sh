#!/bin/sh
##################################################
#  Contribute to: https://github.com/shimondoodkin/mongodb.co.il/tree/master/basicsetup/
#  
#  Mongodb Quick Installation Script
#
#    1. change ip binding to your likening if required. 
#       the ip can be several ips separated by comma
#       in files:
#         mongodbs1r1
#         mongodbs1r2
#         mongodbs1r3
#         mongodbconfigdb
#         mongodbconfigdb2
#         mongodbconfigdb3
#    2. validate your /etc/hosts file
#       that it contains your hostname as a name not localhost
#       for example:
#       web0     127.0.0.1
#       
#    3. change hostname in files: (search and replace web0 with your local hostname)    
#         mongos
#         install.sh
#     
#    4. run install.sh 
#       if you have made a mistake you can uninstall and install again
#  
#    5 Credits
#       Created by Shimon Doodkin (http://doodkin.com)
#

DO_INSTALL=0

echo "What do you wish to do?"
select yn in "Uninstall" "Install"; do
case $yn in
 Uninstall ) DO_INSTALL=1 break;;
 Install )   DO_INSTALL=2 break;;
esac
done

##################################################
# installation steps
if [ $DO_INSTALL = 2 ] ; then

echo "copy init.d scripts to to /etc/init.d/";
cp -i mongodbs1r1 mongodbs1r2 mongodbs1r3 mongodbconfigdb mongodbconfigdb2 mongodbconfigdb3 mongos /etc/init.d/

echo "remove current mongodb from autostarting on boot  ...";
/etc/init.d/mongodb stop 
update-rc.d -f mongodb remove 

echo "add init.d scripts to autostart on boot "
# make scripts autostart on boot
update-rc.d -f mongodbs1r1 defaults
update-rc.d -f mongodbs1r2 defaults
update-rc.d -f mongodbs1r3 defaults
update-rc.d -f mongodbconfigdb defaults
update-rc.d -f mongodbconfigdb2 defaults
update-rc.d -f mongodbconfigdb3 defaults
update-rc.d -f mongos defaults

## the order of installation is importent,
## first setup a replica set, with all the host names the same
## then start config servers, all together. 
## then start mongos (never start mongos before all config servers are running) // config servers must _all_ be empty or set up from data of a valid config server
## then add the shrad

echo "start replica set members ..."; 


#initiate replica set

#start
/etc/init.d/mongodbs1r1 start

#status
if [ $(mongo web0:27018 --quiet --eval "db.serverStatus().ok;") != 1 ] ; then 
 echo "server s1r1 is not ok";
 echo " -- contents of /var/log/mongodb/mongodb.s1r1.log -- ";
 cat /var/log/mongodb/mongodb.s1r1.log
 echo " -- end of /var/log/mongodb/mongodb.s1r1.log -- ";
 exit 1;
fi

#start
/etc/init.d/mongodbs1r2 start

#status
if [ $(mongo web0:27020 --quiet --eval "db.serverStatus().ok;") != 1 ] ; then 
 echo "server s1r2 is not ok";
 echo " -- contents of /var/log/mongodb/mongodb.s1r2.log -- ";
 cat /var/log/mongodb/mongodb.s1r2.log
 echo " -- end of /var/log/mongodb/mongodb.s1r2.log -- ";
 exit 1;
fi

#start
/etc/init.d/mongodbs1r3 start

#status
if [ $(mongo web0:27021 --quiet --eval "db.serverStatus().ok;") != 1 ] ; then 
 echo "server s1r3 is not ok";
 echo " -- contents of /var/log/mongodb/mongodb.s1r3.log -- ";
 cat /var/log/mongodb/mongodb.s1r3.log
 echo " -- end of /var/log/mongodb/mongodb.s1r3.log -- ";
 exit 1;
fi

echo "initiate replica set, can take about 60 seconds"

#connect to replica member

CODE="rs.initiate({_id : 's1',members : [\
{_id : 0, host : 'web0:27018'},\
{_id : 1, host : 'web0:27020'},\
{_id : 2, host : 'web0:27021', arbiterOnly:true }\
]}).errmsg"
mongo web0:27018/admin --eval "$CODE"

MONGO_ERROR=$?
if [ $MONGO_ERROR != 0 ] ; then
 echo -e "    \nERROR: initiating replica set. \n\
            It is probably it is a syntax error \n\
            Here is your code:\n"
 echo "$CODE"   
 exit 1;
fi

if [ $(mongo web0:27018/admin --quiet --eval "rs.status().startupStatus;") = 3 ] ; then
 echo -e "                                 ^  \n\
            ERROR: initiating replica set. \n\
            at this point the replica set had to be already initiated. \n\
            for some reason your code did not initiated the replica set. \n\
            Here is your code:\n"
 echo "$CODE"   
 exit 1;
fi

echo "waiting until replica set is ready";
SEC=0;
while true ; do 
 sleep 5;
 echo "$SEC seconds passed. still waiting... ";
 SEC=`expr $SEC + 5`; 
 STATUS=`mongo web0:27018/admin --quiet --eval "rs.status().ok;"`
 if [ $STATUS = 1 ] ; then
  echo "replica set is ready";  break;
 fi
 if [ $SEC -gt 300  ] ; then
  echo "ERROR: replica set is not getting ready - timeout";  
  exit 1;
 fi
done;

#if [ $(mongo web0:27018/admin --quiet --eval "db.serverStatus().ok;") = 1 ] ; then echo "server 1 is ok"; else echo "server 1 is not ok"; fi
#if [ $(mongo web0:27018/admin --quiet --eval "rs.status().ok;") = 1 ] ; then echo "server 1 replication is ok";  fi

echo "start config databases"

#initiate shards config

#start
/etc/init.d/mongodbconfigdb start

#status
if [ $(mongo web0:27019 --quiet --eval "db.serverStatus().ok;") != 1 ] ; then 
 echo "server configdb is not ok";
 echo " -- contents of /var/log/mongodb/mongodb.configdb.log -- ";
 cat /var/log/mongodb/mongodb.configdb.log
 echo " -- end of /var/log/mongodb/mongodb.configdb.log -- ";
 exit 1;
fi

#start
/etc/init.d/mongodbconfigdb2 start

#status
if [ $(mongo web0:27119 --quiet --eval "db.serverStatus().ok;") != 1 ] ; then 
 echo "server configdb2 is not ok";
 echo " -- contents of /var/log/mongodb/mongodb.configdb2.log -- ";
 cat /var/log/mongodb/mongodb.configdb2.log
 echo " -- end of /var/log/mongodb/mongodb.configdb2.log -- ";
 exit 1;
fi

#start
/etc/init.d/mongodbconfigdb3 start

#status
if [ $(mongo web0:27219 --quiet --eval "db.serverStatus().ok;") != 1 ] ; then 
 echo "server configdb3 is not ok";
 echo " -- contents of /var/log/mongodb/mongodb.configdb3.log -- ";
 cat /var/log/mongodb/mongodb.configdb3.log
 echo " -- end of /var/log/mongodb/mongodb.configdb3.log -- ";
 exit 1;
fi

echo "start mongos"

/etc/init.d/mongos start

#status mongos
if [ $(mongo web0:27017 --quiet --eval "db.serverStatus().ok;") != 1 ] ; then 
 echo "server configdb3 is not ok";
 echo " -- contents of /var/log/mongodb/mongodb.configdb3.log -- ";
 cat /var/log/mongodb/mongodb.configdb3.log
 echo " -- end of /var/log/mongodb/mongodb.configdb3.log -- ";
 exit 1;
fi

echo "set up shrading"

#connect to mongos
# add replica set s1 as a shrad to config servers through mongos 
# do not add arbiters they are passive members - you will get an error.
mongo web0:27017/admin --eval "db.runCommand( { addshard : 's1/web0:27018,web0:27020' } ).errmsg"
MONGO_ERROR=$?
if [ $MONGO_ERROR != 0 ] ; then
 echo -e "                           ^  \n\
            mongos ERROR: adding replica set as a shrad to config servers. \n\
            debug this , try running mongo manualy and execute the addshard command"
 exit 1;
fi

echo installation complete. type mongo to see if everything is working
echo in the log lines like \"Wed May 25 00:36:02 [conn14] getmore local.oplog.rs cid:265112...  bytes:20 nreturned:0 3979ms\" are normal. it is long pooling pings from replica slaves to master

fi




###########################################
## uninstall


if [ $DO_INSTALL = 1 ] ; then


echo "stop services"
#stop
/etc/init.d/mongos stop; echo "";
/etc/init.d/mongodbconfigdb stop; echo "";
/etc/init.d/mongodbconfigdb2 stop; echo "";
/etc/init.d/mongodbconfigdb3 stop; echo "";
/etc/init.d/mongodbs1r1 stop; echo "";
/etc/init.d/mongodbs1r2 stop; echo "";
/etc/init.d/mongodbs1r3 stop; echo "";


echo "remove services from autostart on boot"

update-rc.d -f mongodbs1r1 remove
update-rc.d -f mongodbs1r2 remove
update-rc.d -f mongodbs1r3 remove
update-rc.d -f mongodbconfigdb remove
update-rc.d -f mongodbconfigdb2 remove
update-rc.d -f mongodbconfigdb3 remove
update-rc.d -f mongos remove

# delete all configdbs in case of wrong startup _first_ time !!!only during setup!!!
rm -r /var/lib/mongodb/configdb
rm -r /var/lib/mongodb/configdb2
rm -r /var/lib/mongodb/configdb3
rm -r /var/lib/mongodb/s1r1
rm -r /var/lib/mongodb/s1r2
rm -r /var/lib/mongodb/s1r3

echo delete logs
#rm logs
rm /var/log/mongodb/mongodb.s1r1.log
rm /var/log/mongodb/mongodb.s1r2.log
rm /var/log/mongodb/mongodb.s1r3.log
rm /var/log/mongodb/mongodb.configdb.log
rm /var/log/mongodb/mongodb.configdb2.log
rm /var/log/mongodb/mongodb.configdb3.log
rm /var/log/mongodb/mongos.log

echo delete service scripts
rm /etc/init.d/mongos
rm /etc/init.d/mongodbconfigdb
rm /etc/init.d/mongodbconfigdb2
rm /etc/init.d/mongodbconfigdb3
rm /etc/init.d/mongodbs1r1
rm /etc/init.d/mongodbs1r2
rm /etc/init.d/mongodbs1r3

echo bring back the default mongodb. make it start on boot and and start it.
update-rc.d -f mongodb defaults
/etc/init.d/mongodb start

echo uninstall finished

fi

