# Datascience tools container

This container was created to support various experimentations on Datascience, mainly in the context of Kaggle competitions.

**Bundled tools:**

- Based on Ubuntu 16.04
- Python 3
- Jupyter
- TensorFlow (CPU and GPU flavors)
- Scoop, h5py, pandas, scikit, TFLearn, plotly
- pyexcel-ods, pydicom, textblob, wavio, trueskill, cytoolz, ImageHash...

**Run container:**

   - CPU only:
      - `docker run -d -v /root:/notebooks -v /root/input:/notebooks/input -v /root/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools`
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
   - If you wish this container to run automatically on host boot, add these lines on /etc/rc.local:
      - `cd /root/datascience-tools/run
         ./boot.sh >> /var/log/boot-script`
      - Change "/root/datascience-tools" to where you cloned this repo


**Autorun script:**

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

**Access:**

   - http://[ip]:8888 for Jupyter
   - http://[ip]:6006 for TensorBoard

**Build container:**

   - `docker-compose build`
     OR
   - `docker build . -f Dockerfile`
   - `docker build . -f Dockerfile-gpu`

