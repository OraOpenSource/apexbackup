[![Analytics](https://ga-beacon.appspot.com/UA-59573016-4/apexbackup/README.md)](https://github.com/igrigorik/ga-beacon)
# Oracle APEX Backup Script


The purpose of this script is to provide a quick way to backup all of your APEX applications.

#Download
To download the APEX backup scripts, go to the parent directory where you want to store them and run:

```bash
git clone https://github.com/OraOpenSource/apexbackup.git
```

#Configuration
Configuration is defined on `config.properties`. Though you can modify this file, it will be updated each time you refresh the project from Github.

It is recommended that you copy all the options from `config.properties` and paste them into `custom.properties`. Any settings defined in `custom.properties` will overwrite anything in `config.properties`. `custom.properties` will not be updated when refreshing from Github so your configurations will be retained.

#Run Backup
To run the backup simply execute:

```bash
. apexbackup/apex_backup.sh <backup location (optional)>
```

If no backup location (directory where backup files are to be stored) is provided, the default path from `config.properties` will be used.

#Updates
To get the latest update of the backup script simply go to your project directory and run:

```bash
git pull
```



