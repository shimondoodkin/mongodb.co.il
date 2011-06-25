:: this file is used to Reinstall mongos as service


::detect x86 or x64
echo off
IF PROCESSOR_ARCHITECTURE EQU "ia64" GOTO IS_ia64
IF PROCESSOR_ARCHITEW6432 EQU "ia64" GOTO IS_ia64
IF PROCESSOR_ARCHITECTURE EQU "amd64" GOTO IS_amd64
IF PROCESSOR_ARCHITEW6432 EQU "amd64" GOTO IS_amd64 
IF DEFINED ProgramFiles(x86) GOTO IS_amd64 
:IS_x86
set prunsrv=c:\mongodb\bin\prunsrv.exe
GOTO IS_x64End
:IS_amd64
set prunsrv=c:\mongodb\bin\prunsrv_amd64.exe
GOTO IS_x64End
:IS_ia64
set prunsrv=c:\mongodb\bin\prunsrv_ia64.exe
::GOTO IS_x64End
:IS_x64End
echo on
::end detect x86 or x64

net stop mongos
%prunsrv% //DS//mongos
%prunsrv% //IS//mongos --DisplayName="MongoDB mongos" --Startup=auto --Install=C:\mongodb\bin\prunsrv.exe --StartMode=exe --StartImage=C:\mongodb\bin\mongos.exe ++StartParams=--configdb#www0:27019,www0:27119,www0:27219#--port#27017#--logpath#c:/mongodb/logs/mongos.log --StdOutput=c:\mongodb\logs\mongos.out.log --StdError=c:\mongodb\logs\mongos.err.log
net start mongos