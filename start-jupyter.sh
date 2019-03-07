#!/bin/bash

echo "Starting Jupyter..."

# export SPARK_HOME=/opt/spark
# export PATH=$SPARK_HOME/bin:$PATH
# export PYSPARK_SUBMIT_ARGS="--master $SPARK_MASTER"

jupyter notebook "$@" --ip 0.0.0.0 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.notebook_dir='/notebooks'

