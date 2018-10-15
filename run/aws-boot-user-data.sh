#!/bin/bash

#THIS IS MEANT TO RUN ON AWS SPOT MACHINES BOOT
#This machine will be started/stopped at any time without human intervention. Everything must be saved automatically and the machine has to resume previous work with minimal loss
#Copy this script contents, modify it and put on field "user-fields" of your EC2 instance (Spot or On Demand) so that it will be run during startup. Ubuntu and Amazon Linux are known to work.

echo "========= BOOT START ==========="
date

echo "configure aws-cli"
aws configure set aws_access_key_id aaaaaaaaaaaaaaaaaaaaaa
aws configure set aws_secret_access_key bbbbbbbbbbbbbbbbbbbbbbbbbb
aws configure set default.region us-east-1

git config --global user.email "flaviostutz@gmail.com"
git config --global user.name "flaviostutz"

mkdir /notebooks
cd notebooks
git clone https://github.com/flaviostutz/datascience-tools.git

echo "set current dir to /notebooks/datascience-tools/run"
work_dir=/notebooks/datascience-tools/run
cd $work_dir

echo "Shutdown if cpu gets idle"
(crontab -l 2>/dev/null; echo "*/5 * * * * $work_dir/aws-shutdown-if-idle.sh >> /var/log/shutdown-if-idle.log") | crontab -

echo "Mount input dir volume"
./aws-mount-volume.sh vol-063ca73106323fef2 /dev/xvdf /mnt/input
rm /notebooks/input
ln -s /mnt/input /notebooks/input

echo "Mount output dir volume"
./aws-mount-volume.sh vol-008b02ff1c1897977 /dev/xvdg /mnt/output
rm /notebooks/output
ln -s /mnt/output/output /notebooks/output

echo "git clone scripts repo"
cd /notebooks
git clone https://github.com/flaviostutz/datascience-snippets.git
cd $work_dir

#point autorun script that will be run on container start
rm /notebooks/autorun.sh
ln /notebooks/datascience-snippets/autorun.sh /notebooks/autorun.sh

echo "Starting datascience tools container"
./start-container.sh

date
echo "========= BOOT END ========="
