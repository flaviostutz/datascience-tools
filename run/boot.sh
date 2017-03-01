#!/bin/bash

set -v

echo "========= BOOT START ==========="
date

#THIS IS MEANT TO RUN ON AWS SPOT MACHINES BOOT (put in rc.local)
#This machine will be started/stopped at any time without human intervention. Everything must be saved automatically and the machine has to resume previous work with minimal loss
#Call this script including the following line on host's /etc/rc.local
#/root/datascience-snippets/run/boot.sh

#if no one monitors real cpu usage (no idle), shutdown it automatically
./aws-chicken-game.sh


echo "Umounting EBS volume from any machine"
DATA_VOLUME_ID=vol-00e3a30520a156907
umount /mnt/datascience-input-output
aws ec2 detach-volume --volume-id $DATA_VOLUME_ID


echo "Mounting EBS data volume to this instance"
set -e
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
echo "-- waiting for volume to become available"
aws ec2 wait volume-available --volume-ids $DATA_VOLUME_ID
echo "-- attaching volume to this instance"
aws ec2 attach-volume --instance-id $instance_id --device /dev/xvdf --volume-id $DATA_VOLUME_ID
echo "-- waiting for attachment to be done"
aws ec2 wait volume-in-use --volume-ids $DATA_VOLUME_ID
sleep 3
mkdir -p /mnt/datascience-input-output
echo "-- mounting SO partition"
mount /dev/xvdf1 /mnt/datascience-input-output


echo "Starting datascience tools container"
./start-container.sh

date
echo "========= BOOT END ========="
