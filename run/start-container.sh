#!/bin/bash

nvidia-smi
if [ $? -eq 0 ]; then
    echo "STARTING CONTAINER WITH GPU SUPPORT"
    ./aws-optimize-gpu.sh
    ./start-docker-run-gpu.sh

else
    echo "STARTING CONTAINER WITHOUT GPU SUPPORT"
    ./start-docker-run-cpu.sh

fi

