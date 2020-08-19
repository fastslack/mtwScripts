#!/bin/bash


for f in * ; do
   git mv -- "$f" "$(tr [:lower:] [:upper:] <<< "${f:0:1}")${f:1}"
done
