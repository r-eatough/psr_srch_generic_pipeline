# pulsar_search_generic_pipeline
Often one needs a quick method to process pulsar search data. Because pulsar search pipelines can be very complex - with many dependencies that are unavailable or require installation on new hardware - here I've tried to make a simple set of bash scripts that call the commonly used search software from a container (like this one: https://github.com/r-eatough/pulsar_docker) running on your system.

I've provided two versions of the scripts; one stand-alone version to run from the command line, and another that can be submitted to a typical pbs job queue.  

After creating a simple directory structure this should just work; likely after some minor tweaking ;). The directory structure I recommend is the following:

    DATA_DIR=/path/to/your/data
    SCRIPT_DIR=/path/to/your/scripts
    PROCESSING_DIR=/path/to/your/working/directory
    RESULTS_DIR=/path/to/processing/results

## standalone bash scripts
TBD

## pbs bash scripts (to submit to a pbs job queue)
TBD
