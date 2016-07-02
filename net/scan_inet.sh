#!/bin/bash


COUNT=1
while [  ${COUNT} -le 25500 ]; do
  #let CC=COUNT-1
  #echo $CC
  #echo 's/153.69.3.${CC}/153.69.3.${COUNT}/g'
  #SED="'s/153.69.3.${CC}/153.69.3.${COUNT}/g'"
  #echo $SED

  #ORIGIP=`grep IPADDR\\[0 /etc/rc.d/rc.inet1.conf | cut -d"\"" -f2`
  #ORIGIP=`/sbin/ifconfig eth0 | grep inet | cut -d':' -f2 | cut -d' ' -f1`
  #sed -i "s/address ${ORIGIP}/address 153.69.${SUBNET}.${COUNT}/g" /etc/network/interfaces
  #/etc/init.d/networking restart  

  #IP="153.69.3.${COUNT}"
	IP="200.69.23.18"

  if ping -c 1 -w 5 "${IP}" 1>/dev/null; then 
    echo `date`": EEEEEEEEHHHHH!!!!!!!"
      mpc clear;mpc stop;mpc load acdc;mpc play
      exit
  else
    echo `date`": DOWN shit!"
  fi

	sleep 5
  let COUNT=COUNT+1
  #echo "========> $COUNT"
done

