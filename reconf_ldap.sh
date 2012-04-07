#!/bin/bash

service slapd stop
rm -fr ../slapd.d/*
rm -fr /var/lib/ldap/mecsys/*
slaptest -f slapd.conf -F ../slapd.d/
slapindex -vv
chown -R openldap:openldap ../slapd.d/
chown -R openldap:openldap /var/lib/ldap/
service slapd start
