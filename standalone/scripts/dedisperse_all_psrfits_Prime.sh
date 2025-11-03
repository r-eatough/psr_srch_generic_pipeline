#!/bin/bash
#
# Script to run basic psrx dedispersion
# job in the batch queue.
# 
# R. P. Eatough 01/04/2024
#
#

# singularity shell is set up outside this bash script in pbs singularity run command. 
# 
# This script takes three input parameters: source obsdate beam
#


echo $HOSTNAME

# go to PID processing directory
#cd /mnt/processing/

# collect source name and beam number
source=$1
obsdate=$2
beam=$3
proc_dir=$4
script_dir=$5

cd $proc_dir


cd $source/$obsdate/
cd $beam

#cp /home/reatough/scripts/DD_plans/ddplan_FAST_M31x2DS_TWO.txt . 
cp $SCRIPT_DIR/DD_plans/ddplan_FAST_M31x2DS_TWO.txt . 

# BENCHM
#touch dedsip_start.bench
#touch dedisp_end.bench
#date >> dedisp_start.bench


# dedisperse 
echo "Running pulsarX dedisperse_all_fil"
pwd
ls -l 
ulimit -a
stat *.fits
#/home/pulsarx/software/bin/dedisperse_all_fil -v --psrfits -t 8 --ddplan ddplan_FAST_M31x2DS_TWO.txt --zapthre 3.0 -z kadaneF 8 4 zdot --incoherent --format presto --cont -f *.fits
dedisperse_all_fil -v --psrfits -t 8 --ddplan ddplan_FAST_M31x2DS_TWO.txt --zapthre 3.0 -z kadaneF 8 4 zdot --incoherent --format presto --cont -f *.fits


# threads -t 12 taken out


echo "done"
#date >> dedisp_end.bench
exit

 
 
