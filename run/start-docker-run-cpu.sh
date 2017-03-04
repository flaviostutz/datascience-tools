#!/bin/bash

docker rm -f jupyter

docker run -d --rm -v /root:/notebooks -v /root/input:/notebooks/input -v /root/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools:latest 

