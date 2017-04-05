#!/bin/bash
average=`zcat $1 | awk '{if(NR%4==2) print length($1)}' | head -1000 | awk '{s+=$1}END{print s/NR}'`
echo $average
