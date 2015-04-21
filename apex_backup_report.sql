-- Parameters
-- 1 = File Name

-- http://forums.devshed.com/oracle-development-96/sql-plus-column-width-format-185085.html
-- http://download.oracle.com/docs/cd/B10501_01/server.920/a90842/ch13.htm#1012748
SET NUMFORMAT 9999999999999999999999999999999999999
SET MARKUP HTML ON SPOOL ON HEAD "<title>APEX Export</title>"

SET ECHO OFF
SPOOL &1

-- Current Date
select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') apex_backup_date
from dual;

-- Applications
SELECT 'f' || application_id || '.sql' filename, application_id, workspace, application_name, owner
FROM apex_applications
WHERE workspace != 'INTERNAL'
ORDER BY application_id;

-- Workspaces
SELECT 'f' || workspace_id || '.sql' filename, workspace
FROM apex_workspaces
WHERE workspace != 'INTERNAL'
ORDER BY workspace_id;

SPOOL OFF
SET MARKUP HTML OFF
SET ECHO ON

EXIT;
