#!/bin/bash

ldapadd -D cn=admin,dc=mecsys,dc=com,dc=br -W -f users.ldif
