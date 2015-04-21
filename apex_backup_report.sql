-- Parameters
-- 1 = File Name

-- http://forums.devshed.com/oracle-development-96/sql-plus-column-width-format-185085.html
-- http://download.oracle.com/docs/cd/B10501_01/server.920/a90842/ch13.htm#1012748
set numformat 9999999999999999999999999999999999999
set markup html on spool on head "<title>APEX Export</title>"
set termout off

set echo off
spool &1

-- Current Date
select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') apex_backup_date
from dual;

-- Applications
select 'f' || application_id || '.sql' filename, application_id, workspace, application_name, owner
from apex_applications
where workspace != 'INTERNAL'
order by application_id;

-- Workspaces
select 'f' || workspace_id || '.sql' filename, workspace
from apex_workspaces
where workspace != 'INTERNAL'
order by workspace_id;

spool off
set markup html off
set echo on

exit;
