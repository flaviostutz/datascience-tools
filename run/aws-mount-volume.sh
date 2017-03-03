#!/bin/bash

DATA_VOLUME_ID=$1
DEV_PATH=$2
MOUNT_PATH=$3

if [ "$DATA_VOLUME_ID" == "" ]; then
   echo "Usage: mount [volume-id] [dev-path] [mount-path]"
   exit 1
fi

if [ "$MOUNT_PATH" == "" ]; then
   echo "Usage: mount [volume-id] [dev-path] [mount-path]"
   exit 1
fi

if [ "$DEV_PATH" == "" ]; then
   echo "Usage: mount [volume-id] [dev-path] [mount-path]"
   exit 1
fi

echo "Umounting EBS volume $DATA_VOLUME_ID from any machine"
umount $MOUNT_PATH 
aws ec2 detach-volume --volume-id $DATA_VOLUME_ID


echo "Mounting EBS data volume $DATA_VOLUME_ID to this instance"
set -e
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
echo "-- waiting for volume to become available"
aws ec2 wait volume-available --volume-ids $DATA_VOLUME_ID
echo "-- attaching volume to this instance"
aws ec2 attach-volume --instance-id $instance_id --device $DEV_PATH --volume-id $DATA_VOLUME_ID
echo "-- waiting for attachment to be done"
aws ec2 wait volume-in-use --volume-ids $DATA_VOLUME_ID
sleep 3
mkdir -p $MOUNT_PATH
echo "-- mounting SO partition ${DEV_PATH}1 to $MOUNT_PATH"
mount ${DEV_PATH}1 $MOUNT_PATH

