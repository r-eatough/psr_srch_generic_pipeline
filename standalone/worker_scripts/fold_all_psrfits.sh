#!/bin/bash
#
# Script to run pulsarx folding
# job in the batch queue.
# 
# R. P. Eatough 24/05/2024
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
export results_dir=$6

cd $proc_dir

# directories should have been made during dedispersion
cd $source/$obsdate/$beam

# BENCHM
touch FINISH_$HOSTNAME".bench"
#touch fold_start.bench
#touch fold_end.bench
#date >> fold_start.bench

# skim the cream 
#cat candidates.txt | sort -gr -k 6 | head -20 > candidates.txt.cream

# fold the candidates! remember to set the subint length -L according to the obs length to make e.g. 64 or 128 subints!
# f0 f1 search
psrfold_fil2 --psrfits -v --candfile candidates.txt --template /home/pulsarx/software/PulsarX/include/template/fast_fold.template --plotx -n 64 -b 64 -L 2 --incoherent --clfd 2 -f *.fits --cont -t 8 --zapthre 3.0 -z kadaneF 8 4 zdot  --nbinplan 0.1 128 0.02 64 0.01 32

# no f0 f1 search
#psrfold_fil2 --psrfits -v --candfile candidates.txt.cream --template /home/pulsarx/software/PulsarX/include/template/fast_fold.template --plotx -n 64 -b 64 -L 13.140625 --nof0search --nof1search --incoherent --clfd 2 -o NOSEARCH -f *.fits --cont -t 8 --zapthre 3.0 -z kadaneF 8 4 zdot  --nbinplan 0.1 128 0.02 64 0.01 32


#date >> fold_end.bench

# make results dir
mkdir $results_dir/$source
mkdir $results_dir/$source/$obsdate
# remove old beam dir, then make a new one
rm -rf $results_dir/$source/$obsdate/$beam
mkdir $results_dir/$source/$obsdate/$beam

echo "copying candidate plots ..."
# copy out the candidates to results dir
cp *.png $results_dir/$source/$obsdate/$beam/

echo "copying archive .ar files, ... these could be useful!"
cp *.ar $results_dir/$source/$obsdate/$beam/

echo "copying all the candidate lists ..."
cp candidates.txt $results_dir/$source/$obsdate/$beam/
cp candidates.txt.cream $results_dir/$source/$obsdate/$beam/


echo "copying single pulse cands and .inf files and the full singlepulse .ps plot..."
tar -cvf singlepulse_inf_files.tar *.singlepulse *.inf
gzip singlepulse_inf_files.tar
cp singlepulse_inf_files.tar.gz $results_dir/$source/$obsdate/$beam/
cp *_singlepulse_*.ps $results_dir/$source/$obsdate/$beam/


#echo "copying md5sums ..."
#cp *.md5s /mnt/results/$source/$obsdate/$beam/

date +%s >> FINISH_$HOSTNAME".bench"


#echo "copying benchmarks ..."
cp *.bench $results_dir/$source/$obsdate/$beam/

# rename results dir based on hostname
mv $results_dir/$source $results_dir/$source"_"$HOSTNAME

#echo "removing .dat and .fft files"
rm -f *.dat
rm -f *.fft

#echo "Removing fits files ..."
rm -f *.fits

echo "Removing everything else from processing dir ..."
cd $proc_dir
rm -rf $source

# leave a seal
#touch $source"_seal"
#echo "This file indicates that "$source" has been processed and proc dir was removed." >> $source"_seal"

#echo "Here's the sharmed memory on" $HOSTNAME
#ls -lrt /dev/shm/

echo "done"
exit

 
 
