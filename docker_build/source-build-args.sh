# Helper script for inlining docker build args from an .env like file format.
# Should be used as a back quote run as a docker build param. E.g:
# > docker build <DOCKER_PARAMS> `./source-build-args.sh <BUILD_ARGS_FILE>` <DOCKER_PARAMS> 

for i in `cat $1`; do out+="--build-arg $i " ; done; echo $out;out=""