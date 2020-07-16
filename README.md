# Datascience tools container

<img src="https://img.shields.io/docker/automated/flaviostutz/datascience-tools"/>

This container was created to support various experimentations on Datascience, mainly in the context of Kaggle competitions.

**Bundled tools:**

- Based on Ubuntu 16.04
- Python 3
- Jupyter
- TensorFlow (CPU and GPU flavors)
- Spark driver (set SPARK_MASTER ENV pointing to your Spark Master)
  - For creating a Spark Cluster, you can check https://github.com/flaviostutz/spark-swarm-cluster
- Scoop, h5py, pandas, scikit, TFLearn, plotly
- pyexcel-ods, pydicom, textblob, wavio, trueskill, cytoolz, ImageHash...

## Run container:

   - CPU only:

      * create docker-compose.yml

      ```
      version: "3"
      services:
        datascience-tools:
          image: flaviostutz/datascience-tools
          ports:
            - 8888:8888
            - 6006:6006
          volumes:
            - /notebooks:/notebooks
          environment:
            - JUPYTER_TOKEN=flaviostutz
      ```
      * `docker-compose up`

   - GPU support for TensorFlow:
      - **Prepare host machine with NVIDIA Cuda drivers**
         - `sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub`
         - `sudo sh -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list'`
         - `sudo apt-get update && sudo apt-get install -y --no-install-recommends cuda-drivers`
         - http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/accelerated-computing-instances.html
      - **Install nvidia-docker and nvidia-docker-plugin**
         - `wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0/nvidia-docker_1.0.0-1_amd64.deb`
         - `sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb`
         - Install nvidia-docker (https://github.com/NVIDIA/nvidia-docker)
      - `nvidia-docker run -d -v /root:/notebooks -v /root/input:/notebooks/input -v /root/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools:latest-gpu`
   - If you wish this container to run automatically on host boot, add these lines to /etc/rc.local:
      - `cd /root/datascience-tools/run
         ./boot.sh >> /var/log/boot-script`
      - Change "/root/datascience-tools" to where you cloned this repo

**Access:**

- http://[ip]:8888 for Jupyter
- http://[ip]:6006 for TensorBoard

## Autorun script

   - When this container starts, it runs:
      - Jupyter Notebook server on port 8888
      - TensorBoard server on port 6006
      - A custom script located at /notebooks/autorun.sh
         - If autorun.sh doesn't exist, it is ignored 
         - If it exists, everytime you start/restart the container it will be run once
         - You can use this script when running large batch processes on servers that could boot/shutdown at random (like what happens when using AWS Spot Instances), so that when the server restarts this script can resume previous work
         - Make sure you control partial save/resume for optimal computing usage
         - On the host OS, you have to run this docker container with "--restart=always" so that it will be started automatically during boot
         - It is possible to edit this file with Jupyter editor
         - Example script:
            - `#!/bin/bash
               python test.py`

## Build instructions

- `docker build . -f Dockerfile`
- `docker build . -f Dockerfile-gpu`

## Tips for development of your own Notebooks

- A good practice is to store your notebook scripts in a git repository
  - Ex.: http://github.com/flaviostutz/puzzler

- Run datascience-tools container and map the volume "/notebooks", inside the container, to the path you cloned your git repository in your computer

- You can edit/save/run the scripts from the web interface (http://localhost:8888) or directly with other tools on your computer. You can commit and push your code to the  repository directly (no copy from/to container is needed because the volume is mapped)
```
version: "3"
services:
   datascience-tools:
      image: flaviostutz/datascience-tools
      ports:
      - 8888:8888
      - 6006:6006
      volumes:
      - /Users/flaviostutz/Documents/development/flaviostutz/puzzler/notebooks:/notebooks
```

- For running in production, create a new container with "FROM flaviostutz/datascience-tools" and add your script files to "/notebooks" so when you run the container it will have your custom scripts embedded into it. No "volume" mapping is needed for this container. During container startup, script /notebooks/autorun.sh will run if present.

## ENVs variables

- JUPYTER_TOKEN - token needed for the users to open Jupyter. defaults to '', so that no token or password will asked to the user

- SPARK_MASTER - Spark master address. Used if you want to send jobs to an external Spark cluster and still control the whole job from Jupyter Notebook itself.
