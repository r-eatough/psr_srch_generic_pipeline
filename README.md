# pulsar_search_generic_pipelines
Often one needs a quick method to process pulsar search data. Because pulsar search pipelines can be very complex - with many dependencies that are unavailable or require installation on new hardware - here is a simple set of bash scripts that call the commonly used search software from a container (like this one: https://github.com/r-eatough/pulsar_docker) running on your system.

Two versions of the scripts are proovided: one stand-alone version to run from the command line; and another that can be submitted to a typical _pbs_ job queue.  

After creating a simple directory structure the scripts should just work; of course probably after some minor tweaking ;) The recommended directory structure is the following:

    DATA_DIR=/path/to/your/data
    SCRIPT_DIR=/path/to/your/scripts
    PROCESSING_DIR=/path/to/your/working/directory
    RESULTS_DIR=/path/to/processing/results

When using PulsarX with presto, as in this pipeline, some other directories I'd also suggest are

    DD_plans=/path/to/directory/of/dedispersion/plans
    ACCEL_sifts=/path/to/directory/of/accel_sift/scripts

Now here's a list of the worker scripts that the pipeline calls ...

    symlink_cpy_psrfits.sh
    dedisperse_all_psrfits.sh
    dedisperse_all_psrfits_Prime.sh
    dedisperse_all_psrfits_PrimePrime.sh
    dedisperse_all_psrfits_PrimePrimePrime.sh
    accelsearch_all_psrfits.sh
    sift_all_psrfits.sh
    fold_all_psrfits.sh
    


## standalone bash scripts
TBD

## pbs bash scripts (to submit to a pbs job queue)
TBD
