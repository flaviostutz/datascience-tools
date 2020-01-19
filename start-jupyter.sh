#!/bin/bash

echo "Starting Jupyter..."

# export SPARK_HOME=/opt/spark
# export PATH=$SPARK_HOME/bin:$PATH
# export PYSPARK_SUBMIT_ARGS="--master $SPARK_MASTER"

jupyter notebook "$@" --ip 0.0.0.0 --no-browser --allow-root --NotebookApp.allow_password_change=False --NotebookApp.token="$JUPYTER_TOKEN" --NotebookApp.password='' --NotebookApp.notebook_dir='/notebooks'

