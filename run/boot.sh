#!/bin/bash

#THIS IS MEANT TO RUN ON AWS SPOT MACHINES BOOT (put in rc.local)
#This machine will be started/stopped at any time without human intervention. Everything must be saved automatically and the machine has to resume previous work with minimal loss
#Call this script including the following line on host's /etc/rc.local
#/root/datascience-snippets/run/boot.sh

#mount a disk to store input/output files
mkdir -p /mnt/datascience-input-output
mount /dev/xvdf1 /mnt/datascience-input-output

./start-container.sh

#if no one handle cpu usage to maintain instance on, shutdown it automatically
./aws-chicken-game.sh