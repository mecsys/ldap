# extract local groups who have 4-digit UID

# an example

#!/bin/bash

SUFFIX='dc=mecsys,dc=com,dc=br'
LDIF='ldapgroup.ldif'

echo -n > $LDIF
for line in `grep "x:[1-9][0-9][0-9][0-9]:" /etc/group`
do
    CN=`echo $line | cut -d: -f1`
    GID=`echo $line | cut -d: -f3`
    echo "dn: cn=$CN,ou=groups,$SUFFIX" >> $LDIF
    echo "objectClass: posixGroup" >> $LDIF
    echo "cn: $CN" >> $LDIF
    echo "gidNumber: $GID" >> $LDIF
    users=`echo $line | cut -d: -f4 | sed "s/,/ /g"`
    for user in ${users} ; do
        echo "memberUid: ${user}" >> $LDIF
    done
    echo >> $LDIF
done
