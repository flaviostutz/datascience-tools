#!/bin/bash

docker run -d -v /root:/notebooks -v /root/input:/notebooks/input -v /root/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools:latest 

#nvidia-docker run -d -v /root:/notebooks -v /root/input:/notebooks/input -v /root/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools:latest-gpu
