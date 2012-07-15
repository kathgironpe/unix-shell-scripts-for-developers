#!/bin/bash
domains=(yourdomain.com)
sqldbs=(database_production)

usernames=(root)
passwords=(password)

backup_user=(root2)
backup_server=(backup.somewhere.com) 


opath=$HOME/backups/database/
postgresqlhost=localhost
 
suffix=$(date +%m-%d-%Y-%H-%M)
current_month=$(date +%m)

for (( i = 0 ; i < ${#domains[@]} ; i++ ))
do
	cpath=$opath${domains[$i]}
	attachmentpath=$apath
	xmlpath=$xpath
	
	if [ -d $cpath ]
	then
		filler="just some action to prevent syntax error"
	else
		echo Creating $cpath
		mkdir -p $cpath
	fi
	
	#the file
	SQLFILE=${cpath}/${sqldbs[$i]}_$suffix.sql.gz

  if pg_dump -Fp -h $postgresqlhost -U ${usernames[$i]} ${sqldbs[$i]} | gzip > $SQLFILE
  then 
    scp  ${SQLFILE} ${backup_user}@${backup_server}:~/backups/database  
  else
    echo "[!!ERROR!!] Failed to create the file $SQLFILE"
  fi

	#on the server that keeps the database files, add this cron rule. If you want to keep more than 10 days of data, just change 10. 
	#0 0 * * * find /home/user/backups/database/*  -type f -mtime +10 -exec rm {} \;
	
	
	if [ $? -eq 0 ]
	then
		printf "%s was backed up successfully to %s" ${sqldbs[$i]} $SQLFILE
		printf "Files were successfully backed up"
	else
		printf "WARNING: An error occured while attempting to backup %s to %s" ${sqldbs[$i]} $SQLFILE
	fi
	
	cd $cpath && rm * 
	
done
