# extract local users who have 4-digit UID

# an example

#!/bin/bash

SUFFIX='dc=mecsys,dc=com,dc=br'
LDIF='ldapuser.ldif'

echo -n > $LDIF
for line in `grep "x:[1-9][0-9][0-9][0-9]:" /etc/passwd | sed -e "s/ /%/g"`
do
    UID1=`echo $line | cut -d: -f1`
    NAME=`echo $line | cut -d: -f5 | cut -d, -f1`
    if [ ! "$NAME" ]
    then
        NAME=$UID1
    else
        NAME=`echo $NAME | sed -e "s/%/ /g"`
    fi
    SN=`echo $NAME | awk '{print $2}'`
    if [ ! "$SN" ]
    then
        SN=$NAME
    fi
    GIVEN=`echo $NAME | awk '{print $1}'`
    UID2=`echo $line | cut -d: -f3`
    GID=`echo $line | cut -d: -f4`
    PASS=`grep $UID1: /etc/shadow | cut -d: -f2`
    SHELL=`echo $line | cut -d: -f7`
    HOME=`echo $line | cut -d: -f6`
    EXPIRE=`passwd -S $UID1 | awk '{print $7}'`
    FLAG=`grep $UID1: /etc/shadow | cut -d: -f9`
    if [ ! "$FLAG" ]
    then
        FLAG="0"
    fi
    WARN=`passwd -S $UID1 | awk '{print $6}'`
    MIN=`passwd -S $UID1 | awk '{print $4}'`
    MAX=`passwd -S $UID1 | awk '{print $5}'`
    LAST=`grep $UID1: /etc/shadow | cut -d: -f3`

    echo "dn: uid=$UID1,ou=people,$SUFFIX" >> $LDIF
    echo "objectClass: inetOrgPerson" >> $LDIF
    echo "objectClass: posixAccount" >> $LDIF
    echo "objectClass: shadowAccount" >> $LDIF
    echo "uid: $UID1" >> $LDIF
    echo "sn: $SN" >> $LDIF
    echo "givenName: $GIVEN" >> $LDIF
    echo "cn: $NAME" >> $LDIF
    echo "displayName: $NAME" >> $LDIF
    echo "uidNumber: $UID2" >> $LDIF
    echo "gidNumber: $GID" >> $LDIF
    echo "userPassword: {crypt}$PASS" >> $LDIF
    echo "gecos: $NAME" >> $LDIF
    echo "loginShell: $SHELL" >> $LDIF
    echo "homeDirectory: $HOME" >> $LDIF
    echo "shadowExpire: $EXPIRE" >> $LDIF
    echo "shadowFlag: $FLAG" >> $LDIF
    echo "shadowWarning: $WARN" >> $LDIF
    echo "shadowMin: $MIN" >> $LDIF
    echo "shadowMax: $MAX" >> $LDIF
    echo "shadowLastChange: $LAST" >> $LDIF
    echo >> $LDIF
done
