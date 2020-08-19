#!/bin/bash

CURRENT=${PWD}
VH_PATH=/home/fastslack/www/
NAME=$1

EXAMPLE_FILE=${CURRENT}/virtualhost.example

cd /etc/apache2/sites-available

# FIX number
#sudo cp ${EXAMPLE_FILE} 30-${NAME}.conf

sed -i 's/{{NAME}}/${NAME}/g' ${EXAMPLE_FILE}

#cat ${EXAMPLE_FILE}
