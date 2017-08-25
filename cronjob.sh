#!/bin/bash
### MySQL Server Login Info ###
MUSER="root"
MPASS="abc123"
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
BAK="/home/kheiner/Documentos/backup/backup-bd-test/"
GZIP="$(which gzip)"
### FTP SERVER Login info ###
#FTPU="FTP-SERVER-USER-NAME"
#FTPP="FTP-SERVER-PASSWORD"
#FTPS="FTP-SERVER-IP-ADDRESS"
NOW=$(date +"%d-%m-%Y")
 
### See comments below ###
### [ ! -d $BAK ] && mkdir -p $BAK || /bin/rm -f $BAK/* ###
[ ! -d "$BAK" ] && mkdir -p "$BAK"
 
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
  if [ $db != "vinssoft12" ]
  then
    FILE=$BAK/$db.$NOW-$(date +"%T").gz
    $MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
  fi

done
 
#lftp -u $FTPU,$FTPP -e "mkdir /mysql/$NOW;cd /mysql/$NOW; mput /backup/mysql/*; quit" $FTPS

git add .
git commit -m "backup"
git push
