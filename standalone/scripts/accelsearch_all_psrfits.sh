#!/bin/bash
#
# Script to run presto acceleration search (utilizing parallel)
# and single pulse job in the batch queue.
# 
# R. P. Eatough 27/05/2024
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


cd $proc_dir

# directories should have been made during dedispersion
cd $source/$obsdate/$beam


# BENCHM
touch accelsearch_start.bench
touch accelsearch_end.bench
date >> accelsearch_start.bench

# first we need to divide up the .dat files into manageable chunks 
echo "Dividing up the time series ..."
ls -1rt *.dat | head -2048 > SPLIT_1
ls -1rt *.dat | head -4096 | tail -2048 > SPLIT_2
ls -1rt *.dat | head -6144 | tail -2048 > SPLIT_3
ls -1rt *.dat | tail -2048 > SPLIT_4

cat SPLIT_1 | sed "s/J0000-00_ifbf00018_Plan1_1_DM//g" | sed "s/.dat//g" >> SPLIT_1.mod
sort -g SPLIT_1.mod >> SPLIT_1.mod.sort

cat SPLIT_2 | sed "s/J0000-00_ifbf00018_Plan1_1_DM//g" | sed "s/.dat//g" >> SPLIT_2.mod
sort -g SPLIT_2.mod >> SPLIT_2.mod.sort

cat SPLIT_3 | sed "s/J0000-00_ifbf00018_Plan1_1_DM//g" | sed "s/.dat//g" >> SPLIT_3.mod
sort -g SPLIT_3.mod >> SPLIT_3.mod.sort

cat SPLIT_4 | sed "s/J0000-00_ifbf00018_Plan1_1_DM//g" | sed "s/.dat//g" >> SPLIT_4.mod
sort -g SPLIT_4.mod >> SPLIT_4.mod.sort

# process each split independently 
echo "Starting ffts and accelsearch  ..."


echo "Working on SPLIT1 ..."
mkdir SPLIT_1_proc
for dm in `cat SPLIT_1.mod.sort`
do 
    mv $dm".dat" SPLIT_1_proc/
    mv $dm".inf" SPLIT_1_proc/
done
cd SPLIT_1_proc/
#ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/realfft {}"
#ls *.fft | parallel -j 32 "accelsearch -numharm 32 -zmax 20 {}"
ls *.dat | parallel -j 32 "realfft {}"
ls *.fft | parallel -j 32 "accelsearch -numharm 32 -zmax 20 {}"
#ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/single_pulse_search.py -m 300 -b {}"
mv * ../
cd ..


echo "Working on SPLIT2 ..."
mkdir SPLIT_2_proc
for dm in `cat SPLIT_2.mod.sort`
do 
    mv $dm".dat" SPLIT_2_proc/
    mv $dm".inf" SPLIT_2_proc/
done
cd SPLIT_2_proc/
#ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/realfft {}"
#ls *.fft | parallel -j 32 "accelsearch -numharm 32 -zmax 20 {}"
ls *.dat | parallel -j 32 "realfft {}"
ls *.fft | parallel -j 32 "accelsearch -numharm 32 -zmax 20 {}"
#ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/single_pulse_search.py -m 300 -b {}"
mv * ../
cd ..


#echo "Working on SPLIT3 ..."
#mkdir SPLIT_3_proc
#for dm in `cat SPLIT_3.mod.sort`
#do 
#    mv $dm".dat" SPLIT_3_proc/
#    mv $dm".inf" SPLIT_3_proc/
#done
#cd SPLIT_3_proc/
#ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/realfft {}"
#ls *.fft | parallel -j 32 "accelsearch -numharm 32 -zmax 20 {}"
##ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/single_pulse_search.py -m 300 -b {}"
#mv * ../
#cd ..


#echo "Working on SPLIT4 ..."
#mkdir SPLIT_4_proc
##for dm in `cat SPLIT_4.mod.sort`
##do 
#    mv $dm".dat" SPLIT_4_proc/
#    mv $dm".inf" SPLIT_4_proc/
#done
#cd SPLIT_4_proc/
#ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/realfft {}"
#ls *.fft | parallel -j 32 "accelsearch -numharm 32 -zmax 20 {}"
##ls *.dat | parallel -j 32 "/home/psr/software/presto/bin/single_pulse_search.py -m 300 -b {}"
#mv * ../
#cd ..


# make single pulse plot (might need to tweak threshold -t )

# FULL DM range:
#/home/psr/software/presto/bin/single_pulse_search.py -t 6 -b *.singlepulse
#mv J0000-00_ifbf000*_Plan1_1_singlepulse.ps J0000-00_ifbf00000_Plan1_1_singlepulse_DM0-1000.ps

# add some zoomed in single pulse plots ...

# DM 0 - 10: 
#single_pulse_search.py -t 6 -b -g "./J0000-00_ifbf000*_Plan1_1_DM[0-9].[0-9][0-9]*.singlepulse"
#mv J0000-00_ifbf000*_Plan1_1_singlepulse.ps J0000-00_ifbf00000_Plan1_1_singlepulse_DM0-10.ps

# DM 0 - 100: 
#single_pulse_search.py -t 6 -b -g "./J0000-00_ifbf000*_Plan1_1_DM[0-9][0-9].[0-9][0-9]*.singlepulse"
#mv J0000-00_ifbf000*_Plan1_1_singlepulse.ps J0000-00_ifbf00000_Plan1_1_singlepulse_DM0-100.ps

# DM 100 - 500:
#single_pulse_search.py -t 6 -b -g "./J0000-00_ifbf000*_Plan1_1_DM[1-4][0-9][0-9].[0-9][0-9]*.singlepulse"
#mv J0000-00_ifbf000*_Plan1_1_singlepulse.ps J0000-00_ifbf00000_Plan1_1_singlepulse_DM100-500.ps

# DM 400 - 1000: 
#single_pulse_search.py -t 6 -b -g "./J0000-00_ifbf000*_Plan1_1_DM[4-9][0-9][0-9].[0-9][0-9]*.singlepulse"
#mv J0000-00_ifbf000*_Plan1_1_singlepulse.ps J0000-00_ifbf00000_Plan1_1_singlepulse_DM400-1000.ps





date >> accelsearch_end.bench


echo "done"
exit



 
 
