#!/bin/bash

nvidia-smi
if [ $? -eq 0 ]; then
    echo "STARTING CONTAINER WITH GPU SUPPORT"
    ./docker-run-gpu.sh

else
    echo "STARTING CONTAINER WITHOUT GPU SUPPORT"
    ./docker-run-cpu.sh

fi

