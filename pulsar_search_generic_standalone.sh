#!/bin/sh
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




# CALL WORKER SCRIPTS ...

# copy or sym link the raw .fits data to the working dir and check headers etc
$SCRIPT_DIR/symlink_chk_fits_file_mkI.sh $target $OBS_DATE $BEAM $PROC_DIR $DATA_DIR

# dedisperse (1). dedisp split in four chunks due to file open limit!
prlimit -n4096 $SCRIPT_DIR/dedisperse_all_psrfits_mkIV.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# dedisperse (2). dedisp split in four chunks due to file open limit! 
prlimit -n4096 $SCRIPT_DIR/dedisperse_all_psrfits_mkIV_Prime.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# UNUSED DEDISPERSION TRIALS (add or remove as needed).
# dedisperse (3). dedisp split in four chunks due to file open limit! 
#prlimit -n4096 $SCRIPT_DIR/dedisperse_all_psrfits_mkIV_PrimePrime.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# dedisperse (4). dedisp split in four chunks due to file open limit! 
#prlimit -n4096 $SCRIPT_DIR/dedisperse_all_psrfits_mkIV_PrimePrimePrime.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# fft and acceleration search (Calling new conatainer -- psr_tools2.sif -- with parallel installed!)
prlimit -n4096 $SCRIPT_DIR/accelsearch_all_psrfits_mkVIII.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# sift candidates
$SCRIPT_DIR/sift_all_psrfits_mkIV.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR

# fold candidates
prlimit -n4096 $SCRIPT_DIR/fold_all_psrfits_mkVIII_deep1.sh $target $OBS_DATE $BEAM $PROC_DIR $SCRIPT_DIR $RESULTS_DIR




echo "done"

exit



