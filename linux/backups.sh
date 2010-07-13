#!/bin/bash
domains=(domain1.com, domain2.com)
sqldbs=(domain_1_production, domain_2_production)

usernames=(root, root2)
passwords=(password, password2)

remote_backup_server_user=(username)
remote_backup_server=(x.dreamhost.com) 


opath=$HOME/backups/database/

remote_server_path = ~/x_backups/database  

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
	#dump and compress
	mysqldump -c -h $mysqlhost --user ${usernames[$i]} --password=${passwords[$i]} ${sqldbs[$i]} | gzip > $SQLFILE
	#remove files older than 60 days
	find $cpath -type f -mtime +60 -exec rm {} \;
  rsync -avz --delete  ~/backups/database/ ${remote_backup_server_user}@${remote_backup_server}:${remote_server_path}

 

	if [ $? -eq 0 ]
	then
		printf "%s was backed up successfully to %s" ${sqldbs[$i]} $SQLFILE
		printf "Files were successfully backed up"
	else
		printf "WARNING: An error occured while attempting to backup %s to %s" ${sqldbs[$i]} $SQLFILE
	fi
	

	
done
