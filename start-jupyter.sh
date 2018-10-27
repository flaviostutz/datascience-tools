#!/bin/bash

echo "Starting Jupyter..."

export SPARK_HOME=/opt/spark
export PATH=$SPARK_HOME/bin:$PATH
export PYSPARK_SUBMIT_ARGS="--master $SPARK_MASTER"

jupyter notebook "$@" --allow-root
