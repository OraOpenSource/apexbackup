#!/bin/bash
#License: https://github.com/OraOpenSource/apexbackup/blob/master/LICENSE
#Original content taken from http://www.talkapex.com

#Parameters
# 1: backup location (optional). This will overwrite OOS_AB_BACKUP_DIR

OOS_AB_START_DIR=$PWD

#Find location of script
#http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
OOS_AB_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$OOS_AB_SOURCE" ]; do # resolve $OOS_AB_SOURCE until the file is no longer a symlink
  OOS_AB_SOURCE_DIR="$( cd -P "$( dirname "$OOS_AB_SOURCE" )" && pwd )"
  OOS_AB_SOURCE="$(readlink "$OOS_AB_SOURCE")"
  [[ $OOS_AB_SOURCE != /* ]] && OOS_AB_SOURCE="$OOS_AB_SOURCE_DIR/$OOS_AB_SOURCE" # if $OOS_AB_SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
OOS_AB_SOURCE_DIR="$( cd -P "$( dirname "$OOS_AB_SOURCE" )" && pwd )"

# Go to source script directory
cd $OOS_AB_SOURCE_DIR

# Load Configurations
source ./config.properties

# Load custom properties
if [ -f "./custom.properties" ]; then
  echo "Loading custom properties"
  source ./custom.properties
fi


#Load optional parameters
OOS_AB_BACKUP_DIR=${1:-$OOS_AB_BACKUP_DIR}


# *** Load Default Values ***

#Default to apex_backup_report.html
[[ -z "$OOS_AB_REPORT_FILENAME" ]] && OOS_AB_REPORT_FILENAME=apex_backup_report.html

# Note: You may not need to explicitly define these as they may already be set in OS.
ORACLE_HOME=${ORACLE_HOME:-$OOS_AB_ORACLE_HOME}


#Classpath detection for ojdbc5.jar
OOS_AB_CLASSPATH_OJDBC5="$ORACLE_HOME/jdbc/lib/ojdbc5.jar"
if [ ! -f "$OOS_AB_CLASSPATH_OJDBC5" ]; then

  #Test for Directory
  OOS_AB_CLASSPATH_OJDBC5="$ORACLE_HOME/ojdbc5.jar"
  if [ ! -f "$OOS_AB_CLASSPATH_OJDBC5" ]; then
    #Set to null and will be picked up in validation
    OOS_AB_CLASSPATH_OJDBC5=
  fi
fi

# *** Validate Configuration ***

source ./apex_backup_validations.sh

if [ "$OOS_AB_DEBUG_YN" = "Y" ]; then
  echo OOS_AB_START_DIR: $OOS_AB_START_DIR
  echo OOS_AB_ORACLE_SID: $OOS_AB_ORACLE_SID
  echo OOS_AB_ORACLE_USERNAME: $OOS_AB_ORACLE_USERNAME
  # Don't echo password echo OOS_AB_ORACLE_PASSWORD: $OOS_AB_ORACLE_PASSWORD
  [[ -z "$OOS_AB_ORACLE_PASSWORD" ]] && echo "OOS_AB_ORACLE_PASSWORD: <blank>" || echo "OOS_AB_ORACLE_PASSWORD: ****"
  echo OOS_AB_TNS_PORT: $OOS_AB_TNS_PORT
  echo OOS_AB_ORACLE_HOST: $OOS_AB_ORACLE_HOST
  echo OOS_AB_APEX_EXPORT_JAVA_DIR: $OOS_AB_APEX_EXPORT_JAVA_DIR
  echo OOS_AB_REPORT_FILENAME: $OOS_AB_REPORT_FILENAME
  echo OOS_AB_BACKUP_DIR: $OOS_AB_BACKUP_DIR
  echo OOS_AB_ORACLE_HOME: $OOS_AB_ORACLE_HOME
  echo ORACLE_HOME: $ORACLE_HOME
  echo OOS_AB_CLASSPATH_OJDBC5: $OOS_AB_CLASSPATH_OJDBC5
fi;


if [ "$OOS_AB_CONFIG_VALID" = "N" ]; then
  echo;
  echo "*** Errors detected (see above for details) ***"
  return
fi




# ****** PATHS *********
export CLASSPATH=$CLASSPATH:$OOS_AB_CLASSPATH_OJDBC5:$OOS_AB_APEX_EXPORT_JAVA_DIR

if [ "$OOS_AB_DEBUG_YN" = "Y" ]; then
  echo CLASSPATH: $CLASSPATH
fi;




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
sqlplus $OOS_AB_ORACLE_USERNAME/$OOS_AB_ORACLE_PASSWORD@$OOS_AB_ORACLE_HOST:$OOS_AB_TNS_PORT/$OOS_AB_ORACLE_SID @$OOS_AB_SOURCE_DIR/apex_backup_report.sql $OOS_AB_REPORT_FILENAME

# Back to start location
cd $OOS_AB_START_DIR
