#!/bin/bash
domains=(yourdomain.com)
sqldbs=(database_production)

usernames=(root)
passwords=(password)

staging_user=(root2)
staging_server=(backup.somewhere.com) 


opath=$HOME/backups/database/
mysqlhost=localhost
 
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
	mysqldump -c -h $mysqlhost --user ${usernames[$i]} --password=${passwords[$i]} ${sqldbs[$i]} | gzip > $SQLFILE
	
	scp  ${SQLFILE} ${staging_user}@${staging_server}:~/dir_backups/database  
	
	#on staging server, add this cron rule
	#0 0 * * * find /home/user/dir_backups/database/*  -type f -mtime +10 -exec rm {} \;
	
	
	if [ $? -eq 0 ]
	then
		printf "%s was backed up successfully to %s" ${sqldbs[$i]} $SQLFILE
		printf "Files were successfully backed up"
	else
		printf "WARNING: An error occured while attempting to backup %s to %s" ${sqldbs[$i]} $SQLFILE
	fi
	
	cd $cpath && rm * 
	
done
