#!/bin/bash
ORACLE_HOME=/u01/app/oracle/product/19.3.0/db_1
ORACLE_SID=TEST
PATH=$PATH:$ORACLE_HOME/bin
DD=`date +%Y-%m-%d-%H-%M-%S`
export ORACLE_HOME ORACLE_SID PATH DD
mkdir /mnt/or-bk-dev/TEST/${DD}
LOGFILE=/mnt/or-bk-dev/TEST/logs/daily_rman_TEST_bkup_`date +%Y%m%d`.log
rman target / nocatalog LOG $LOGFILE <<EOF
crosscheck backup;
crosscheck archivelog all;
run
{
backup as compressed backupset incremental level 1 DEVICE TYPE DISK TAG='INCREMENTAL_DATABASE' FORMAT '/mnt/or-bk-dev/TEST/${DD}/INCREMENTAL_BACKUP_%D_%T_%s-%p' check logical database plus archivelog;
backup current controlfile format '/mnt/or-bk-dev/TEST/${DD}/ControlFile_%d_%I_%u.ctl';
sql "create pfile=''/mnt/or-bk-dev/TEST/${DD}/pfileTEST.ora''from spfile";
backup spfile format '/mnt/or-bk-dev/TEST/${DD}/spfileTEST.ora';
}
EOF

