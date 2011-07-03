#!/bin/sh 

echo -n "sleep 60 seconds:"; SEC=0; while [ $SEC -lt 60 ]; do
echo -n " "$SEC; SEC=`expr $SEC + 5`; 
read -t 5 -n 1 ; KEYPRESS=$?; [ "$KEYPRESS" = "0" ]  && break

done; echo " 60"

echo "Thanks for using this script." 

exit 0 
