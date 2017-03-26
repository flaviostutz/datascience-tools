#!/bin/bash

nvidia-docker rm -f jupyter

docker pull flaviostutz/datascience-tools:latest-gpu

nvidia-docker run -d --rm -e PASSWORD=flaviostutz -v /notebooks:/notebooks -v /notebooks/input:/notebooks/input -v /notebooks/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools:latest-gpu
