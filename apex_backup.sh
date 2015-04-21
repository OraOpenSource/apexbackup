#!/bin/bash
#See TODO link for license

#Original content taken from http://www.talkapex.com

# Load Configurations
source ./config.properties



# ****** PATHS *********
# Note: You may not need to explicitly define these as they may already be set in OS.
ORACLE_HOME=${ORACLE_HOME:-OOS_AB_ORACLE_HOME}

export CLASSPATH=$CLASSPATH:$ORACLE_HOME/jdbc/lib/ojdbc5.jar:$OOS_AB_APEX_EXPORT_JAVA_DIR


#TODO remove
OOS_AB_DEBUG_YN=Y

if [ "$OOS_AB_DEBUG_YN" = "Y" ]; then
  echo $OOS_AB_ORACLE_SID
  echo $OOS_AB_SYSTEM_PASS
  echo $OOS_AB_TNS_PORT
  echo $OOS_AB_ORACLE_HOST
  echo $OOS_AB_APEX_EXPORT_JAVA_DIR
  echo $OOS_AB_REPORT_FILENAME
  echo $OOS_AB_BACKUP_DIR
  echo $OOS_AB_ORACLE_HOME
  echo $ORACLE_HOME
  echo $CLASSPATH
fi;


# ****** Other *********
OOS_AB_START_DIR=$PWD

# ****** Directory Setup ******
# Create temp bacpkup location
mkdir -p $OOS_AB_BACKUP_DIR

# ****** APEX BACKUP *******
# Go to backup location to run backups in
cd $OOS_AB_BACKUP_DIR

# Export all applications
java oracle.apex.APEXExport -db $OOS_AB_ORACLE_HOST:$OOS_AB_TNS_PORT:$OOS_AB_ORACLE_SID -user system -password $OOS_AB_SYSTEM_PASS -instance -expPubReports -expSavedReports -expIRNotif -expTranslations

# Export all Workspaces
java oracle.apex.APEXExport -db $OOS_AB_ORACLE_HOST:$OOS_AB_TNS_PORT:$OOS_AB_ORACLE_SID -user system -password $OOS_AB_SYSTEM_PASS -expWorkspace -expFiles -expFeedback


# Generate listing of Workspaces and Applications
sqlplus system/$OOS_AB_SYSTEM_PASS@$OOS_AB_ORACLE_HOST:$OOS_AB_TNS_PORT/$OOS_AB_ORACLE_SID @$OOS_AB_START_DIR/apex_backup_report.sql $OOS_AB_REPORT_FILENAME

# Back to start location
cd $OOS_AB_START_DIR
