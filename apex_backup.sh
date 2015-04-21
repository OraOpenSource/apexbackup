#!/bin/bash
#See TODO link for license
#Original content taken from http://www.talkapex.com

#Parameters
# 1: backup location (optional). This will overwrite OOS_AB_BACKUP_DIR

# Load Configurations
source ./config.properties

#Load optional parameters
OOS_AB_BACKUP_DIR=${1:-$OOS_AB_BACKUP_DIR}


# *** Load Default Values ***

#Default to apex_backup_report.html
[[ -z "$OOS_AB_REPORT_FILENAME" ]] && OOS_AB_REPORT_FILENAME=apex_backup_report.html

# Note: You may not need to explicitly define these as they may already be set in OS.
ORACLE_HOME=${ORACLE_HOME:-OOS_AB_ORACLE_HOME}


# *** Validate Configuration ***
OOS_AB_CONFIG_VALID=Y
[[ -z "$OOS_AB_ORACLE_SID" ]] && echo "Missing: OOS_AB_ORACLE_SID"; OOS_AB_CONFIG_VALID=N
[[ -z "$OOS_AB_ORACLE_USERNAME" ]] && echo "Missing: OOS_AB_ORACLE_USERNAME"; OOS_AB_CONFIG_VALID=N
[[ -z "$OOS_AB_ORACLE_PASSWORD" ]] && echo "Missing: OOS_AB_ORACLE_PASSWORD"; OOS_AB_CONFIG_VALID=N
[[ -z "$OOS_AB_TNS_PORT" ]] && echo "Missing: OOS_AB_TNS_PORT"; OOS_AB_CONFIG_VALID=N
[[ -z "$OOS_AB_ORACLE_HOST" ]] && echo "Missing: OOS_AB_ORACLE_HOST"; OOS_AB_CONFIG_VALID=N

if [ -z "$var" ]; then
  echo "Missing: OOS_AB_APEX_EXPORT_JAVA_DIR"
  OOS_AB_CONFIG_VALID=N
else
  if [ ! -d "$OOS_AB_APEX_EXPORT_JAVA_DIR" ]; then
    echo "OOS_AB_APEX_EXPORT_JAVA_DIR: Path does not exist"
    OOS_AB_CONFIG_VALID=N
  elif [ ! -f "$OOS_AB_APEX_EXPORT_JAVA_DIR/oracle/apex/APEXExport.class" ]; then
    echo "APEXEport.class file not found in $OOS_AB_APEX_EXPORT_JAVA_DIR"
    OOS_AB_CONFIG_VALID=N
  fi
fi


if [ ! -d "$OOS_AB_BACKUP_DIR" ]; then
  echo "OOS_AB_BACKUP_DIR: Path does not exist"
  OOS_AB_CONFIG_VALID=N
fi

if [ ! -d "$ORACLE_HOME" ]; then
  echo "ORACLE_HOME: Path does not exist"
  OOS_AB_CONFIG_VALID=N
fi




# ****** PATHS *********
export CLASSPATH=$CLASSPATH:$ORACLE_HOME/jdbc/lib/ojdbc5.jar:$OOS_AB_APEX_EXPORT_JAVA_DIR


#TODO remove
OOS_AB_DEBUG_YN=Y

if [ "$OOS_AB_DEBUG_YN" = "Y" ]; then
  echo OOS_AB_ORACLE_SID: $OOS_AB_ORACLE_SID
  echo OOS_AB_ORACLE_USERNAME: $OOS_AB_ORACLE_USERNAME
  echo OOS_AB_ORACLE_PASSWORD: $OOS_AB_ORACLE_PASSWORD
  echo OOS_AB_TNS_PORT: $OOS_AB_TNS_PORT
  echo OOS_AB_ORACLE_HOST: $OOS_AB_ORACLE_HOST
  echo OOS_AB_APEX_EXPORT_JAVA_DIR: $OOS_AB_APEX_EXPORT_JAVA_DIR
  echo OOS_AB_REPORT_FILENAME: $OOS_AB_REPORT_FILENAME
  echo OOS_AB_BACKUP_DIR: $OOS_AB_BACKUP_DIR
  echo OOS_AB_ORACLE_HOME: $OOS_AB_ORACLE_HOME
  echo ORACLE_HOME: $ORACLE_HOME
  echo CLASSPATH: $CLASSPATH
fi;


# ****** Other *********
OOS_AB_START_DIR=$PWD


# *** Parameter Validation ***
# TODO user must either be SYSTEM OR have APEX_ADMINISTRATOR_ROLE role
# TODO USER_ROLE_PRIVS

# ****** Directory Setup ******
# Create temp bacpkup location
mkdir -p $OOS_AB_BACKUP_DIR

# ****** APEX BACKUP *******
# Go to backup location to run backups in
cd $OOS_AB_BACKUP_DIR

# Export all applications
java oracle.apex.APEXExport -db $OOS_AB_ORACLE_HOST:$OOS_AB_TNS_PORT:$OOS_AB_ORACLE_SID -user $OOS_AB_ORACLE_USERNAME -password $OOS_AB_ORACLE_PASSWORD -instance -expPubReports -expSavedReports -expIRNotif -expTranslations

# Export all Workspaces
java oracle.apex.APEXExport -db $OOS_AB_ORACLE_HOST:$OOS_AB_TNS_PORT:$OOS_AB_ORACLE_SID -user $OOS_AB_ORACLE_USERNAME -password $OOS_AB_ORACLE_PASSWORD -expWorkspace -expFiles -expFeedback


# Generate listing of Workspaces and Applications
sqlplus $OOS_AB_ORACLE_USERNAME/$OOS_AB_ORACLE_PASSWORD@$OOS_AB_ORACLE_HOST:$OOS_AB_TNS_PORT/$OOS_AB_ORACLE_SID @$OOS_AB_START_DIR/apex_backup_report.sql $OOS_AB_REPORT_FILENAME

# Back to start location
cd $OOS_AB_START_DIR
