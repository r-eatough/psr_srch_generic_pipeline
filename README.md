# pulsar_search_generic_pipeline
Often one needs a quick method to process pulsar search data. While the search software used is complex, the data processing pipeline can be as simple as a c-shell, bash or python script. Here are a simple set of bash scripts that call the commonly used search software on pulsar .fits files. 

Two versions of the scripts are provided: 1.) a stand-alone version to run from the command line (dependencies _presto_ & _PulsarX_), 2.) a version that can be submitted to a typical _pbs_ job queue which runs the software from a container (like this one: https://github.com/r-eatough/pulsar_docker) using _apptainer_. 

The latter is very useful for HPC applications because pulsar search software may have many dependencies that are unavailable or require installation by the administrator on new hardware.  

After creating a simple directory structure the scripts should just work; of course probably after some minor tweaking ;) Also, the type and scope of processing can be adjusted by modifying the worker scripts. The recommended directory structure is the following:

    DATA_DIR=/path/to/your/data
    SCRIPT_DIR=/path/to/your/worker/scripts
    PROCESSING_DIR=/path/to/your/working/directory
    RESULTS_DIR=/path/to/processing/results

When using PulsarX with presto, as in this pipeline, some other directories I'd also suggest are

    DD_plans=/path/to/directory/of/dedispersion/plans
    ACCEL_sifts=/path/to/directory/of/accel_sift/scripts

Now here's a list of the worker scripts that the pipeline calls ...

    symlink_cpy_psrfits.sh  -- copies or sym links data to working directory
    dedisperse_all_psrfits.sh  -- first block of dedispersion
    dedisperse_all_psrfits_Prime.sh  -- more dedispersion
    dedisperse_all_psrfits_PrimePrime.sh  -- more dedispersion
    dedisperse_all_psrfits_PrimePrimePrime.sh  -- more dedispersion
    accelsearch_all_psrfits.sh  -- find pulsar signals 
    sift_all_psrfits.sh  -- sift and combine repeated detections 
    fold_all_psrfits.sh  -- fold sifted detections to make pulsar candidates to be viewed 
    
The reason that the dedispersion stages are repeated is purely due to hardware limitations. For example, in this example dedispersion of 2048 timeseries simultaneously was comfortable for the hardware used. This can be increased or decreased accordingly. Most of the time is spent in the acceleration search, so once again, this can be tweaked to optimize the running time.   

## 1.) standalone bash script using installed software
TBD

## 2.) pbs bash script (to submit to a pbs job queue) running a software container
TBD
