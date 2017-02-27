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
      - `docker-compose up tensorflow-cpu -d` OR
      - `docker run -d -v /root:/notebooks -v /root/input:/notebooks/input -v /root/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools`
   - GPU support for TensorFlow:
      - Prepare host machine with NVIDIA Cuda drivers
        - apt-get install cuda-drivers
        - http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/accelerated-computing-instances.html
      - Install nvidia-docker (https://github.com/NVIDIA/nvidia-docker)
      - `nvidia-docker run -d -v /root:/notebooks -v /root/input:/notebooks/input -v /root/output:/notebooks/output -p 8888:8888 -p 6006:6006 --name jupyter flaviostutz/datascience-tools:latest-gpu`

**Build container:**

   - docker-compose build 
     OR
   - docker build . -f Dockerfile
   - docker build . -f Dockerfile-gpu

**Access:**

   - http://[ip]:8888 for Jupyter
   - http://[ip]:6006 for TensorBoard
