# A collection of Unix shell scripts for developers

Most of these scripts should work on all Unix distros and Mac OS X. It will be stated on the file if it doesn't.

### SSH-COPY-ID

This is for copying your public key to a remote server. Saves you time typing password over and over again.

Update: If you are using homebrew, you do not need to download this. Simply install homebrew and do:

```bash
brew install ssh-copy-id
```

I used this at a time when homebrew was not popular. In case there are still helpful scripts which are not ideal as homebrew formulas, I will add them up here.

Usage:

```bash
cd ~/.ssh/ && ssh-copy-id -i id_rsa.pub user@remoteserver
```

### BACKUP MYSQL DATABASES

1. copy and modify linux/backup_mysqldb.sh
2. ssh to remote server
3. copy contents of file to `~/scripts/backups.sh`
4. give proper write permissions to make script executable.
   ``` bash
   chmod a+x ~/scripts/backups.sh
   ```
5. crontab -e
6. Add this if you want to backup database per hour:
   ```bash
   0 0 * * *  ~/scripts/backups.sh
   ```

On the server where you store backups, make sure to create the directories (e.g., `mkdir -p ~/backups/database`).

### BACKUP POSTGRESQL DATABASES

1. copy and modify linux/backup_postgresqldb.sh
2. ssh to remote server
3. copy contents of file to `~/scripts/backups.sh` and
   ```bash
   chmod a+x ~/scripts/backups.sh
   ```
4. give proper write permissions to make script executable
   ```bash
   chmod a+x ~/scripts/backups.sh
   ```
5. update the .pgpass file on your home directory. This is needed to make sure you can backup the database without entering a password.
   `hostname:port:database:username:password`
6. ```bash
   crontab -e
   ```
7. Add this if you want to backup database per hour:
   ```bash
   0 0 * * *  ~/scripts/backups.sh
   ```
