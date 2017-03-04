#!/bin/bash

#THIS IS MEANT TO RUN ON AWS SPOT MACHINES BOOT
#This machine will be started/stopped at any time without human intervention. Everything must be saved automatically and the machine has to resume previous work with minimal loss

#Copy this script contents, modify it and put on field "user-fields" of your EC2 instance (Spot or On Demand) so that it will be run during startup. Ubuntu and Amazon Linux are known to work.

set -v
#set -e

echo "========= BOOT START ==========="
date

echo "configure aws-cli"
aws configure set aws_access_key_id aaaaaaaaaaaaaaaaaaaa
aws configure set aws_secret_access_key bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
aws configure set default.region us-east-1

#set current dir to script's dir
work_dir=$(dirname $(realpath $0))
echo $work_dir

echo "Shutdown if cpu gets idle"
(crontab -l 2>/dev/null; echo "*/1 * * * * $work_dir/aws-shutdown-if-idle.sh >> /var/log/shutdown-if-idle.log") | crontab -

cd $work_dir

echo "Mount input dir volume"
./aws-mount-volume.sh vol-0722469c92cd5b04f /dev/xvdf /mnt/input
rm /root/input & ln -s /mnt/input /root/input

echo "Mount output dir volume"
./aws-mount-volume.sh vol-00e3a30520a156907 /dev/xvdg /mnt/output
rm /root/output & ln -s /mnt/output/output /root/output

echo "git clone scripts repo"
cd /root
git clone https://github.com/flaviostutz/datascience-snippets.git
cd $work_dir

#point autorun script that will be run on container start
ln datascience-snippets/autorun.sh /root/autorun.sh

echo "Starting datascience tools container"
./start-container.sh

date
echo "========= BOOT END ========="
