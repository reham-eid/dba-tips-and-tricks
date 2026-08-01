#/bin/sh
ORACLE_SID=OTDS
export ORACLE_SID
ORACLE_BASE=/u01/app/oracle
export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19.3.0/db_1
export ORACLE_HOME
LD_LIBRARY_PATH=$ORACLE_HOME/lib
export LD_LIBRARY_PATH
export PATH=$PATH:$ORACLE_HOME/bin

$ORACLE_HOME/bin/rman << EOF
connect target /
run{
allocate channel c1 type disk;
delete force noprompt archivelog until time 'SYSDATE-2';
release channel c1;
}
exit
EOF
