This is a collection of Unix shell scripts for developers.
============================

These scripts should work on all Unix distros and Mac OS X. Otherwise, it will be stated on the file if it doesn't.

SSH-COPY-ID
-----------------------------

This is for copying your public key to a remote server. Saves you time typing password over and over again.

Usage:

``cd ~/.ssh/ && ssh-copy-id -i id_rsa.pub user@remoteserver``

BACKUP MYSQL DATABASES 
-----------------------------

1. copy and modify linux/backup_mysqldb.sh
2. ssh to remote server
3. copy contents of file to ~/scripts/backups.sh and chmod a+x ~/scripts/backups.sh
4. crontab -e 
5. Add this if you want to backup database per hour: 
        0 0 * * *  ~/scripts/backups.sh 

BACKUP POSTGRESQL DATABASES 
-----------------------------

1. copy and modify linux/backup_postgresqldb.sh
2. ssh to remote server
3. copy contents of file to ~/scripts/backups.sh and 
        chmod a+x ~/scripts/backups.sh
4. update the .pgpass file on your home directory. This is needed to make sure you can backup the database without entering a password.
   hostname:port:database:username:password
5. crontab -e 
6. Add this if you want to backup database per hour: 
        0 0 * * *  ~/scripts/backups.sh 
