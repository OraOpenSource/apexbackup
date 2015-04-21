#!/bin/bash

OOS_AB_CONFIG_VALID=Y
echo;

if [ -z "$OOS_AB_ORACLE_SID" ]; then
  echo "Missing: OOS_AB_ORACLE_SID";
  OOS_AB_CONFIG_VALID=N
fi
if [ -z "$OOS_AB_ORACLE_USERNAME" ]; then
  echo "Missing: OOS_AB_ORACLE_USERNAME";
  OOS_AB_CONFIG_VALID=N
fi
if [ -z "$OOS_AB_ORACLE_PASSWORD" ]; then
  echo "Missing: OOS_AB_ORACLE_PASSWORD";
  OOS_AB_CONFIG_VALID=N
fi
if [ -z "$OOS_AB_TNS_PORT" ]; then
  echo "Missing: OOS_AB_TNS_PORT";
  OOS_AB_CONFIG_VALID=N
fi
if [ -z "$OOS_AB_ORACLE_HOST" ]; then
  echo "Missing: OOS_AB_ORACLE_HOST";
  OOS_AB_CONFIG_VALID=N
fi



if [ -z "$OOS_AB_APEX_EXPORT_JAVA_DIR" ]; then
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

if [ -z "$OOS_AB_CLASSPATH_OJDBC5" ]; then
  echo "Error: Could not find path to ojdbc5.jar. Check ORACLE_HOME ($ORACLE_HOME) configuration";
  OOS_AB_CONFIG_VALID=N
fi
