#!/bin/bash
#
# Script to run presto/pulsarx sifting and folding
# job in the batch queue.
# 
# R. P. Eatough 10/04/2024
#
#

# singularity shell is set up outside this bash script in pbs singularity run command. 

echo "host: "$HOSTNAME

# go to working directory
#cd /mnt/processing/ 

# collect source name and beam number
export source=$1
export obsdate=$2
export beam=$3
export proc_dir=$4
export script_dir=$5



cd $proc_dir

# directories should have been made during dedispersion
cd $source/$obsdate/$beam

# BENCHM
#touch asift_start.bench
#touch asift_end.bench
#date >> asift_start.bench


#python ~/scripts/ACCEL_sifts/ACCEL_20_sift_pulsarx_reatmod.py 
python $script_dir/ACCEL_sifts/ACCEL_20_sift_pulsarx_reatmod.py

#date >> asift_end.bench

# make pulsarx .cands file: (not needed anymore, modified the above)
#grep ACCEL cands.txt > presto.cands

#touch psrx.cands
#echo 1 | awk '{print "#id dm acc  F0 F1 S/N"}' >> psrx.cands
#cat presto.cands | awk '{printf "%4s %0.3f %0.3f %0.5f %0.3f %0.3f\n", $1, $2, 0.0, 1/(1E-3*$8), 0.0, $3}' >> psrx.cands


# fold the candidates!
#psrfold_fil --psrfits -v --candfile candidates.txt --template /home/pulsarx/software/PulsarX/include/template/fast_fold.template --plotx -n 64 -b 64 --clfd 2 -f *.fits --cont -t 8 --zapthre 3.0 -z kadaneF 8 4 zdot  --nbinplan 0.1 256 0.02 128 0.01 64


echo "done"
exit

 
 
