set echo off
set heading off
set feedback off
set termout off

-- *** VARIABLES ***
define apex_backup_export_filename = 'apex_backup_export.sql'
define apex_backup_report_filename = 'apex_backup_report.html'

var ignore_apex_ws_list varchar2(500);
exec :ignore_apex_ws_list := lower('com.oracle.cust.repository, internal');


#Generate Backup Export file
#This will generate a file which will then be run to create all the APEX export files.
spool &apex_backup_export_filename

select 'spool ' || application_id || '.sql' || CHR(10) ||
  'apex export ' || application_id || chr(10) ||
  'spool off' || chr(10)
from apex_applications
where 1=1
  and lower(workspace) not in (
    select trim(regexp_substr(:ignore_apex_ws_list,'[^,]+', 1, level)) my_id
    from dual
    connect by trim(regexp_substr(:ignore_apex_ws_list, '[^,]+', 1, level)) is not null
  )
order by application_id
;


spool off

-- Reset
set heading on
set feedback on


-- Generate apex exports
@&apex_backup_export_filename


-- *** Generate Report ***
set echo off
set sqlformat html
set numformat 9999999999999999999999999999999999999
spool &apex_backup_report_filename

-- Current Date
select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') apex_backup_date
from dual;

-- Workspaces
select workspace_id, workspace
from apex_workspaces
where 1=1
  and lower(workspace) not in (
    select trim(regexp_substr(:ignore_apex_ws_list,'[^,]+', 1, level)) my_id
    from dual
    connect by trim(regexp_substr(:ignore_apex_ws_list, '[^,]+', 1, level)) is not null
  )
order by workspace_id;

-- Applications
select application_id, workspace, application_name, owner
from apex_applications
where 1=1
  and lower(workspace) not in (
    select trim(regexp_substr(:ignore_apex_ws_list,'[^,]+', 1, level)) my_id
    from dual
    connect by trim(regexp_substr(:ignore_apex_ws_list, '[^,]+', 1, level)) is not null
  )
order by application_id;

spool off

-- Reset
set echo on
set sqlformat


-- General Reset
set termout on
set echo on
