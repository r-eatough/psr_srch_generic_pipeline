# pulsar_search_generic_pipeline
Often one needs a quick method to process pulsar search data. Because pulsar search pipelines can be very complex, with many dependencies, here I've tried to make a simple set of bash scripts that call the commonly used search software from a container (like this one: https://github.com/r-eatough/pulsar_docker) running on your system.

I've provided two versions of the scripts; one stand-alone version to run from the command line, and another that can be submitted to a typical pbs job queue.  

After creating a simple directory structure this should just work. The directory structure I recommend is the following:

DATA

SCRIPTS

PROCESSING

RESULTS

## standalone bash script
TBD

## pbs bash script (to submit to a pbs job queue)
TBD
