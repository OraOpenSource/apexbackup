# Oracle APEX Backup Script

The purpose of this script is to provide a quick way to backup all of your APEX applications.

#Configuration
Before running the config script, you need to modify `config.properties`. The configuration requires that you have access to some of the Oracle APEX installation files.

#Run Backup
To run the backup simply execute:

```bash
. apex_backup.sh <backup location (optional)>
```

If no backup location (directory where backup files are to be stored) is provided, the default path from `config.properties` will be used.



