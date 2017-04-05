#!/bin/bash 

std_length=`zcat $1 | awk '{if(NR%4==2) print length($1)}' | head -1000 | awk '{sum+=$1;sumsq+=$1*$1}END{print sqrt(sumsq/NR-(sum/NR)^2) }'`

echo 'scale=4;std_length+0.001' | bc
