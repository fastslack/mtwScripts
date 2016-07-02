#!/bin/bash

UNAME=`uname`

if [ $UNAME = "Darwin" ]; then
  . ${HOME}/mtwProjects/mtwScripts/mac.config.cfg  
else
  . ${HOME}/mtwProjects/mtwScripts/linux.config.cfg
fi

function mtwCheckRoot {
	if [ ${USERID} -ne "0" ]; then
		echo "You must be root! Fuck you vieja!"
		exit		
	fi
}

function mtwCheckVersionVariable {
    if [ ! ${VERSION} ]; then
        echo "VERSION variable not set!"
        exit
    fi
}

