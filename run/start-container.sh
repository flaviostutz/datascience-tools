#!/bin/bash

nvidia-smi
if [ $? -eq 0 ]; then
    echo "USING TENSORFLOW WITH GPU SUPPORT"
    ./docker-run-gpu.sh

else
    echo "USING TENSORFLOW WITHOUT GPU SUPPORT"
    ./docker-run-cpu.sh

fi

