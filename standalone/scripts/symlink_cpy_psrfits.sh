#!/bin/bash
#
# Batch script to symlink and check .fits or .xz files.
# 
# R. P. Eatough 20/05/2024
#
#
#
# singularity shell is set up outside this bash script in pbs singularity run command. 
# 
# This script takes three input parameters: source obsdate beam
#


echo $HOSTNAME" copying and checking .fits or .xz data ... "

# go to PID processing directory (modified below to run outside of container)
#pwd
#cd /mnt/processing
#pwd

# collect source name and beam number (modified below to run outside of container)
export source=$1
export obsdate=$2
export beam=$3
export proc_dir=$4 
export data_dir=$5

# modified from above
pwd
cd $proc_dir
pwd


# make directories
mkdir $source
mkdir $source/$obsdate

# remove old _beam_ directory
cd $source/$obsdate/
rm -rf $beam
mkdir $beam
cd $beam
pwd

# BENCHM
touch START_$HOSTNAME".bench"
#touch cpy_start.bench
#touch cpy_end.bench
#date >> cpy_start.bench
date +%s >> START_$HOSTNAME".bench"


# get md5sum of raw data before and later after copy:
#touch releaseData.md5s
#touch workingData.md5s

# md5sum before copy - OPTIONAL
#for i in *.fits                      
#	do
#		md5sum $i >> releaseData.md5s
#	done

 
# sym link data ...
echo " ..."
echo "data dir looks like ... "
#ls /mnt/data/*.fits
ls $data_dir/*.fits
#ln -s /mnt/data/$beam/$source"_"*.fits . 
#ln -s $data_dir/$beam/$source"_"*.fits .
#ln -s $data_dir/$source"_"*.fits . # link doesnt work
rsync -av --progress $data_dir/$source"_"*.fits .


export nfits=`ls -1 *.fits | wc -l`

echo "Linked "$nfits" .fits files ..." 
ls -lh *.fits  

# md5sum after copy - OPTIONAL
#for j in *.fits
#        do
#                md5sum $j >> workingData.md5s
#        done



# also, read file headers - OPTIONAL  
#for i in *.fits
#	do
#		echo "Accessing "$i
#		fitsheader $i 
#		echo "Read "$i
#	done	


echo "done"
#date >> cpy_end.bench
echo "Next step is dedispersion ..."

exit

 
 
