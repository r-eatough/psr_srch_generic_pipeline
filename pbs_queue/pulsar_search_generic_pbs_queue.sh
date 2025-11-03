#!/bin/sh
#PBS -N psr_srch_generic_pbs
#PBS -l nodes=1:ppn=8
#PBS -l walltime=120:00:00
#PBS -q yourjobqueuename
#PBS -j oe
#PBS -o psr_srch_generic_pbs.log
#
#     BASIC PSR SEARCH SCRIPT 
#        
#           \ 
#            \ *
#             ------\
#                    \                
#
#     Search @ L-band .fits files 
#         
#
#     Search Software: PulsarX (https://github.com/ypmen/PulsarX) 
#                      presto  (https://github.com/scottransom/presto)
#  
#     Apptainer (formerly Singularity) image files: psr_tools2.sif
#                                                   pulsarx.sif
#                                                   (https://github.com/gdesvignes)
#
#
#     If you make use of these scripts, please cite the above software repos and my
#     git repo: https://github.com/r-eatough for the scripts
#
#     R. P. Eatough 03/08/2025




# SET NECESSARY VARIABLES (these will need to be changed!)

# target i.e. the source, now set here. Note difference to pbs submit where target is on pbs submit command line
export target=G0-1_swiftcalibration_3-M08

# raw data location. In this case its a random file for running a benchmark
export DATA_DIR=/home/reatough/projects/Bench/data

# script directory
export SCRIPT_DIR=/home/reatough/projects/Bench/scripts

# software directory
export SOFT_DIR=/home/reatough/Soft/apptainer

# observation date
export OBS_DATE=20220626

# multibeam ID
export BEAM=M08

# processing directory
export PROC_DIR=/home/reatough/projects/Bench/processing

# final results location
export RESULTS_DIR=/home/reatough/projects/Bench/results

echo $DATA_DIR
echo $OBS_DATE
echo $BEAM
echo $PROC_DIR
echo $RESULTS_DIR


# CALL WORKER SCRIPTS and bind the directories in container environment ...

# copy or sym link the raw .fits data to the working dir and check headers etc
apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/psr_tools2.sif $SCRIPT_DIR/symlink_cpy_psrfits.sh $target $OBS_DATE $BEAM $PROC_DIR $DATA_DIR

# dedisperse (1). dedisp split in four chunks due to file open limit!
prlimit -n4096 apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/pulsarx.sif $SCRIPT_DIR/dedisperse_all_psrfits.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# dedisperse (2). dedisp split in four chunks due to file open limit! 
prlimit -n4096 apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/pulsarx.sif $SCRIPT_DIR/dedisperse_all_psrfits_Prime.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# UNUSED DEDISPERSION TRIALS (add or remove as needed).
# dedisperse (3). dedisp split in four chunks due to file open limit! 
#prlimit -n4096 apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/pulsarx.sif $SCRIPT_DIR/dedisperse_all_psrfits_PrimePrime.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# dedisperse (4). dedisp split in four chunks due to file open limit! 
#prlimit -n4096 apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/pulsarx.sif $SCRIPT_DIR/dedisperse_all_psrfits_PrimePrimePrime.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# fft and acceleration search (Calling new conatainer -- psr_tools2.sif -- with parallel installed!)
prlimit -n4096 apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/psr_tools2.sif $SCRIPT_DIR/accelsearch_all_psrfits.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# sift candidates
prlimit -n4096 apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/psr_tools2.sif $SCRIPT_DIR/sift_all_psrfits.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# fold candidates
prlimit -n4096 apptainer run -e -B $DATA_DIR:/mnt/data,$PROC_DIR:/mnt/processing,$RESULTS_DIR:/mnt/results /path/to/software/container/pulsarx.sif $SCRIPT_DIR/fold_all_psrfits.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR $RESULTS_DIR




echo "done"

exit



