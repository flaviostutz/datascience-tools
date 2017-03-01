#! /bin/bash

#This script schedules a shutdown some minutes before a full instance hour is completed
#If no other process performs a 'shutdown -c' to cancel the shutdown, the machine 
#will be stopped.
#See http://stackoverflow.com/questions/15899544/shutdown-ec2-instance-if-idle-right-before-another-billable-hour

t=/tmp/ec2.running.seconds.$$
if wget -q -O $t http://169.254.169.254/latest/meta-data/local-ipv4 ; then
    # add 60 seconds artificially as a safety margin
    let runningSecs=$(( `date +%s` - `date -r $t +%s` ))+60
    rm -f $t
    let runningSecsThisHour=$runningSecs%3600
    let runningMinsThisHour=$runningSecsThisHour/60
    let leftMins=60-$runningMinsThisHour
    # start shutdown one minute earlier than actually required
    let shutdownDelayMins=$leftMins-1
    if [[ $shutdownDelayMins > 1 && $shutdownDelayMins < 60 ]]; then
        echo "Chicken game started! To avoid shutting down, type 'shutdown -c'"
        echo "Shutting down in $shutdownDelayMins mins."
        # TODO: Notify off-instance listener that the game of chicken has begun
        sudo shutdown -h +$shutdownDelayMins
    else
        echo "Shutting down now."
        sudo shutdown -h now
    fi
    exit 0
fi
echo "Failed to determine remaining minutes in this billable hour. Terminating now."
sudo shutdown -h now
exit 1
